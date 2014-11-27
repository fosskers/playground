/* A non-blocking circular queue that could be used to solve
 * the Producer-Consumer problem.
 * created: 2014 November 26 @ 13:44
 */

#include <pthread.h>
#include <stdbool.h>
#include <stdlib.h>

// --- //

#define BUFFER_MAX 10
#define elem_t int  // Could be any type.

/* ATOMICALLY compares/swaps values. Important for avoiding races. */
#define swap(p, old, new) __sync_bool_compare_and_swap(p, old, new)

elem_t buffer[BUFFER_MAX];

// Read/write index management
int wIndex = 0;
int rIndex = 0;
int maxRIndex = 0;  // This gives us thread safety.

// --- //

bool queue_full_empty(int i1, int i2) {
        // Test the proximity of the two indexes
        return i1 % BUFFER_MAX == i2 % BUFFER_MAX;
}

bool queue_push(const elem_t elem) {
        int currWIndex;
        int currRIndex;

        while(true) {
                currWIndex = wIndex;
                currRIndex = rIndex;

                if(queue_full_empty(currWIndex + 1, currRIndex)) {
                        return false;  // Couldn't push.
                }

                // Swaps the value of wIndex with the third arg if it's
                // equal to the second.
                if(swap(&wIndex, currWIndex, currWIndex + 1)) {
                        break;
                }
        }

        // The actual push.
        buffer[currWIndex % BUFFER_MAX] = elem;

        // As we've written a value, we can advance the `read` index.
        while(!swap(&maxRIndex, currWIndex, currWIndex + 1)) {}

        return true;
}

bool queue_pop(elem_t* elem) {
        int currRIndex;
        int currMaxRIndex;
    
        while(true) {
                currRIndex = rIndex;
                currMaxRIndex = maxRIndex;

                if(queue_full_empty(currRIndex, currMaxRIndex)) {
                        return false;  // Queue empty.
                }

                // The actual pop.
                *elem = buffer[currRIndex % BUFFER_MAX];

                // Update read index and leave.
                if(swap(&rIndex, currRIndex, currRIndex + 1)) {
                        return true;
                }
        }
}

void* produce(void* ptr) {
        elem_t x = 0;

        while(true) {
                if(!queue_push(x)) {
                        // Errors!
                }

                x++;
        }

        pthread_exit(0);
}

void* consume(void* ptr) {
        elem_t x;

        while(true) {
                if(!queue_pop(&x)) {
                        // Errors!
                } else {
                        // Work with `x`
                }
        }

        pthread_exit(0);
}

int main() {
        // Work.

        return EXIT_SUCCESS;
}
