// reStart from main
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define NPROD 1
#define TAM 10
#define NCONS 1

int packages = 0;
pthread_mutex_t mutex_buffer = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t is_full = PTHREAD_COND_INITIALIZER;
pthread_cond_t is_waiting = PTHREAD_COND_INITIALIZER;

void * manufacturer(void *arg){
	int id = *((int *)arg);
	while(1){
		pthread_mutex_lock(&mutex_buffer);
		while(packages == TAM){
			pthread_cond_wait(&is_full, &mutex_buffer);
		}
		pthread_mutex_lock(&mutex_buffer);
		packages += 1;
		printf("Manufacturer %d is developing a new package... Total:%d \n", id, packages);
		sleep(2);
		pthread_mutex_unlock(&mutex_buffer);
		pthread_cond_broadcast(&is_waiting);
	}
}

void * consumer(void *arg){	
	int id = *((int *)arg);
	while(1){
		pthread_mutex_lock(&mutex_buffer);
		while(packages == 0){
			pthread_cond_wait(&is_waiting, &mutex_buffer);
		}
		pthread_mutex_lock(&mutex_buffer);
		packages += -1;
		printf("Consumer %d is picking up a package... Total:%d \n", id, packages);
		sleep(10);
		if(packages == 0){
			pthread_cond_broadcast(&is_full);
		}
		pthread_mutex_unlock(&mutex_buffer);
	}
}

int main(int argc, char** argv){
	pthread_t store_prod[NPROD];
	pthread_t store_cons[NCONS];
}
