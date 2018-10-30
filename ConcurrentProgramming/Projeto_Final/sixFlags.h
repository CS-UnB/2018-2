#ifndef _SIX_FLAGS_
#define _SIX_FLAGS_
#include <pthread.h>
#include <semaphore.h>
#include <c++/vector>
#include "aux_func.h"

class Ride {
    final int id;
    const std::string name;
    const int bestSuiteForAgeUpTo;
    const int minimumAgeToRide;
    const int ridingTime;
public:
    Ride(int, std::string);
    void start_ride
}

void * toddler(void*);
void * child(void*);
void * teen(void*);
void * youngAdult(void*);
void * middleAgedAdult(void*);
void * elder(void*);
// void * ride(void*, const char*, const int, const int, const int);

#endif