#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#define MAX_CHILDREN_IN_RIDE 18
#define MIN_CHILDREN_IN_RIDE 8
#define N_OPERATORS 10
#define N_CHILDREN 355
#define N_RIDES 5
#define RIDING_TIME 2

sem_t operator_SEM[N_RIDES];				/*initialize with 0, binary semaphore*/
sem_t childrenEnjoyRide_SEM[N_RIDES];		/*initialize with 0, binary semaphore*/
pthread_mutex_t MUTEX[N_RIDES];
pthread_mutex_t MUTEX_Children[N_RIDES];
int childrenInRide[N_RIDES];
int record_childrenInRide[N_RIDES];
int ride[N_RIDES];
time_t t;

void * operator_THREAD(void *arg){
	int const profId = *(int*) arg;
	int operatorsRideOfChoice = 0;
	while(1){
		operatorsRideOfChoice = (profId+ ((int)(drand48()*100))) % N_RIDES;
		sem_wait(&operator_SEM[operatorsRideOfChoice]);
		if((ride[operatorsRideOfChoice] == 0) && (0 == pthread_mutex_trylock(&MUTEX[operatorsRideOfChoice]))){
			ride[operatorsRideOfChoice] = 1;
			if(childrenInRide[operatorsRideOfChoice] < MAX_CHILDREN_IN_RIDE){
				ride[operatorsRideOfChoice] = 0;

				printf("\n\n\n######################################### Operator %d - Ride %d ################"
				"#############################################\n# "
				"\n#\t %d Children in this ride\n#\tLet's see if more arrive..."
				"\n###########################################################################################"
				"##################################\n\n\n ", profId, operatorsRideOfChoice, childrenInRide[operatorsRideOfChoice]);
				sleep(1);
			}
			ride[operatorsRideOfChoice] = 1; /*Funcionário fecha a porta do brinquedo*/ 
			printf("\n\n\n######################################### Operator %d - Ride %d ####################"
			"#########################################\n# "
				"\n#\t %d Children in this ride\n#\tLet's get the ride started...\n#\n#\n#\t\t\t$$$$$$ RIDING $$$$$$\n#\n#\n#"
				"\n###########################################################################################"
				"##################################\n\n\n ", profId, operatorsRideOfChoice, childrenInRide[operatorsRideOfChoice]);
			
			sleep(RIDING_TIME);
			for(int i = 0; i < record_childrenInRide[operatorsRideOfChoice]; i++){
				sem_post(&childrenEnjoyRide_SEM[operatorsRideOfChoice]);
			}
			pthread_mutex_unlock(&MUTEX[operatorsRideOfChoice]);
		}
	}
}

void * child_THREAD(void *arg){
	int alunoId = *(int*) arg;
	int childrensRideOfChoice = 0;
	while(1){
		childrensRideOfChoice = (alunoId+ ((int)(drand48()*100))) % N_RIDES;
		pthread_mutex_lock(&MUTEX_Children[childrensRideOfChoice]);
		if((childrenInRide[childrensRideOfChoice] < MAX_CHILDREN_IN_RIDE) && (ride[childrensRideOfChoice] == 0)) {
			childrenInRide[childrensRideOfChoice]++;
			record_childrenInRide[childrensRideOfChoice]++;

			printf("\n\t> Child %d:\n\t\tThere are %d empty seats in RIDE %d. I'll take one", *(int*) arg, 
					(MAX_CHILDREN_IN_RIDE - childrenInRide[childrensRideOfChoice]), childrensRideOfChoice);
			if(childrenInRide[childrensRideOfChoice] == MIN_CHILDREN_IN_RIDE){
				printf("\n\n\n#################################################################################"
				"##############################################\n# "
					"\t\t\t\tThere are enough children in RIDE %d.\n#\t\t\t\tThe operator will take his place."
					"\n########################################################################################"
					"#######################################\n\n\n", childrensRideOfChoice);
				sem_post(&operator_SEM[childrensRideOfChoice]);
			}
			else if(childrenInRide[childrensRideOfChoice] == MAX_CHILDREN_IN_RIDE){
				printf("\n\n\n#################################################################################"
				"##############################################\n# "
					"\t\t\t\tRIDE %d is crowded. Children get ready for the ride."
					"\n#########################################################################################"
					"######################################\n\n\n", childrensRideOfChoice);
			}
			
			pthread_mutex_unlock(&MUTEX_Children[childrensRideOfChoice]);
			sem_wait(&childrenEnjoyRide_SEM[childrensRideOfChoice]);
			//assiteAula();
			/*ALUNOS start to leave the classroom*/
			pthread_mutex_lock(&MUTEX_Children[childrensRideOfChoice]);
			printf("\n\t\t< CHILD %d:\n\t\t\tLeaving RIDE %d...", *(int*) arg, childrensRideOfChoice);
			childrenInRide[childrensRideOfChoice]--;
			if(childrenInRide[childrensRideOfChoice] == 0){
				printf("\n\t\t\t\tLAST child to leave RIDE %d...",childrensRideOfChoice);
				record_childrenInRide[childrensRideOfChoice] = 0;
				ride[childrensRideOfChoice] = 0;
			}
			pthread_mutex_unlock(&MUTEX_Children[childrensRideOfChoice]);
			
			
		}
		else{
			pthread_mutex_unlock(&MUTEX_Children[childrensRideOfChoice]);
		}
	}
}


int main(){
	int i;
	int *id;
	pthread_t professores[N_OPERATORS];
	pthread_t alunos[N_CHILDREN];

	/*iniciando variaveis*/
	srand((unsigned) time(&t));
	for(i = 0; i < N_RIDES; i++)
		sem_init(&operator_SEM[i], 0, 0);
	for(i = 0; i < N_RIDES; i++)
		sem_init(&childrenEnjoyRide_SEM[i], 0, 0);
	for(i = 0; i < N_RIDES; i++)
		pthread_mutex_init(&MUTEX[i], 0);
	for(i = 0; i < N_RIDES; i++)
		pthread_mutex_init(&MUTEX_Children[i], 0);
	for(i = 0; i < N_RIDES; i++)
		childrenInRide[i] = 0;
	for(i = 0; i < N_RIDES; i++)
		ride[i] = 0;
	for(i = 0; i < N_RIDES; i++)
		record_childrenInRide[i] = 0;
	/*FIM_iniciando variaveis*/

	/*criando THREADS*/
	for(i = 0; i < N_CHILDREN; i++){
		id = (int *) malloc(sizeof(int));
		*id = i;
		pthread_create(&alunos[i], NULL, child_THREAD, (void*) id);
	}
	for(i = 0; i < N_OPERATORS; i++){
		id = (int *) malloc(sizeof(int));
		*id = i;
		pthread_create(&professores[i], NULL, operator_THREAD, (void*) id);
	}
	/*FIM_criando THREADS*/
	pthread_join(alunos[0], NULL);
}