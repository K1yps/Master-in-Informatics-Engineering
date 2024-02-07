#include<omp.h>
#include<stdio.h>


double f( double a ) {
 return (4.0 / (1.0 + a*a));
}

double pi = 3.141592653589793238462643;

int main() {
    double mypi = 0.0;
    int n = 1000000000; // number of points to compute
    float h = 1.0 / n;
    
    #pragma omp parallel for reduction(+:mypi) 
    for(int i=0; i<n; i++) {
        mypi += f(i*h);
    }
    mypi = mypi * h;

    printf("original = %.10f\n",pi);
    printf("mypi     = %.10f\n\n", mypi);
}
