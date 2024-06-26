#include "disp.h"

/*
  This routine performs Goldschmidt`s division 
  algorithm.  The user inputs the numerator, the denominator, 
  an initial approximation, the number of iterations, and 
  the precision of both the computation and the final result. 
        
*/

int main(int argc, char* argv[]) {
  double N, D, R, Q, X, RQ, RD, REM, RREM, prec, prec_f, scale;
  double N1, D1;
  double R1, R2;
  int num_iter, i, iprec, iprec_f;
  if (argc < 7) {
    fprintf(stderr,"Usage: %s numerator denominator intial-value iterations prec prec_f \n", argv[0]);
    exit(1);
  }
  /* Read in values */
  sscanf(argv[1],"%lg", &N);
  sscanf(argv[2],"%lg", &D);
  sscanf(argv[3],"%lg", &R);
  sscanf(argv[4],"%d", &num_iter);
  sscanf(argv[5],"%lg", &prec);
  sscanf(argv[6],"%lg", &prec_f);
  /* 
     Adjust input to proper bit size (i.e. given precision) 

     Note: iprec_f is the internal precision which can be larger than
     output precision, so that answer is accurate
  */
  iprec = (int) prec;
  iprec_f = (int) prec_f;
  /*
    It's important to round the input numbers, since most users
    input numbers that don't fit the precision of your registers.
  */
  N = N1 = rne(N, iprec_f);
  D = D1 = rne(D, iprec_f);
  /* Actual quotient */
  Q = N/D;
  printf("N = %1.15lf = ", N);
  disp_bin(N, 1, iprec_f, stdout); //display in binary?
  printf("\n");
  printf("D = %1.15lf = ", D);
  disp_bin(D, 1, iprec_f, stdout);
  printf("\n\n");
  for (i = 0; i < num_iter; i++) {
    N = flr(N*R, prec);
    D = flr(D*R, prec);
    R = flr(2 - D - pow(2.0, -prec), prec);
    printf("i = %d, N = %lf, D = %lf, R = %lf\n", i, N, D, R); //modified to incorporate D value
    printf("i = %d, N = ", i);
    disp_bin(N, 2, iprec, stdout); //2 bits int, iprec is 26 bits decimal
    printf(", D = ");
    disp_bin(D, 2, iprec, stdout);
    printf(", R = ");
    disp_bin(R, 2, iprec, stdout);
    
    printf("\n");
  }
  
  R1 = flr(D1*N, prec);
  printf("R1 = %1.15lf\n", R1);
  disp_bin(R1, 2, iprec, stdout);
  printf("\n");
  //R2 = N1 - R1;
  R2 = R1 - N1; //flipped what is being subtracted
  printf("R2 = %1.15lf\n", R2);
  disp_bin(R2, 2, iprec, stdout);
  printf("\n");


  /* Actual Answer */
  RQ = flr(Q, prec_f);
  /* Computed using Goldschmit's iteration */
  RD = flr(N, iprec_f);

  printf("\n");
  printf("Actual Answer\n");
  printf("RQ = %1.15lf = ", RQ);
  disp_bin(RQ, 2, (int) prec_f, stdout);
  printf("\n");
  printf("GDIV Answer\n");
  printf("RD = %1.15lf = ", RD);
  disp_bin(RD, 2, (int) prec_f, stdout);
  printf("\n\n");

  /* Error Analysis */
  printf("Error Analysis\n");
  printf("error =  %1.15lf\n", fabs(RQ - RD));
  printf("#bits = %1.15lf\n", log(fabs(RQ-RD))/log(2.0));
  printf("\n");

  /* Remainder */
  scale = pow(2.0, prec_f); //scaling the remaider to be much larger than it is (up 23 bits)
  //REM  = scale*(N1 - RD*D1);
  REM  = scale*(N*D1 - N1); //flipped what is being subtracted
  RREM = flr(REM, iprec_f);
  printf("Remainder\n");
  printf("RREM = %1.15lf\n", RREM);
  printf("RREM = ");
  disp_bin(RREM, 1, (int) prec_f, stdout);
  printf("\n\n");

}
