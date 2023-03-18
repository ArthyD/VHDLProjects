#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>

#define NUM_THREADS 3

  int fp,fb;
  char pgcd_input[3];
  char pgcd_output[6];
  char btns[1];

void *perform_work_btns(void *arguments){
  int index = *((int *)arguments);
  printf("THREAD %d: Started.\n", index);
  while (1)
  {
    read(fb,&btns,1);
    if (btns[0] != 0)
    {
        pgcd_input[2]=1;
        write(fp,pgcd_input,3);
        pgcd_input[2]=0;
        write(fp,pgcd_input,3);
    }
  }
  printf("THREAD %d: Ended.\n", index);
  return NULL;
}

void *perform_work_valid(void *arguments){
  int index = *((int *)arguments);
  printf("THREAD %d: Started.\n", index);
  while (1)
  {
    read(fp, &pgcd_output,6);
    if(pgcd_output[3] != 1){

         // Read return value
        printf("Le PGCD de %d et %d est : %d\r\n", pgcd_output[0],pgcd_output[1],pgcd_output[4]);
        printf("Calculé en %d cycles \r\n",pgcd_output[5] );   
    }
  
 
  }
  printf("THREAD %d: Ended.\n", index);
  return NULL;
}

void *perform_work_keyboard(void *arguments){
  int index = *((int *)arguments);
  char str[100];
  int op1;
  int op2;
  printf("THREAD %d: Started.\n", index);
  while(1){
  scanf("%d %d", &op1, &op2);
  if(op1 ==0 || op2 == 0){
    printf("Avoid 0");
  } else{
    pgcd_input[0]=op1;
    pgcd_input[1]=op2;
    write(fp,pgcd_input,3);
    
  }
  }


  printf("THREAD %d: Ended.\n", index);
  return NULL;
}





int main(void) {
  pthread_t threads[NUM_THREADS];
  int thread_args[NUM_THREADS];
  int i;
  int result_code;
  char k;

  fp = open("/dev/pgcd_coproc",O_RDWR);
  fb = open("/dev/btns",O_RDWR);
  
  //create all threads one by one
  printf("IN MAIN: Creating thread %d.\n", 0);
  thread_args[0] = 0;
  result_code = pthread_create(&threads[0], NULL, perform_work_btns, &thread_args[0]);
  assert(!result_code);

  printf("IN MAIN: Creating thread %d.\n", 1);
  thread_args[1] = 1;
  result_code = pthread_create(&threads[1], NULL, perform_work_keyboard, &thread_args[1]);
  assert(!result_code);

  printf("IN MAIN: Creating thread %d.\n", 2);
  thread_args[2] = 2;
  result_code = pthread_create(&threads[2], NULL, perform_work_valid, &thread_args[2]);
  assert(!result_code);

  printf("IN MAIN: All threads are created.\n");

  printf("Enter your operands\n");


  //wait for each thread to complete
  for (i = 0; i < NUM_THREADS; i++) {
    result_code = pthread_join(threads[i], NULL);
    assert(!result_code);
    printf("IN MAIN: Thread %d has ended.\n", i);
  }

  printf("MAIN program has ended.\n");
  return 0;
}