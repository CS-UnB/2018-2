#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>

#define MAX_CHILDREN_IN_A_RIDE 15
#define MIN_CHILDREN_IN_A_RIDE 5
#define N_RIDES 5
#define N_CHILDREN 100
#define RIDE_TIME 5
#define true 1
#define false 0
typedef int bool;

sem_t rideSemaphore[N_RIDES];				
sem_t childEnjoysRide[N_RIDES];
pthread_mutex_t MUTEX[N_RIDES];
pthread_mutex_t MUTEX_CHILDREN[N_RIDES];
int childrenInRide[N_RIDES];
int actualNumberOfChildrenInRide[N_RIDES];
bool riding[N_RIDES] = {[0 ... (N_RIDES-1)] = false};
time_t t;

void * switcher_THREAD(void *id){
	const int rideId = *(int*) id;
	const int rideTime = ((int)drand48()*100) % N_RIDES;
	const int maxAge = 20;
	const int minAge = 4;
	const int rideBestSuitedForAgesUpTo = minAge + ((int)(drand48()*100) % (maxAge - minAge));

	while(1){
		sem_wait(&rideSemaphore[rideId]);
		pthread_mutex_lock(&MUTEX[rideId]);
		riding[rideId] = true;
		if(childrenInRide[rideId] < MAX_CHILDREN_IN_A_RIDE){
			riding[rideId] = false;
			printf("\n\n\n############# RIDE ID %d ####################################\n# "
			"\n#\t %d CHILDREN waiting to ride\n#\tLet's wait a bit for more children..."
			"\n#####################################################################\n\n\n ", rideId, childrenInRide[rideId]);
			sleep(3);
		}
		riding[rideId] = true; 
		printf("\n\n\n################ RIDE ID %d #####################################\n# "
			"\n#\t %d CHILDREN waiting to ride\n#\tLet's get the ride started!...\n#\n#\n#\t\t\t$$$$$$ RIDING! $$$$$$\n#\n#\n#"
			"\n#####################################################################\n\n\n ", rideId, childrenInRide[rideId]);
		sleep(RIDE_TIME);

		for(int i = 0; i < actualNumberOfChildrenInRide[rideId]; i++){
			sem_post(&childEnjoysRide[rideId]);
		}
		actualNumberOfChildrenInRide[rideId] = 0;
		pthread_mutex_unlock(&MUTEX[rideId]);
	}
}

void * child_THREAD(void *id){
	const int childId = *(int*) id;
	const int minAge = 4;
	const int maxAge = 20;
	const int timeToBoard = ((int)(drand48()*100)) % N_RIDES;
	const int age = (minAge + ((int)(drand48()*100))) % maxAge;
	int rideOfChoice = (childId + ((int)(drand48()*100))) % N_RIDES;
	while(1){
		pthread_mutex_lock(&MUTEX_CHILDREN[rideOfChoice]);
		if((childrenInRide[rideOfChoice] < MAX_CHILDREN_IN_A_RIDE) && (riding[rideOfChoice] == false)) {
			
			sleep(timeToBoard);
			childrenInRide[rideOfChoice]++;
			actualNumberOfChildrenInRide[rideOfChoice]++;
			printf("\n\t\t> CHILD %d:\n\t\tThere are %d seats available in ride %d... I'll take one", (int) childId, (MAX_CHILDREN_IN_A_RIDE - childrenInRide[rideOfChoice]), rideOfChoice);
			if(childrenInRide[rideOfChoice] == MIN_CHILDREN_IN_A_RIDE){
				printf("\n\n\n######################################################################\n# "
					"\t\t\t\tThere are %d children in the ride, enough to start it!.\n#\t\t\t\tTell the SWITCHER to get it going!!."
					"\n#############################################################################\n\n\n", rideOfChoice);
				sem_post(&rideSemaphore[rideOfChoice]);
			}
			else if(childrenInRide[rideOfChoice] == MAX_CHILDREN_IN_A_RIDE){
				printf("\n\n\n#######################################################################\n# "
					"\t\t\t\tRIDE %d is full. Cannot fit anybody else!"
					"\n##############################################################################\n\n\n", rideOfChoice);
			}
			pthread_mutex_unlock(&MUTEX_CHILDREN[rideOfChoice]);
			sem_wait(&childEnjoysRide[rideOfChoice]);
			//child has fun!;
			/* the ride is over
				the children start to leave the ride*/
			pthread_mutex_lock(&MUTEX_CHILDREN[rideOfChoice]);
			printf("\n\t\t< CHILD %d:\n\t\t\tLeaving RIDE %d...", (int) childId, rideOfChoice);
			childrenInRide[rideOfChoice]--;
			if(childrenInRide[rideOfChoice] == 0){
				printf("\n\t\t\t\tLast kid to leave RIDE %d...",rideOfChoice);
				actualNumberOfChildrenInRide[rideOfChoice] = 0;
				riding[rideOfChoice] = false;
			}
			pthread_mutex_unlock(&MUTEX_CHILDREN[rideOfChoice]);
			
			
		}
		else{
			// the ride is crowded, the child goes to another one.
			pthread_mutex_unlock(&MUTEX_CHILDREN[rideOfChoice]);
		}
	}
}


int main(){
	int i;
	int *id;
	pthread_t switcher[N_RIDES];
	pthread_t child[N_CHILDREN];

	/*iniciando variaveis*/
	srand((unsigned) time(&t));
	for(i = 0; i < N_RIDES; i++)
		sem_init(&rideSemaphore[i], 0, 0);
	for(i = 0; i < N_RIDES; i++)
		sem_init(&childEnjoysRide[i], 0, 0);
	for(i = 0; i < N_RIDES; i++)
		pthread_mutex_init(&MUTEX[i], 0);
	for(i = 0; i < N_RIDES; i++)
		pthread_mutex_init(&MUTEX_CHILDREN[i], 0);
	for(i = 0; i < N_RIDES; i++)
		childrenInRide[i] = 0;
	for(i = 0; i < N_RIDES; i++)
		riding[i] = 0;
	for(i = 0; i < N_RIDES; i++)
		actualNumberOfChildrenInRide[i] = 0;
	/*FIM_iniciando variaveis*/

	/*criando THREADS*/
	for(i = 0; i < N_CHILDREN; i++){
		id = (int *) malloc(sizeof(int));
		*id = i;
		pthread_create(&child[i], NULL, child_THREAD, (void*) id);
	}
	for(i = 0; i < N_RIDES; i++){
		id = (int *) malloc(sizeof(int));
		*id = i;
		pthread_create(&switcher[i], NULL, switcher_THREAD, (void*) id);
	}
	/*FIM_criando THREADS*/
	pthread_join(child[0], NULL);
}