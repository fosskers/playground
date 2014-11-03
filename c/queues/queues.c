/* Typeable Lists in C */

#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>

#include "../dbg.h"

// --- //

/*
  TAILQ_ENTRY(TYPE);
  TAILQ_HEAD(HEADNAME, TYPE);
  TAILQ_INIT(TAILQ_HEAD *head);
  TAILQ_INSERT_AFTER(TAILQ_HEAD *head, TYPE *listelm,
                     TYPE *elm, TAILQ_ENTRY NAME);
  TAILQ_INSERT_HEAD(TAILQ_HEAD *head,
                    TYPE *elm, TAILQ_ENTRY NAME);
  TAILQ_INSERT_TAIL(TAILQ_HEAD *head,
                    TYPE *elm, TAILQ_ENTRY NAME);
  TAILQ_REMOVE(TAILQ_HEAD *head, TYPE *elm, TAILQ_ENTRY NAME)
*/

// struct name and the param of TAILQ_ENTRY must be the sam.e
typedef struct entry {
        int n;
        // Pointers to the rest of the Queue.
        TAILQ_ENTRY(entry) entries;
} entry;

int main(int argc, char** argv) {
        TAILQ_HEAD(tailhead, entry) head;
        //        struct tailhead* headp;
        entry* e;
        entry* p;

        TAILQ_INIT(&head);
        
        e = malloc(sizeof(entry));
        e->n = 1;
        TAILQ_INSERT_HEAD(&head, e, entries);
        
        e = malloc(sizeof(entry));
        e->n = 2;
        TAILQ_INSERT_TAIL(&head, e, entries);

        e = malloc(sizeof(entry));
        e->n = 0;
        TAILQ_INSERT_HEAD(&head, e, entries);

        /* Traverse */
        for(p = head.tqh_first; p != NULL; p = p->entries.tqe_next) {
                printf("n: %d\n", p->n);
        }

        return EXIT_SUCCESS;
}
