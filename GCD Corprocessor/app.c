#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>


int main()
{ 
  int fp;
  char pgcd_input[3];
  char pgcd_output[6];

  pgcd_input[0] = 90;
  pgcd_input[1] = 45;

  // Open pgcd_coproc

  fp = open("/dev/pgcd_coproc", O_RDWR);

  // Write input values, and go = 1
  pgcd_input[2] = 1; // go = 1
  write(fp, pgcd_input,3);

  // Write input values, and go = 0
  pgcd_input[2] = 0; // go = 1
  write(fp, pgcd_input,3);

  // Wait until valid = 1
  read(fp, &pgcd_output,6);
  while (pgcd_output[3] != 1){

    read(fp, &pgcd_output,6);    
  }
  
  // Read return value
  printf("Le PGCD de %d et %d est : %d\r\n", pgcd_output[0],pgcd_output[1],pgcd_output[4]);
  printf("Calculé en %d cycles \r\n",pgcd_output[5] );
}
