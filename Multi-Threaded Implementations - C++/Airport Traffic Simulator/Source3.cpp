#pragma warning(disable: 4996) //ctime  only for visual studio
#include <iostream>
#include <vector>
#include <list>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <chrono>
#include <random>
#include <queue>
#include <fstream>
#include <sstream>

using namespace std;
ofstream txt("log.txt");
ostringstream buffer;
mutex buffer_lock;

//template<typename T> class blockingQ {
//    mutex q_lock;
//    queue<T> queue;
//    condition_variable cv_full, cv_nfull;
//public:
//    void push(T item) {
//        unique_lock<mutex> ug(q_lock);
//        cv_nfull.wait(ug,  )
//        queue.push(item);
//        cv_full.notify_one();
//    }
//
//    T pop() {
//        unique_lock<mutex> ug(q_lock);
//        
//        T item{ queue.front() };
//        queue.pop();
//        cv_nfull.notify_one();
//        return item;
//    }
//
//};

class Runway {
   int id;
   bool available;
   int usages;
   mutex r_lock;
   condition_variable r_cond;
   int prev_gate_index;
   int prev_runway_index;

public:
   Runway() {};
   Runway(int in_id) {
       id = in_id;
       available = true;
       usages = 0;
       prev_gate_index = 0;
       prev_runway_index = 0;
   }
   // Copy constructor
   Runway(const Runway& other) : id(other.id), available(other.available),
       usages(other.usages), prev_gate_index(other.prev_gate_index),
       prev_runway_index(other.prev_runway_index) {}

   // Move constructor
   Runway(Runway&& other) noexcept : id(other.id), available(other.available), usages(other.usages) {
       other.id = 0;
       other.available = true;
       other.usages = 0;
       other.prev_gate_index = 0;
       other.prev_runway_index = 0;
   }

   // Copy assignment
   Runway& operator=(const Runway& other) {
       id = other.id;
       available = other.available;
       usages = other.usages;
       prev_gate_index = other.prev_gate_index;
       prev_runway_index = other.prev_runway_index;
       return *this;
   }

   // Move assignment
   Runway& operator=(Runway&& other) noexcept {
       if (this != &other) {
           id = other.id;
           available = other.available;
           usages = other.usages;
           other.id = 0;
           other.available = true;
           other.usages = 0;
           prev_gate_index = other.prev_gate_index;
           prev_runway_index = other.prev_runway_index;
       }
       return *this;
   }

   bool checkRunway() { unique_lock<mutex> lock(r_lock); return available; };   // checks if runway is available
   void getRunway();     // locks runway for plane use
   void releaseRunway(); // release runway for plane use
   void runwayReport();  // prints information about runway use

};

class Gate {
   int id;
   bool available = true;
   int usages{ 0 };
   mutex g_lock;
   condition_variable g_cond;

public:
   Gate() {};
   Gate(int in_id) {
       id = in_id;
       available = true;
       usages = 0;
   }
   // Copy constructor
   Gate(const Gate& other) : id(other.id), available(other.available), usages(other.usages) {}

   // Move constructor
   Gate(Gate&& other) noexcept : id(other.id), available(other.available), usages(other.usages) {
       other.id = 0;
       other.available = true;
       other.usages = 0;
   }

   // Copy assignment
   Gate& operator=(const Gate& other) {
       id = other.id;
       available = other.available;
       usages = other.usages;
       return *this;
   }

   // Move assignment
   Gate& operator=(Gate&& other) noexcept {
       if (this != &other) {
           id = other.id;
           available = other.available;
           usages = other.usages;
           other.id = 0;
           other.available = true;
           other.usages = 0;
       }
       return *this;
   }

   bool checkGate() { unique_lock<mutex> lock(g_lock);  return available; };   // checks if gate is available
   int  getGateID() { return this->id; }
   void getGate();     // locks gate for plane
   void releaseGate(); // release gate for plane
   void gateReport();  // prints information about gate use
};

