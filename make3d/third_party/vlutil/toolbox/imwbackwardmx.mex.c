/* file:        imwbackward.c
** author:      Andrea Vedaldi
** description: Backward projection of an image.
**/

/* TODO. 
 * - Make a faster version for the uniform grid case.
 * - Rename variables.
 * - Check potential bug below!!!!
 */
#include"mex.h"
#include"math.h"
#include<mexutils.c>
#include<stdlib.h>

/** Matlab driver.
 **/
#define greater(a,b) (a) > (b)
#define max(a,b) (((a)>(b))?(a):(b))
#define min(a,b) (((a)<(b))?(a):(b))
#define getM(arg) mxGetM(in[arg])
#define getN(arg) mxGetN(in[arg])
#define getPr(arg) mxGetPr(in[arg])

int
findNeighbor(double x, const double* X, int K) {
  int i = 0 ;
  int j = K - 1 ;
  int pivot = 0 ;
  double y = 0 ;
  if(x <  X[i]) return i-1 ;
  if(x >= X[j]) return j ;

  while(i < j - 1) {
    pivot = (i+j) >> 1 ; 
    y = X[pivot] ;
    /*mexPrintf("%d %d %d %f %f\n",i,j,pivot,x,y) ;*/
    if(x < y) {
      j = pivot ;
    } else {
      i = pivot ;
    }    
  }
  return i ;
}

void
mexFunction(int nout, mxArray *out[], 
            int nin, const mxArray *in[])
{
  enum { X=0,Y,I,iwXp,iwYp } ;
  enum { wI=0 } ;

  int M, N, Mp, Np, ip, jp ;
  double *X_pt, *Y_pt, *I_pt, *iwXp_pt, *iwYp_pt, *wI_pt ;
  double Xmin, Xmax, Ymin, Ymax ;
  const double NaN = mxGetNaN() ;
  
  /* -----------------------------------------------------------------
   *                                               Check the arguments
   * -------------------------------------------------------------- */
  if(nin != 5) {
    mexErrMsgTxt("Five input argumets required.") ;
  }
  
  if(!uIsRealMatrix(in[I], -1, -1)) {
    mexErrMsgTxt("I must be a real matrix of class DOUBLE") ;
  }
  
  if(!uIsRealMatrix(in[iwXp], -1, -1)) {
    mexErrMsgTxt("iwXp must be a real matrix") ;
  }
  
  M = getM(I) ;
  N = getN(I) ;
  Mp = getM(iwXp) ;
  Np = getN(iwXp) ;

  if(!uIsRealMatrix(in[iwYp], Mp, Np)) {
      mexErrMsgTxt
	  ("iwXp and iwYp must be a real matrices of the same dimension") ;
  }

  if(!uIsRealVector(in[X],N) || !uIsRealVector(in[Y],M)) {
      mexErrMsgTxt
	  ("X and Y must be vectors of the same dimensions "
	   "of the columns/rows of I, respectivelye") ;
  }

  X_pt = getPr(X); 
  Y_pt = getPr(Y) ;
  I_pt = getPr(I) ;
  iwXp_pt = getPr(iwXp) ;
  iwYp_pt = getPr(iwYp) ;

  /* Allocate the result. */
  out[wI] = mxCreateDoubleMatrix(Mp, Np, mxREAL) ;
  wI_pt = mxGetPr(out[wI]) ;

  /* -----------------------------------------------------------------
   *                                                        Do the job
   * -------------------------------------------------------------- */
  Xmin = X_pt[0] ;
  Xmax = X_pt[N-1] ;
  Ymin = Y_pt[0] ;
  Ymax = Y_pt[M-1] ;

  for(jp = 0 ; jp < Np ; ++jp) {
    for(ip = 0 ; ip < Mp ; ++ip) {    
      /* Search for the four neighbors of the backprojected point. */     
      double x = *iwXp_pt++ ;
      double y = *iwYp_pt++ ;
      double z = NaN ;

      /* This messy code allows the identity transformation
       * to be processed as expected. */
      if(x >= Xmin && x <= Xmax &&
         y >= Ymin && y <= Ymax) {
        int j = findNeighbor(x, X_pt, N) ;
        int i = findNeighbor(y, Y_pt, M) ;
        double* pt  = I_pt + j*M + i ;
        
        /* Weights. */
        double x0 = X_pt[j] ;
        double x1 = X_pt[j+1] ;
        double y0 = Y_pt[i] ;
        double y1 = Y_pt[i+1] ;
        double wx = (x-x0)/(x1-x0) ;
        double wy = (y-y0)/(y1-y0) ;

        /* Load all possible neighbors. */
        double z00 = 0.0 ;
        double z10 = 0.0 ;
        double z01 = 0.0 ;
        double z11 = 0.0 ;

        /* 2006: possible bug? should pt++ in any case? */
        if(j > -1) {
          if(i > -1 ) z00 = *pt ;
          pt++ ;
          if(i < M-1) z10 = *pt ;
        }

        pt += M - 1;

        if(j < N-1) {
          if(i > -1 ) z01 = *pt ; 
          pt++ ;
          if(i < M-1) z11 = *pt ;
        }       

        /* Bilinear interpolation. */
        z = 
          (1-wy)*( (1-wx) * z00 + wx * z01) +
              wy*( (1-wx) * z10 + wx * z11) ; 
      }
      
      *(wI_pt + jp*Mp + ip) = z ;
    }
  }
}
