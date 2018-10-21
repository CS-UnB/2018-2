#ifndef _SIX_FLAGS_
#define _SIX_FLAGS_
#include <pthread.h>
#include <semaphore.h>
#include "aux_func.h"

void * toddler(void*);
void * child(void*);
void * teen(void*);
void * youngAdult(void*);
void * middleAgedAdult(void*);
void * elder(void*);
// void * ride(void*, const char*, const int, const int, const int);

#endif