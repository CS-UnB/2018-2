// reStart from main
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define NPROD 1
#define TAM 10
#define NCONS 10

int buffer[TAM];
int pos = 0;
pthread_mutex_t mutex_buffer = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t is_full = PTHREAD_COND_INITIALIZER;
pthread_cond_t is_waiting =PTHREAD_COND_INITIALIZER;


void * manufacturer(void *arg){
	int id = *((int *)arg);
	while(1){
		pthread_mutex_lock(&mutex_buffer);
        int item = (pos * pos)%TAM;
		while(pos+1 == TAM){
			pthread_cond_wait(&is_full, &mutex_buffer);
		}
		buffer[pos] =  item;
		printf("Manufacturer %d is developing a new package on lane %d... New value:%d \n", id, pos, item);
		//sleep(1);
        pos = (pos+1) % TAM;
        if(pos == 1){
            pthread_cond_broadcast(&is_waiting);
        }
		pthread_mutex_unlock(&mutex_buffer);
	}
    pthread_exit(0);
}

void * consumer(void *arg){	
	int id = *((int *)arg);
	while(1){
		pthread_mutex_lock(&mutex_buffer);
		while(pos == 0){
            printf("Consumer %d is waiting\n", id);
			pthread_cond_wait(&is_waiting, &mutex_buffer);
		}
		int out = buffer[pos];
		printf("Consumer %d is picking up a package %d on position %d... \n", id, out, pos);
        pos = (pos -  1)%TAM;
		//sleep(2);
		if(pos == 0){
			pthread_cond_broadcast(&is_full);
		}
		pthread_mutex_unlock(&mutex_buffer);
        //sleep(30);
	}
}

int main(int argc, char** argv){
	pthread_t store_prod[NPROD];
	pthread_t store_cons[NCONS];
    int *id;
    int i = 0;

    id = (int *) malloc(sizeof(int));
    *id = 0;
    for(i=0; i < NCONS; i++){
        *id = i;
        pthread_create(&store_cons[i], NULL, consumer, (void*) id);
    }
    for(i=0; i < NPROD; i++){
        *id = i;
        pthread_create(&store_prod[i], NULL, manufacturer, (void*) id);
    }
    pthread_join(store_cons[0], NULL);
    return 0;
}
