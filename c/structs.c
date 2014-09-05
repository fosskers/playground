#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

struct Cat {
        char* name;
        int age;
        int weight;
        int speed;
};

struct Cat* Cat_create(char* name, int age, int weight, int speed) {
        struct Cat* cat = malloc(sizeof(struct Cat));
        assert(cat != NULL);

        cat->name   = strdup(name);
        cat->age    = age;
        cat->weight = weight;
        cat->speed  = speed;

        return cat;
}

// No... the kitty...
// This manual memory management is tedious.
void Cat_kill(struct Cat* cat) {
        assert(cat != NULL);

        free(cat->name);
        free(cat);
}

void Cat_print(struct Cat* cat) {
        printf("Name: %s\n", cat->name);
        printf("Speed: %d\n", cat->speed);
}

int main(int argc, char** argv) {
        struct Cat* jack = Cat_create("Jack", 1, 7, 10);

        printf("Jack is @ %p\n", jack);

        Cat_print(jack);
        Cat_kill(jack);

        return 0;
}
