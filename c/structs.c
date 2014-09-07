#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

// --- //

// Define the struct and give it an alias at the same time.
typedef struct CAT {
        char* name;
        int   age;
        int   weight;
        int   speed;
} Cat;

Cat* Cat_create(const char* name, int age, int weight, int speed) {
        Cat* cat = malloc(sizeof(Cat));
        assert(cat != NULL);

        cat->name   = strdup(name);
        cat->age    = age;
        cat->weight = weight;
        cat->speed  = speed;

        return cat;
}

// No... the kitty...
// This manual memory management is tedious.
void Cat_kill(Cat* cat) {
        assert(cat != NULL);

        // Have to free inner memory as well.
        free(cat->name);
        free(cat);
}

void Cat_print(Cat* cat) {
        printf("Cat { name=%s, age=%d, weight=%d, speed=%d }\n",
               cat->name, cat->age, cat->weight, cat->speed);
}

int main(int argc, char** argv) {
        Cat* jack = Cat_create("Jack", 1, 7, 10);

        printf("Jack is stored at: %p\n", jack);

        Cat_print(jack);
        Cat_kill(jack);

        Cat* tinsel = Cat_create("Tinsel", 11, 7, 8);

        Cat_print(tinsel);
        Cat_kill(tinsel);

        return 0;
}
