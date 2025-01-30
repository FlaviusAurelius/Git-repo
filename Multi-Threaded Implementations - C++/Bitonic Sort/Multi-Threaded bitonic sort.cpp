#include <iostream>
#include <vector>

#include <fstream>
#include <chrono>
#include <algorithm>
#include <thread>
#include <mutex>
using namespace std;

ofstream out1("Output1.txt");
ofstream out2("Output2.txt");

class Timer {
public:
	chrono::system_clock::time_point Begin;
	chrono::system_clock::time_point End;
	chrono::system_clock::duration RunTime;
	Timer() {//constructor
		Begin = chrono::system_clock::now();
	}
	~Timer() {
		End = chrono::system_clock::now();
		RunTime = End - Begin;
		cout << "Run Time is " << chrono::duration_cast<chrono::microseconds>(RunTime).count() << "us" << endl;
	}
};



//Iterative 
void Sort1(vector<int>& Data);

//Recursive, true is ascending, false is descending
void Sort2(vector<int>& Data, int n1, int n2, bool Up);
void S2_recurse(vector<int>& Data, int n1, int n2, bool Up);
void S2_merge(vector<int>& Data, int n1, int n2, bool Up);

//function needed for threaded recursive bitonic sort
void pre_merge(vector<int>& Data, int n1, int n2, bool Up, int range);

