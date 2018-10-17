/*LOGICA FUNCIONANDO PARA 1 PROFESSOR*
SOLUCIONAR COM VETOR DE SEMAFOROS E MUTEX COM UM ID PARA CADA PROFESSOR*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#define MAXIMO_ALUNOS_SALA 18
#define MINIMO_ALUNOS_SALA 8
#define N_PROF 10
#define N_ALUNOS 355
#define N_SALAS 5
#define TEMPO_AULA 2
#define SALA_ALUNO salaALUNO
#define SALA_PROF salaPROF

sem_t professor_SEM[N_SALAS];				/*initialize with 0, binary semaphore*/
sem_t alunoAssisteAula_SEM[N_SALAS];		/*initialize with 0, binary semaphore*/
pthread_mutex_t MUTEX[N_SALAS];
pthread_mutex_t MUTEX_ALUNO[N_SALAS];
int alunos_emSala[N_SALAS];
int registroAlunosSala[N_SALAS];
int salas[N_SALAS];
time_t t;

void * professores_THREAD(void *arg_prof){
	int const profId = *(int*) arg_prof;
	int SALA_PROF = 0;
	while(1){
		SALA_PROF = (profId+ ((int)(drand48()*100))) % N_SALAS;
		sem_wait(&professor_SEM[SALA_PROF]);
		if((salas[SALA_PROF] == 0) && (0 == pthread_mutex_trylock(&MUTEX[SALA_PROF]))){
			salas[SALA_PROF] = 1;
			if(alunos_emSala[SALA_PROF] < MAXIMO_ALUNOS_SALA){
				salas[SALA_PROF] = 0;
				printf("\n\n\n######################################### PROFESSOR %d - SALA %d #############################################################\n# "
				"\n#\t %d ALUNOS na SALA\n#\tVou aguardar um pouco..."
				"\n#############################################################################################################################\n\n\n ", profId, SALA_PROF, alunos_emSala[SALA_PROF]);
				sleep(1);
			}
			salas[SALA_PROF] = 1; /*PROFESSOR fecha a porta*/ 
			printf("\n\n\n######################################### PROFESSOR %d - SALA %d #############################################################\n# "
				"\n#\t %d ALUNOS na SALA\n#\tVamos dar inicio a aula...\n#\n#\n#\t\t\t$$$$$$ AULA $$$$$$\n#\n#\n#"
				"\n#############################################################################################################################\n\n\n ", profId, SALA_PROF, alunos_emSala[SALA_PROF]);
			sleep(TEMPO_AULA);

			for(int i = 0; i < registroAlunosSala[SALA_PROF]; i++){
				sem_post(&alunoAssisteAula_SEM[SALA_PROF]);
			}
			pthread_mutex_unlock(&MUTEX[SALA_PROF]);
		}
	}
}

void * alunos_THREAD(void *arg_aluno){
	int alunoId = *(int*) arg_aluno;
	int SALA_ALUNO = 0;
	while(1){
		SALA_ALUNO = (alunoId+ ((int)(drand48()*100))) % N_SALAS;
		pthread_mutex_lock(&MUTEX_ALUNO[SALA_ALUNO]);
		if((alunos_emSala[SALA_ALUNO] < MAXIMO_ALUNOS_SALA) && (salas[SALA_ALUNO] == 0)) {
			alunos_emSala[SALA_ALUNO]++;
			registroAlunosSala[SALA_ALUNO]++;
			printf("\n\t> ALUNO %d:\n\t\tTem %d vagas na SALA %d. Vou pegar uma cadeira", *(int*) arg_aluno, (MAXIMO_ALUNOS_SALA - alunos_emSala[SALA_ALUNO]), SALA_ALUNO);
			if(alunos_emSala[SALA_ALUNO] == MINIMO_ALUNOS_SALA){
				printf("\n\n\n###############################################################################################################################\n# "
					"\t\t\t\tMINIMO DE AULUNOS PARA AULA NA SALA %d.\n#\t\t\t\tPROFESOR VAI ENTRAR EM SALA."
					"\n###############################################################################################################################\n\n\n", SALA_ALUNO);
				sem_post(&professor_SEM[SALA_ALUNO]);
			}
			else if(alunos_emSala[SALA_ALUNO] == MAXIMO_ALUNOS_SALA){
				printf("\n\n\n###############################################################################################################################\n# "
					"\t\t\t\tSALA %d cheia. ALUNOS fecham a porta."
					"\n###############################################################################################################################\n\n\n", SALA_ALUNO);
			}
			pthread_mutex_unlock(&MUTEX_ALUNO[SALA_ALUNO]);
			sem_wait(&alunoAssisteAula_SEM[SALA_ALUNO]);
			//assiteAula();
			/*ALUNOS start to leave the classroom*/
			pthread_mutex_lock(&MUTEX_ALUNO[SALA_ALUNO]);
			printf("\n\t\t< ALUNO %d:\n\t\t\tSaindo da SALA %d...", *(int*) arg_aluno, SALA_ALUNO);
			alunos_emSala[SALA_ALUNO]--;
			if(alunos_emSala[SALA_ALUNO] == 0){
				printf("\n\t\t\t\tULTIMO aluna a sair da SALA %d...",SALA_ALUNO);
				registroAlunosSala[SALA_ALUNO] = 0;
				salas[SALA_ALUNO] = 0;
			}
			pthread_mutex_unlock(&MUTEX_ALUNO[SALA_ALUNO]);
			
			
		}
		else{
			pthread_mutex_unlock(&MUTEX_ALUNO[SALA_ALUNO]);
		}
	}
}


int main(){
	int i;
	int *id;
	pthread_t professores[N_PROF];
	pthread_t alunos[N_ALUNOS];

	/*iniciando variaveis*/
	srand((unsigned) time(&t));
	for(i = 0; i < N_SALAS; i++)
		sem_init(&professor_SEM[i], 0, 0);
	for(i = 0; i < N_SALAS; i++)
		sem_init(&alunoAssisteAula_SEM[i], 0, 0);
	for(i = 0; i < N_SALAS; i++)
		pthread_mutex_init(&MUTEX[i], 0);
	for(i = 0; i < N_SALAS; i++)
		pthread_mutex_init(&MUTEX_ALUNO[i], 0);
	for(i = 0; i < N_SALAS; i++)
		alunos_emSala[i] = 0;
	for(i = 0; i < N_SALAS; i++)
		salas[i] = 0;
	for(i = 0; i < N_SALAS; i++)
		registroAlunosSala[i] = 0;
	/*FIM_iniciando variaveis*/

	/*criando THREADS*/
	for(i = 0; i < N_ALUNOS; i++){
		id = (int *) malloc(sizeof(int));
		*id = i;
		pthread_create(&alunos[i], NULL, alunos_THREAD, (void*) id);
	}
	for(i = 0; i < N_PROF; i++){
		id = (int *) malloc(sizeof(int));
		*id = i;
		pthread_create(&professores[i], NULL, professores_THREAD, (void*) id);
	}
	/*FIM_criando THREADS*/
	pthread_join(alunos[0], NULL);
}