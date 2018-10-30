#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#define MAX_CHILDREN_IN_A_RIDE 18
#define MIN_CHILDREN_IN_A_RIDE 8
#define N_RIDES 10
#define N_CHILDREN 355
// #define N_RIDES 5
#define RIDE_TIME 2
#define CHILD_IN_RIDE salaALUNO
#define rideId salaPROF

sem_t rideSemaphore[N_RIDES];				/*initialize with 0, binary semaphore*/
sem_t childEnjoysRide[N_RIDES];		/*initialize with 0, binary semaphore*/
pthread_mutex_t MUTEX[N_RIDES];
pthread_mutex_t MUTEX_ALUNO[N_RIDES];
int childrenInRide[N_RIDES];
int actualNumberOfChildrenInRide[N_RIDES];
bool riding[N_RIDES] = {[0 ... (N_RIDES-1)] = false};
time_t t;

void * ride_THREAD(void *arg, char *nameArg, const int idealAge){
	const int rideId = *(int*) arg;
	const int bestSuitedForAgesUpTo = idealAge;
	const int rideTime = (drand48()*100) % N_RIDES;
	char *name;
	strcpy(name, nameArg);

	while(1){
		sem_wait(&rideSemaphore[rideId]);
		// if((riding[rideId] == 0) && (0 == pthread_mutex_trylock(&MUTEX[rideId]))){
			// riding[rideId] = 1;
		pthread_mutex_lock(&MUTEX[rideId]);
		riding[rideId] = true;
			if(childrenInRide[rideId] < MAX_CHILDREN_IN_A_RIDE){
				riding[rideId] = false;
				printf("\n\n\n######################################### PROFESSOR %d - SALA %d #############################################################\n# "
				"\n#\t %d ALUNOS na SALA\n#\tVou aguardar um pouco..."
				"\n#############################################################################################################################\n\n\n ", rideId, rideId, childrenInRide[rideId]);
				sleep(1);
			}
			riding[rideId] = True; /*PROFESSOR fecha a porta*/ 
			printf("\n\n\n######################################### PROFESSOR %d - SALA %d #############################################################\n# "
				"\n#\t %d ALUNOS na SALA\n#\tVamos dar inicio a aula...\n#\n#\n#\t\t\t$$$$$$ AULA $$$$$$\n#\n#\n#"
				"\n#############################################################################################################################\n\n\n ", rideId, rideId, childrenInRide[rideId]);
			sleep(RIDE_TIME);

			for(int i = 0; i < actualNumberOfChildrenInRide[rideId]; i++){
				sem_post(&childEnjoysRide[rideId]);
			}
			pthread_mutex_unlock(&MUTEX[rideId]);
		}
	}
}

void * alunos_THREAD(void *arg, char *nameArg, const int ageArg, ){
	int alunoId = *(int*) arg;

	while(1){
		CHILD_IN_RIDE = (alunoId+ ((int)(drand48()*100))) % N_RIDES;
		pthread_mutex_lock(&MUTEX_ALUNO[CHILD_IN_RIDE]);
		if((childrenInRide[CHILD_IN_RIDE] < MAX_CHILDREN_IN_A_RIDE) && (riding[CHILD_IN_RIDE] == 0)) {
			childrenInRide[CHILD_IN_RIDE]++;
			actualNumberOfChildrenInRide[CHILD_IN_RIDE]++;
			printf("\n\t> ALUNO %d:\n\t\tTem %d vagas na SALA %d. Vou pegar uma cadeira", *(int*) arg, (MAX_CHILDREN_IN_A_RIDE - childrenInRide[CHILD_IN_RIDE]), CHILD_IN_RIDE);
			if(childrenInRide[CHILD_IN_RIDE] == MIN_CHILDREN_IN_A_RIDE){
				printf("\n\n\n###############################################################################################################################\n# "
					"\t\t\t\tMINIMO DE AULUNOS PARA AULA NA SALA %d.\n#\t\t\t\tPROFESOR VAI ENTRAR EM SALA."
					"\n###############################################################################################################################\n\n\n", CHILD_IN_RIDE);
				sem_post(&rideSemaphore[CHILD_IN_RIDE]);
			}
			else if(childrenInRide[CHILD_IN_RIDE] == MAX_CHILDREN_IN_A_RIDE){
				printf("\n\n\n###############################################################################################################################\n# "
					"\t\t\t\tSALA %d cheia. ALUNOS fecham a porta."
					"\n###############################################################################################################################\n\n\n", CHILD_IN_RIDE);
			}
			pthread_mutex_unlock(&MUTEX_ALUNO[CHILD_IN_RIDE]);
			sem_wait(&childEnjoysRide[CHILD_IN_RIDE]);
			//assiteAula();
			/*ALUNOS start to leave the classroom*/
			pthread_mutex_lock(&MUTEX_ALUNO[CHILD_IN_RIDE]);
			printf("\n\t\t< ALUNO %d:\n\t\t\tSaindo da SALA %d...", *(int*) arg, CHILD_IN_RIDE);
			childrenInRide[CHILD_IN_RIDE]--;
			if(childrenInRide[CHILD_IN_RIDE] == 0){
				printf("\n\t\t\t\tULTIMO aluna a sair da SALA %d...",CHILD_IN_RIDE);
				actualNumberOfChildrenInRide[CHILD_IN_RIDE] = 0;
				riding[CHILD_IN_RIDE] = 0;
			}
			pthread_mutex_unlock(&MUTEX_ALUNO[CHILD_IN_RIDE]);
			
			
		}
		else{
			pthread_mutex_unlock(&MUTEX_ALUNO[CHILD_IN_RIDE]);
		}
	}
}


int main(){
	int i;
	int *id;
	pthread_t professores[N_RIDES];
	pthread_t alunos[N_CHILDREN];

	/*iniciando variaveis*/
	srand((unsigned) time(&t));
	for(i = 0; i < N_RIDES; i++)
		sem_init(&rideSemaphore[i], 0, 0);
	for(i = 0; i < N_RIDES; i++)
		sem_init(&childEnjoysRide[i], 0, 0);
	for(i = 0; i < N_RIDES; i++)
		pthread_mutex_init(&MUTEX[i], 0);
	for(i = 0; i < N_RIDES; i++)
		pthread_mutex_init(&MUTEX_ALUNO[i], 0);
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
		pthread_create(&alunos[i], NULL, alunos_THREAD, (void*) id);
	}
	for(i = 0; i < N_RIDES; i++){
		id = (int *) malloc(sizeof(int));
		*id = i;
		pthread_create(&professores[i], NULL, ride_THREAD, (void*) id);
	}
	/*FIM_criando THREADS*/
	pthread_join(alunos[0], NULL);
}