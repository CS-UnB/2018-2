#include "sixFlags.h"
#define N_RIDES 5
#define N_PEOPLE 355

// Shared memory ---------------
ride_t ride_array[N_RIDES];
// -----------------------------

int main(int argc, char** argv) {
    // code
    return 0;
}

// void * ride(void *arg, const char *name, const int minimum_age, const int best_suited_up_to, const int riding_time) {
//     // code
// }

void * toddler(void *arg) {}
void * child(void *arg) {}
void * teen(void *arg) {}
void * youngAdult(void *arg) {}
void * middleAgedAdult(void *arg) {}
void * elder(void *arg) {}