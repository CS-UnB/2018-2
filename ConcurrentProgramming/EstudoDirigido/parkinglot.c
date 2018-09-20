// RESTART FROM MAIN - CREATE THREADS
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>

#define N_PARKING_SPOTS 20
#define N_MINUTES 1
#define N_PROF 10
#define N_STAFF 15
#define N_STUD 30

// shared memory
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t p_line = PTHREAD_COND_INITIALIZER;
pthread_cond_t s_line = PTHREAD_COND_INITIALIZER;
pthread_cond_t stud_line = PTHREAD_COND_INITIALIZER;
int cars_parked = 0;
int prof_waiting = 0;
int staff_waiting = 0;

// functions
void parking(int arg){}
void leaving(int arg){}

// threads
void * professor(void *arg){
	int id = *((int *)arg);
	while(1){
		pthread_mutex_lock(&mutex);
		prof_wating++;
		while(cars_parked >= N_PARKING_SPOTS){
			pthread_cond_wait(&p_line, &mutex);
		}
		parking(id);
		cars_parked++;
		prof_waiting--;
		pthread_mutex_unlock(&mutex);
		
		sleep(N_MINUTES);
		
		pthread_mutex_lock(&mutex);
		cars_parked--;
		pthread_cond_signal(&p_line);
		pthread_cond_signal(&s_line);
		pthread_cond_signal(&stud_line);
		pthread_mutex_unlock(&mutex)
	}
}

void * staff(void *arg){
	int id = *((int *)arg);
	while(1){
		pthread_mutex_lock(&mutex);
		staff_waiting++;
		while(cars_parked >= N_PARKING_SPOTS && prof_wating == 0){
			pthread_cond_wait(&p_line, &mutex);
		}
		parking(id);
		cars_parked++;
		staff_waiting--;
		pthread_mutex_unlock(&mutex);
		
		sleep(N_MINUTES);
		
		pthread_mutex_lock(&mutex);
		cars_parked--;
		pthread_cond_signal(&p_line);
		pthread_cond_signal(&s_line);
		pthread_cond_signal(&stud_line);
		pthread_mutex_unlock(&mutex)
	}
}

void * student(void *arg){
	int id = *((int *)arg);
	while(1){
		pthread_mutex_lock(&mutex);
		while((cars_parked >= N_PARKING_SPOTS) && (prof_waiting == 0) && (staff_waiting == 0)){
			pthread_cond_wait(&p_line, &mutex);
		}
		parking(id);
		cars_parked++;
		pthread_mutex_unlock(&mutex);
		
		sleep(N_MINUTES);
		
		pthread_mutex_lock(&mutex);
		cars_parked--;
		pthread_cond_signal(&p_line);
		pthread_cond_signal(&s_line);
		pthread_cond_signal(&stud_line);
		pthread_mutex_unlock(&mutex)
	}
}

int main(int argc, char** argv){
	pthread_t cars[N_PROF+N_STAFF+N_STUD];
	int *id;

	for(int i=0; i<(N_PROF+N_STUD+N_STAFF); i++){
		id = (int *) malloc(sizeof(int));
		if(i%3 == 0)

	}
	return 0;
}
