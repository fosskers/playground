/* Playing with pthreads */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#include "../dbg.h"

// --- //

void* func(void*);

// --- //

#define THREADS 10

pthread_mutex_t mutex;
int count = 0;

// --- //

void* func(void* ptr) {
        pthread_mutex_lock(&mutex);
        count++;
        printf("Count: %d\n", count);
        pthread_mutex_unlock(&mutex);

        pthread_exit(0);
}

int main(int argc, char** argv) {
        pthread_t ts[THREADS];
        int i, r;

        /* Initialize Mutex */
        pthread_mutex_init(&mutex, NULL);

        /* Create threads */
        for(i = 0; i < THREADS; i++) {
                r = pthread_create(&ts[i], NULL, func, NULL);
                check(r == 0, "Failed to create thread.");
        }

        /* Wait for threads to finish */
        for(i = 0; i < THREADS; i++) {
                pthread_join(ts[i], NULL);
        }

        return EXIT_SUCCESS;

 error:
        return EXIT_FAILURE;
}