class Airport {
   vector<Runway> runways; //wrapper for easily checking for available runways
   vector<Gate> gates;     //wrapper for easily checking for available runways
   //std::mutex airport_rw; // mutex for managing runways
   //std::mutex airport_gate; //mutex for managing gates
   queue<Runway> all_runways;
   queue<Gate> all_gates;
   mutex airport_rw;
   mutex airport_gates;
   condition_variable rw_conds;
   condition_variable gate_conds;

public:
   //constructor for airport, initialize input amount of runways and gates
   //Airport(int numRunways, int numGates) {
   //    try {
   //        for (int i = 0; i < numRunways; i++) {
   //            runways.emplace_back(Runway(i));
   //        }
   //        for (int i = 0; i < numGates; i++) {
   //            gates.emplace_back(Gate(i));
   //        }
   //    }
   //    catch (const std::exception& e) {
   //        // Handle the exception
   //        std::cerr << "Error during construction of Airport: " << e.what() << std::endl;
   //        // You can choose to re-throw the exception here if necessary
   //    }
   //}
   Airport(int numRunways, int numGates) {
       try {
           for (int i = 0; i < numRunways; i++) {
               all_runways.push(Runway(i));
           }
           for (int i = 0; i < numGates; i++) {
               all_gates.push(Gate(i));
           }
       }
       catch (const std::exception& e) {
           std::cerr << "Error during construction of Airport: " << e.what() << std::endl;
       }
   }


   pair<bool, int> handleLandingRequest();
   bool handleTakeoffRequest(int gateID);
   void airportGateRelease(int gateID);
   void printRunwayReports();
   void requestScheduler();
};

void plane(int id, Airport& ap);

auto sim_start_time{ std::chrono::system_clock::now() };
auto cur_time{ chrono::system_clock::to_time_t(sim_start_time) };
int main() {

   cout << "Simulation start time: " << ctime(&cur_time) << endl;

   Airport airport(3, 6); //3 runways and 6 gates


   vector<thread> planes; //all planes
   int plane_num = 100;
   for (int i = 0; i < plane_num; ++i) {
       planes.emplace_back(plane, i, ref(airport));
   }
   for (auto& ind_plane : planes) {
       ind_plane.join();
   }
   airport.printRunwayReports();
   txt.close();
   return 0;
}

void plane(int id, Airport& ap) {
   /*
   *  2 while loops, each plane should perform a landing and take-off operation
   *  Upon successful landing, plane thread goes to sleep to simulate refuel and more
   */

   bool landed{ false }, depart{ false };
   pair<bool, int> result;
   ostringstream plane_log;

   while (!landed) {
       result = ap.handleLandingRequest();
       landed = result.first;
       if (!landed) {
           //{
           //    unique_lock<mutex> print_lock(buffer_lock);
           //    buffer << "Plane " << id << " can't land, circling...\n";
           //    //txt << buffer.str();
           //    //cout << buffer.str();
           //}
           //plane can't land, circling
           plane_log << "Plane " << id << " can't land, circling...\n";
           this_thread::sleep_for(chrono::seconds(1));
       }
       else if (landed) {
           //simulate refueling by making plane thread go to sleep
           // mutex to protect the printing
           //{
           //    unique_lock<mutex> print_lock(buffer_lock);
           //    buffer << "Plane " << id << " Is refueling at gate " << result.second << ".\n";
           //    //txt << buffer.str();
           //    //cout << buffer.str();
           //}
           //plane id reports operation along the way
           // we can add randomizer here to make simulation more interesting....
           // for now, let's just keep it this way.
           plane_log << "Plane " << id << " Is refueling at gate " << result.second << ".\n";
           this_thread::sleep_for(chrono::seconds(1));
           break;
       }
   }

   {
       unique_lock<mutex> print_lock(buffer_lock);
       buffer << "Plane " << id << " at gate " << result.second << " is ready to takeoff" << ".\n";
       //txt << buffer.str();
       //cout << buffer.str();
   }

   //now plane is ready to takeoff
   while (!depart) {
       depart = ap.handleTakeoffRequest(result.second);
       if (!depart) {
           //{
           //    unique_lock<mutex> print_lock(buffer_lock);
           //    buffer << "Plane " << id << " Can't takeoff, waiting for runway...\n";
           //    //txt << buffer.str();
           //    //cout << buffer.str();
           //}
           //plane can't depart, sleep
           plane_log << "Plane " << id << " Can't takeoff, waiting for runway...\n";
           this_thread::sleep_for(chrono::seconds(1));
       }
       else if (depart) {
           {
               unique_lock<mutex> print_lock(buffer_lock);
               buffer << "Plane " << id << " taking off...\n";
               //txt << buffer.str();
               //cout << buffer.str();
           }
           plane_log << "Plane " << id << " taking off...\n";
           this_thread::sleep_for(chrono::milliseconds(200));
       }
   }

   //plane id completes one roundtrip
   {
       unique_lock<mutex> print_lock(buffer_lock);
       plane_log << "Plane " << id << " have visited the airport." << endl;
       txt << plane_log.str();
       cout << plane_log.str();
   }
}

