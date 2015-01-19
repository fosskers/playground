#include <stdio.h>
#include <stdlib.h>
#include <gsl/gsl_linalg.h>

int main(int argc, char** argv) {
        gsl_vector* v = gsl_vector_alloc(4);

        // Initialize all entries.
        gsl_vector_set_all(v,1);

        gsl_vector_add(v,v);
        
        printf("%f\n", gsl_vector_get(v,0));

        gsl_vector_free(v);

        printf("Done.\n");
        
        return EXIT_SUCCESS;
}