int main() {
	int n{ 4096 }, m{ 100 }; //Data size, modify to your liking

	vector<int> Data(n);

	//single-threaded recursive bitonic sort
	for (auto& i : Data) i = rand() % m;
	{
		Timer T;
		//to modify the direction of which the vector is sorted
		//	change the boolean value below
		Sort2(Data, 0, Data.size(), true);
	}
	for (int i = 0; i < Data.size(); ++i) {
		out1 << Data[i] << " ";
		//if (i % 50 == 0) cout << '\n';
	}

	//multi-threaded recursive bitonic sort
	for (auto& i : Data) i = rand() % m;
	{
		//measure runtime
		//Threaded Implementation of Recursive Bitonic Sort

		Timer Tmr;
		//figure out the size of 4 segments
		int n = Data.size();
		int segSize = n / 4; int halfSize = segSize / 2;
		int start{ 0 }, end{ start + segSize };
		//default sorting direction is true, or Ascending
		bool dir{ true };
		vector<thread> T; //run 3 threads automatically thru loop
		for (int i = 1; i < 4; i++) {
			//cout << "Start index: " << start << " | " << "End index: " << end-1 << " | Dir: " << dir << endl;
			T.emplace_back(Sort2, ref(Data), start, end, dir); //3 threads, 1 for each subsegment of Data
			start = i * segSize;
			end = start + segSize;
			dir = !dir;
			//cout << i << " thread started..." << endl;
		}
		//cout << "Start index: " << start << " | " << "End index: " << end-1 << " | Dir: " << dir << endl;
		Sort2(Data, start, end, dir); //main thread
		//join threads to avoid error
		for (auto& t : T) {
			t.join();
		}
		T.clear();
		
		/* 
		* Once the above is done, input vector Data will be organized into
		*  a bitonic sequence. By default, 4 equally sized segment will each be
		*  in ascending, descending, ascending, descending order
		*/

		// now applying pre_merge to swap elements between different segments (seg 1 and 2, seg 3 and 4)
		int processedSegments = 0; // Counter to keep track of processed segments
		// reset dir
		dir = true;
		//loop through segment 1,2,3 (we just need segment 1 and 3 
		// hence subsegment 1, 2 of segment 1, and 5,6 of segment 3
		for (int i = 0; i < 6; i++) {
			start = i * halfSize;
			end = start + halfSize - 1;

			// Process only the 1st, 2nd, and 5th subsegments based on their index
			if (i == 0 || i == 1 || i == 4) {
				//cout << "Start index: " << start << " | End index: " << end << " | Dir: " << dir << endl;
				T.emplace_back(pre_merge, ref(Data), start, end, dir, segSize);
				processedSegments++;
			}
			// After every two processed segments, flip the sorting direction
			if (processedSegments == 2) {
				dir = !dir;
				processedSegments = 0; // Reset the counter
			}
		}
		//cout << "Start index: " << start << " | " << "End index: " << end << " | Dir: " << dir << endl;
		pre_merge(ref(Data), start, end, dir, segSize);
		//join threads
		for (auto& t : T) {
			t.join();
		}
		T.clear();

		/*
		* After the above, elements between each segment are swapped based on range
		*  now. Next step is to call merge on all 4 segments of the Data to create 
		*  one big bitonic sequence. Half of data will be in ascending, other half
		*  will be in descending.
		*/

		//pre_combine done, now call merge
		// reset variables
		start = 0; end = start + segSize - 1; dir = true;
		processedSegments = 0;
		for (int i = 1; i < 4; i++) {
			T.emplace_back(S2_merge, ref(Data), start, end, dir);
			//cout << "Start index: " << start << " | End index: " << end << " | Dir: " << dir << endl;
			start = i * segSize;
			end = start + segSize - 1;
			processedSegments++;
			// After every two processed segments, toggle the direction
			if (processedSegments == 2) {
				dir = !dir;
				processedSegments = 0;
			}
		}
		//cout << "Start index: " << start << " | End index: " << end << " | Dir: " << dir << endl;
		S2_merge(ref(Data), start, end, dir);
		for (auto& t : T) {
			t.join();
		}
		T.clear();

		/*
		*  After the above, 1 big bitonic sequence spanning the full length of Data was created.
		*   now swap elements between the 2 larger subsegment to prepare for further merges
		*/
		segSize = n / 2;//update segSize, since now we have 2 big segments to compare
		//set new indices
		start = 0; end = start + halfSize - 1; 
		dir = true; //default direction ascending
		for (int i = 1; i < 4; i++) {
			T.emplace_back(pre_merge, ref(Data), start, end, dir, segSize);
			//cout << "Start index: " << start << " | End index: " << end << " | Dir: " << dir << endl;
			start = i * halfSize;
			end = start + halfSize - 1;
		}
		//cout << "Start index: " << start << " | End index: " << end << " | Dir: " << dir << endl;
		pre_merge(Data, start, end, dir, segSize);
		for (auto& t : T) {
			t.join();
		}
		T.clear();

		/*	
		*  Two big segments have their elements swapped. Now time to do another pre_merge
		*	to move smaller elements and the bigger elements into position for a final merge
		*/

		// now applying pre_merge to swap elements between different segments (seg 1 and 2, seg 3 and 4)
		dir = true; // reset dir
		//loop through segment 1,2,3 (we just need segment 1 and 3)
		//now we are back to exchanging data between 4 smaller segments
		segSize = n / 4;
		halfSize = segSize / 2;
		// hence subsegment 1, 2 of segment 1, and 5,6 of segment 3
		for (int i = 0; i < 6; i++) {
			start = i * halfSize;
			end = start + halfSize - 1;

			// Process only the 1st, 2nd, and 5th segments based on their index
			if (i == 0 || i == 1 || i == 4) {
				//cout << "Start index: " << start << " | End index: " << end << " | Dir: " << dir << endl;
				T.emplace_back(pre_merge, ref(Data), start, end, dir, segSize);
			}
		}
		//cout << "Start index: " << start << " | " << "End index: " << end << " | Dir: " << dir << endl;
		pre_merge(ref(Data), start, end, dir, segSize);
		for (auto& t : T) {
			t.join();
		}
		//clear T
		T.clear();

		/*
		* After the above, all elements are moved into the correct subsegments and are
		*   ready for a merge to consolidate the whole vector into a sorted array.
		*/

		start = 0; end = start + segSize - 1; dir = true;
		for (int i = 1; i < 4; i++) {
			T.emplace_back(S2_merge, ref(Data), start, end, dir);
			//cout << "Start index: " << start << " | End index: " << end << " | Dir: " << dir << endl;
			start = i * segSize;
			end = start + segSize - 1;

		}
		//cout << "Start index: " << start << " | End index: " << end << " | Dir: " << dir << endl;
		S2_merge(ref(Data), start, end, dir);
		for (auto& t : T) {
			t.join();
		}
		T.clear();

		/*
		*  Whole vector is now sorted, inputs are redirected
		*/

	}
	//Save the result to "Output1.txt".
	for (int i = 0; i < Data.size(); ++i) {
		out2 << Data[i] << " ";
		//if (i % 50 == 0) cout << '\n';
	}
	out2.close();




	// I was unable to figure out how to implement threaded iterative bitonic sort
	//for (auto& i : Data) i = rand() % m;
	//{
	//	//measure runtime
	//	//Threaded Implementation of iterative Bitonic Sort
	//}
	////Save the result to "Output2.txt".
	//for (int i = 0; i < Data.size(); ++i) {
	//	out2 << Data[i] << " ";
	//	if (i % 50 == 0) cout << '\n';
	//}
	//out2.close();

	return 0;
}
/*-------------------------------------------------------------*/

