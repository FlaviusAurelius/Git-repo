#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <cmath>
#include <list>


bool isSpace(char c) {
	return c == ' ';
}
int main() {
	//merge string alternately leetcode question
	
	/*std::string w1{"abcd"};
	std::string w2{"efgh"};

	bool done{ false };
	auto c1{ w1.begin() };
	auto c2{ w2.begin() };

	std::string result{};

	while (!done) {
		if (c1 != w1.end()) {
			result += *c1;
			c1++;
		}
		if (c2 != w2.end()) {
			result += *c2;
			c2++;
		}

		if (c1 == w1.end() && c2 == w2.end()) {
			done = true;
		}
	}

	std::cout << result << std::endl;*/

	// kids with greatest num. candies question from leet code
	
	/*std::cout << "\n" << "---------------------" << std::endl;
	
	std::vector<int> candies{2,3,5,1,3};

	auto max{ max_element(candies.begin(), candies.end()) };
	std::vector<bool> result1(size(candies));

	std::cout << *max << std::endl;


	for (auto kid : candies) {
		if ((kid + 3) >= *max ) {
			result1.push_back(true);
		} else {
		    result1.push_back(false);
		}
	}

	for (auto i : result1) {
		std::cout << i << " ";
	}

	std::cout << std::endl;*/

	// Move Zeroes
	//std::vector<int> nums{0, 1, 0, 3, 12};

	//if (nums.size() == 0 || nums.size() == 1) {
	//	return 0;
	//}
	///*auto p1{ nums.begin() };
	//auto p2{ nums.begin()};
	//bool complete{ false };
	//while (!complete) {

	//}*/
	//int lastNonZeroFoundAt = 0;
	//// If the current element is not 0, then we need to
	//// append it just in front of last non 0 element we found.
	//for (int i = 0; i < nums.size(); i++) {
	//	if (nums[i] != 0) {
	//		nums[lastNonZeroFoundAt++] = nums[i];
	//	}
	//}
	//// After we have finished processing new elements,
	//// all the non-zero elements are already at beginning of array.
	//// We just need to fill remaining elements in the array with 0's.
	//for (int i = lastNonZeroFoundAt; i < nums.size(); i++) {
	//	nums[i] = 0;
	//}

	//-----------------------------------------
	// reverse words in a string

	std::string str1 {"the sky is blue"};
	std::string str2 {"  hello world  "};
	std::vector<std::string> output;

	bool complete{ false };
	//metChar and charFinish are flags to determine when does a word end
	bool metChar{ false };
	//std::bool charFinish{false};
	std::string temp;


	reverse(str1.begin(), str1.end());
	int n = str1.size();
	int left = 0;
	int right = 0;
	int i = 0;
	while (i < n) {
		while (i < n && str1[i] == ' ')
			i++;
		if (i == n)
			break;
		while (i < n && str1[i] != ' ') {
			str1[right++] = str1[i++];
		}
		reverse(str1.begin() + left, str1.begin() + right);
		str1[right++] = ' ';
		left = right;
		i++;
	}
	str1.resize(right - 1);

	//int i{ 0 };
	while (i < str1.size()) {
		// if metChar is on and we hit a space, time to put str into list
		if ( isSpace(str1[i]) && metChar ) {
			output.push_back(temp);
			//reset metChar flag and clear temp.
			metChar = false;
			temp.clear();
			// and move along
			i++;
		}
		//if we are dealing with spaces, just move along
		else if (isSpace(str1[i])) {
			i++; // move on
		}
		//we are now dealing with characters, set metChar to T and add to temp
		else if (!isSpace(str1[i])) {
			temp += str1[i];
			metChar = true;
			i++;
		}
	}
	//this case is to add the temporary string into output
	if (!temp.empty()) {
		output.push_back(temp);
	}
	// stop here
	auto pt1{ 0 };
	auto pt2{ output.size()-1 };
	while (pt1 < pt2) {
		std::swap( output[pt1], output[pt2]);
		pt1++;
		pt2--;
	}
	str2.clear();
	for (auto e : output) {
		str2 += e;
		str2 += " ";
	}


	return 0;
}