/*-----------------------------------------------------*/

/* Airport member functions start */
void Airport::requestScheduler() {

}

pair<bool, int> Airport::handleLandingRequest() {
   //attempt to locate available gate
   bool gotGate{ false }, gotRunway{ false };
   //request to land repeatedly until we do
   while (!gotGate) {
       unique_lock<mutex> g_lock(airport_gates);
       Gate curr_gate = move(all_gates.front());
       all_gates.pop();
       all_gates.push(curr_gate);
       //if gate is available, check runway next
       if(curr_gate.checkGate()){
           curr_gate.getGate();//gets gate, now check for runway
           unique_lock<mutex> r_lock(airport_rw);
           Runway curr_rw = move(all_runways.front());
           all_runways.pop();
           all_runways.push(curr_rw);
           //if runway is available, then we can land
           if (curr_rw.checkRunway()) {
               curr_rw.getRunway();
               this_thread::sleep_for(chrono::milliseconds(200));
               curr_rw.releaseRunway();
               
               return { true, curr_gate.getGateID() };
           }
       }
       //if gate is not available, get another gate.
       else if (!curr_gate.checkGate()) {
           
       }
   }
   
   
   //for (auto& gate : gates) {
   //    if (gate.checkGate()) {
   //        //if a gate reports it is available, ownership of said gate should be taken
   //        // and check next for runway availability
   //        gate.getGate();
   //        for (auto& rw : runways) {
   //            if (rw.checkRunway()) {
   //                rw.getRunway(); //lock runway
   //                //plane thread sleeps for a bit, simulating landing
   //                this_thread::sleep_for(chrono::milliseconds(200));
   //                //release runway for other plane threads' use
   //                rw.releaseRunway();
   //                return { true, gate.getGateID() };
   //            }
   //        }
   //        //if we are here, plane's failed to obtain a runway, release gate and return
   //        // ^ simpler implementation for now
   //        gate.releaseGate();
   //        return { false, -1 };
   //        //ideally, plane will keep the gate assignment and just wait for a runway
   //    }
   //}

   //this return value is not gonna get hit, just there so that compiler dont complain
   return { false, -1 };
}

bool Airport::handleTakeoffRequest(int gateID) {
   for (auto& rw : runways) {
       if (rw.checkRunway()) {
           //runway available, get runway
           rw.getRunway();//lock runway
           //plane thread sleeps for a bit, simulating taking off
           this_thread::sleep_for(chrono::milliseconds(200));
           rw.releaseRunway();
           airportGateRelease(gateID);
           return true;
       }
   }
   //if we are here, plane's failed to obtain a runway, return to submit another request
   return false;
}

void Airport::printRunwayReports() {
   //call report functions in the runway class
   buffer << "***Runway statistics***\n\n";

   for (auto& rw : runways) {
       rw.runwayReport();
   }
   buffer << "\n" << endl;
   txt << buffer.str();
   cout << buffer.str();
}

void Airport::airportGateRelease(int gateID) {
   // Find the gate by ID and release it
   for (auto& gate : gates) {
       if (gate.getGateID() == gateID) {
           gate.releaseGate();
           break;
       }
   }
}

/* Airport member functions end */

/*-----------------------------------------------------*/

/* Runway member functions start*/

void Runway::getRunway() {
   unique_lock<mutex> lock(r_lock);
   r_cond.wait(lock, [this] { return available; });
   available = false;
   usages++;
}

void Runway::releaseRunway() {
   unique_lock<mutex> lock(r_lock);
   available = true;
   r_cond.notify_one();
}

//should NOT be invoked until all operations are done
void Runway::runwayReport() {
   //unique_lock<mutex> lock(buffer_lock);
   buffer << "Runway " << id << " was used " << usages << " times.\n";
   //txt << buffer.str();
   //cout << buffer.str();
}

/* Runway member functions end */

/*-----------------------------------------------------*/

/* Gate member functions start */

void Gate::getGate() {
   unique_lock<mutex> lock(g_lock);
   g_cond.wait(lock, [this] { return available; }); // Wait until the gate is available
   available = false; // Mark the gate as in use
   usages++;
}

void Gate::releaseGate() {
   unique_lock<mutex> lock(g_lock);
   available = true; // Mark the gate as in use
   g_cond.notify_one();
}

//should NOT be invoked until all operations are done
void Gate::gateReport() {
   buffer << "Gate " << id << " was used " << usages << " times.\n";
   //txt << buffer.str();
   //cout << buffer.str();
}

/* Gate member functions end */