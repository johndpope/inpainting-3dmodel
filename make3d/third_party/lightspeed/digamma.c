/* compile with: cmex digamma.c mexutil.c util.c -lm
 * test in matlab:
 *   digamma(1:10)
 */
/* Written by Tom Minka
 * (c) Microsoft Corporation. All rights reserved.
 */
#include "mex.h"
#include "util.h"

void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
  int ndims, len, i;
  int * dims;
  double *indata, *outdata;

  if((nlhs > 1) || (nrhs != 1))    
    mexErrMsgTxt("Usage: x = digamma(n)");

  /* prhs[0] is first argument.
   * mxGetPr returns double*  (data, col-major)
   */
  ndims = mxGetNumberOfDimensions(prhs[0]);
  dims = (int*)mxGetDimensions(prhs[0]);
  indata = mxGetPr(prhs[0]);
  len = mxGetNumberOfElements(prhs[0]);

  if(mxIsSparse(prhs[0]))
    mexErrMsgTxt("Cannot handle sparse matrices.  Sorry.");

  /* plhs[0] is first output */
  plhs[0] = mxCreateNumericArray(ndims, dims, mxDOUBLE_CLASS, mxREAL);
  outdata = mxGetPr(plhs[0]);

  /* compute digamma of every element */
  for(i=0;i<len;i++)
    *outdata++ = digamma(*indata++);
}

