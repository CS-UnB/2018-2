#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

struct ride {
    char *name;
    int minimum_age;
    int best_suited_up_to;
    int riding_time;
}ride_t;

void * toddler(void *arg) {}
void * child(void *arg) {}
void * teen(void *arg) {}
void * youngAdult(void *arg) {}
void * middleAgedAdult(void *arg) {}
void * elder(void *arg) {}