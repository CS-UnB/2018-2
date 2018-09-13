//CONTINUE FROM MAIN

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define SERVING 10
#define CANNIBALS 20
#define CHEFS 1

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond_cannibals = PTHREAD_COND_INITIALIZER;
pthread_cond_t cond_chef = PTHREAD_COND_INITIALIZER;

int food = 0;

void* chef(void* arg){
	int id = *((int *)arg);
	while(1){
		pthread_mutex_lock(&mutex);
		while(food != 0){
			printf("CHEF %d: WAITING. These bastards still have food.", id);
			pthread_cond_wait(&cond_chef, &mutex);
		}
		// cooking
		sleep(5);
		printf("CHEF %d: COOKING. I'd better cook or else I'll be the dinner!", id);
		food += SERVING;
		// serving
		pthread_cond_broadcast(&cond_cannibals);
		printf("CHEF %d: SERVING. Wake up, bastards. Time for food!", id);
		pthread_mutex_unlock(&mutex);
	}
}

void* cannibal(void* arg){
	int id = *((int *)arg);
	while(1){
		pthread_mutex_lock(&mutex);
		while(food == 0){
			printf("Cannibal %d: NO FOOD. Let's wait..", id);
			pthread_cond_wait(&cond_cannibals, &mutex);
		}
		// getting the food
		printf("Cannibal %d: GETTING food", id);
		food--;
		if(food == 0){
			printf("Cannibal %d: WAKE THE CHEF. We need more food!", id);
			pthread_cond_signal(&cond_chef);
		}
		pthread_mutex_unlock(&mutex);
		// eating
		printf("Cannibal %d: EATING... good food, the chef is safe for now.", id);
		sleep(10);
	}
}

int main(int argc, char** argv){
	
	int *id;
	int i = 0;

	pthread_create(NULL, NULL, &chef, (void*) id);
	for(i = 0; i < CANNIBALS; ++i){
		
	}
        id = (int *) malloc(sizeof(int));
        *id = i;
	return 0;
}
