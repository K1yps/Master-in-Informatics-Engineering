#define MAXVERTICES 10
typedef int Graph[MAXVERTICES][MAXVERTICES];

/*@ requires ... &&
  @ \valid(A+(0..(n*n-1))) &&
  @ \valid(R+(0..(n*n-1))) &&
  @ \separated(A+(0..n*n-1), R+(0..n*n-1)) ;
  @ assigns R[0..n-1][0..n-1];
  @ ensures \forall integer k, l;
  @ 0 <= k < n && 0 <= l < n ==>
  @ A[k][l] == \at(A[k][l],Old);
  @*/
void WarshallTC (Graph A, Graph R, int n) {
    int i, j, k;
    for (i=0 ; i<n ; i++)
        for (j=0 ; j<n ; j++)
            R[i][j] = A[i][j];

    /*@ assert \forall integer k, l;
      @ 0 <= k < n && 0 <= l < n ==> R[k][l] == A[k][l];
      @*/
    for (k=0 ; k<n; k++)
        for (i=0 ; i<n ; i++)
            for (j=0 ; j<n ; j++)
                if (R[i][k] && R[k][j])
                    R[i][j] = 1;
}