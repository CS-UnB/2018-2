#include "stdio.h"
#include "unistd.h"
#include "stdlib.h"
#include "pthread.h"

#define ESC 10 //numero de escritores
#define LEI 20 //numero de leitores


pthread_mutex_t mutex; 
pthread_mutex_t line; 
pthread_mutex_t counter_mutex; 

int processes_reading = 0;

void* reader(void *arg);
void* writer(void *arg);
void read_data();
void write_data();
void do_something();

int main() {
	pthread_mutex_init(&mutex, NULL);
	pthread_mutex_init(&counter_mutex, NULL);
	pthread_mutex_init(&line, NULL);

	pthread_t r[LEI], w[ESC];

	int i;
        int *id;
        /* criando leitores */
    	for (i = 0; i < LEI ; i++) {
	   id = (int *) malloc(sizeof(int));
           *id = i;
		 pthread_create(&r[i], NULL, reader, (void *) (id));
	}

	 /* criando escritores */
	for (i = 0; i< ESC; i++) {
	   id = (int *) malloc(sizeof(int));
           *id = i;
		 pthread_create(&w[i], NULL, writer, (void *) (id));
	}

	pthread_join(r[0],NULL);
	return 0;
}

void* reader(void *arg) {
	int i = *((int *) arg);
	while(1) {               /* repere para sempre */
		 pthread_mutex_unlock(&line);
		 pthread_mutex_lock(&counter_mutex); 	/* acesso exclusivo ao contador de processos lendo */
		 processes_reading += 1;

		 if (processes_reading == 1) {	/* o primeiro leitor trava o banco para não haver escrita */
		     pthread_mutex_lock(&mutex);   
		 }
		 pthread_mutex_unlock(&counter_mutex);	/* libera o acesso exclusivo ao banco */
		 read_data(i);       			/* acesso aos dados */
		 pthread_mutex_unlock(&line);
		 pthread_mutex_lock(&counter_mutex);     	/* acesso exclusivo ao contador de processos lendo */
		 processes_reading += (-1);
		 if (processes_reading == 0) {          	/* se este for o ultimo leitor */   
		     pthread_mutex_unlock(&mutex);
		 }
		 pthread_mutex_unlock(&counter_mutex);  /* libera o acesso exclusivo ao contador */
		 do_something("Reader", i);        		/* fim da região crítica */
	}
        pthread_exit(0);
}

void* writer(void *arg) {
	int i = *((int *) arg);

	while(1) {               /* repete para sempre */
		 do_something("Writer", i);	/* fazendo algo fora da regiao critica*/
		 pthread_mutex_lock(&line);
		 pthread_mutex_lock(&mutex);          /* obtÃ©m acesso exclusivo */
		 write_data(i);      /* atualiza os dados */
		 pthread_mutex_unlock(&mutex);          /* libera o acesso exclusivo */
		 pthread_mutex_unlock(&line);
	}
        pthread_exit(0);
}

void read_data(int i) {
	printf("Reader %d is reading data! Total readers = %d \n", i, processes_reading);
	sleep( rand() % 5);
}

void do_something(char str[], int i) {
	printf("%s %d is doing something out of the shared memory space!\n", str, i);
	sleep(rand() % 5);
}

void write_data(int i) {
	printf("Reader %d is writing data!\n", i);
	sleep( rand() % 5);
}