//Iterative, true is ascending, false is descending
void Sort1(vector<int>& Data, bool Up) {
	int n = Data.size();

	// Outer loop: Doubles the size of segments to be sorted with each iteration.
	// Starts with segments of size 2, then 4, 8, and so on, until the entire vector is covered.
	for (int k = 2; k <= n; k *= 2) {

		// Middle loop: Determines the distance for comparing and swapping elements within the segment.
		// Starts with half the size of the current segment and halves with each iteration,
		// facilitating the bitonic merge process.
		for (int j = k / 2; j > 0; j /= 2) {

			// Inner loop: Iterates over all elements in the array to perform the compare-and-swap operations.
			for (int i = 0; i < n; i++) {

				// Calculate the index of the element to compare with the current element.
				int ij = i ^ j;

				// Ensure we only compare elements within the intended range (ij must be greater than i).
				if (ij > i) {

					// Determine the direction of sorting for the current segment:
					// - If the current segment is part of a larger ascending sequence (i & k == 0),
					//   perform an ascending compare-and-swap.
					// - If the current segment is part of a larger descending sequence (i & k != 0),
					//   perform a descending compare-and-swap.
					bool isAscendingSegment = ((i & k) == 0);
					if ((isAscendingSegment == Up && Data[i] > Data[ij]) ||
						(isAscendingSegment != Up && Data[i] < Data[ij])) {
						swap(Data[i], Data[ij]);
					}
				}
			}
		}
	}

}

/*-------------------------------------------------------------*/

//recursive, true is ascending, false is descending
void Sort2(vector<int>& Data, int n1, int n2, bool Up) {

	//begin recursion, assuming n2's input is always Data.size()
	// as such, the initial recursion call's n2 should always be Data.size() - 1, therefore n2-1;
	S2_recurse(Data, n1, n2 - 1, Up);
}

void S2_recurse(vector<int>& Data, int n1, int n2, bool Up) {

	//Continue recursing until segment size is 2
	if (n2 - n1 != 1) {
		//calculate middle point
		int mid = n1 + (n2 - n1) / 2;
		// recursion!
		S2_recurse(Data, n1, mid, Up);
		S2_recurse(Data, mid + 1, n2, !Up);
		// merge whole segments
		S2_merge(Data, n1, n2, Up);
	}
	// if segment size is 2, start creating bitonic sequences
	else {
		S2_merge(Data, n1, n2, Up);
	}
}

void S2_merge(vector<int>& Data, int n1, int n2, bool Up) {
	// Calculate the size of the current segment to be merged
	int size = n2 - n1 + 1;

	// Only proceed if the segment size is greater than 1, as single elements are already 'sorted'
	if (size > 1) {
		// Find the midpoint of the segment, effectively dividing it into two halves
		int mid = size / 2;

		// Iterate over the first half of the segment
		for (int i = 0; i < mid; i++) {
			// If sorting in ascending order and the current element is greater than its counterpart in the second half
			// Or if sorting in descending order and the current element is less than its counterpart in the second half
			// Then, swap the elements to maintain the bitonic property
			if ((Up && Data[n1 + i] > Data[n1 + i + mid]) ||
				(!Up && Data[n1 + i] < Data[n1 + i + mid])) {
				swap(Data[n1 + i], Data[n1 + i + mid]);
			}
		}

		// Recursively apply the merge function to the first half of the segment
		// This continues the merge process, ensuring the first half becomes fully sorted in the desired order
		S2_merge(Data, n1, n1 + mid - 1, Up);

		// Recursively apply the merge function to the second half of the segment
		// This ensures the second half becomes fully sorted in the desired order as well
		S2_merge(Data, n1 + mid, n2, Up);
	}
}

/*-------------------------------------------------------------*/

void pre_merge(vector<int>& Data, int n1, int n2, bool Up, int range) {
	//lock_guard<mutex> temp(Data);
	// Iterate from n1 to n2 for comparisons within the specified range
	for (int i = n1; i <= n2; i++) {
		int compareIndex = i + range;  // Calculate the index to compare with, 'range' units away

		// Make sure the compareIndex is within the bounds of the Data vector
		if (compareIndex < Data.size()) {
			// Perform the comparison and swap if necessary according to the 'Up' parameter
			if ((Up && Data[i] > Data[compareIndex]) || (!Up && Data[i] < Data[compareIndex])) {
				swap(Data[i], Data[compareIndex]);
			}
		}
	}
}