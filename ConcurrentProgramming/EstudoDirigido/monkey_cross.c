#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define MACACOS_ESQUERDA 5 
#define MACACOS_DIREITA 5 

pthread_mutex_t mutex_esquerda;
pthread_mutex_t mutex_direita;
pthread_mutex_t mutex;
pthread_mutex_t vez; 

int esquerda = 0;
int direita = 0;

void * macaco_esquerda(void * a){
    int i = *((int *) a);    
    while(1){
	 pthread_mutex_lock(&vez);
	 pthread_mutex_lock(&mutex_esquerda);
	 esquerda++;
	 if(esquerda == 1){
    		pthread_mutex_lock(&mutex);
	}
	pthread_mutex_unlock(&mutex_esquerda);
	pthread_mutex_unlock(&vez);
	printf("Monkey %d crossing from left to right \n",i);
	//sleep(100);
	 pthread_mutex_lock(&mutex_esquerda);
         esquerda--;
         printf("Monkey %d has finished crossing ; num: %d\n" ,i, esquerda);
	 if(esquerda == 0){
    		pthread_mutex_unlock(&mutex);
	}
	pthread_mutex_unlock(&mutex_esquerda);
    }
    pthread_exit(0);
}

void * macaco_direita(void * a)
{
    int i = *((int *) a);
    while(1){
	 pthread_mutex_lock(&vez);
	 pthread_mutex_lock(&mutex_direita);
	 direita++;
	 if(direita == 1){
    		pthread_mutex_lock(&mutex);
	}
	pthread_mutex_unlock(&mutex_direita);
	pthread_mutex_unlock(&vez);
	printf("Monkey %d crossing from right to left \n",i);
	//sleep(100);
	 pthread_mutex_lock(&mutex_direita);
	 direita--;
         printf("Monkey %d has finished crossing ; num: %d\n" ,i, direita);
	 if(direita == 0){
    		pthread_mutex_unlock(&mutex);
	}
	pthread_mutex_unlock(&mutex_direita);


    }
    pthread_exit(0);
}

int main(int argc, char * argv[])
{
    pthread_t vec[MACACOS_DIREITA+MACACOS_ESQUERDA];


    pthread_mutex_init(&mutex_esquerda, NULL);
    pthread_mutex_init(&mutex_direita, NULL);
    pthread_mutex_init(&mutex, NULL);
    pthread_mutex_init(&vez, NULL);


   int *id;
   int i = 0;
   for(i = 0; i < MACACOS_DIREITA+MACACOS_ESQUERDA; ++i)
    {
        id = (int *) malloc(sizeof(int));
        *id = i;
        if(i%2 == 0){
          if(pthread_create(&vec[i], NULL, &macaco_direita, (void*)id))
          {
		
            printf("Não pode criar a thread %d\n", i);
            return -1;
          }
        }else{
         if(pthread_create(&vec[i], NULL, &macaco_esquerda, (void*)id))
         {
            printf("Não pode criar a thread %d\n", i);
            return -1;
         }
        }
	id++;
    }

   

    for(i = 0; i < MACACOS_DIREITA+MACACOS_ESQUERDA; ++i)
    {
        if(pthread_join(vec[i], NULL))
        {
            printf("Could not join thread %d\n", i);
            return -1;
        }
    }



    printf("TERMINOU!\n");

    return 0;
}
