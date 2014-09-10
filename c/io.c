#include <stdio.h>
#include <stdlib.h>
#include "dbg.h"

#define MAX_DATA 100

typedef enum { BLUE, GREEN, BROWN, BLACK, OTHER } EyeColour;

const char* COLOUR_NAMES[] = { "Blue", "Green", "Brown", "Black", "Other" };

typedef struct {
        int age;
        char first_name[MAX_DATA];
        char last_name[MAX_DATA];
        EyeColour eyes;
        float income;
} Person;

// Strips newlines off a given String, in place.
void strip(char* str) {
        size_t len = strlen(str) - 1;
        
        if(str[len] == '\n') {
                str[len] = '\0';
        }
}

int main(int argc, char** argv) {
        Person you = { .age = 0 };
        int i;
        char* in = NULL;

        // Always use `fgets` when dealing with strings, not `scanf`.
        printf("What's your first name? ");
        in = fgets(you.first_name, MAX_DATA-1, stdin);
        strip(you.first_name);
        check(in != NULL, "Failed to read first name.");

        printf("What's your last name? ");
        in = fgets(you.last_name, MAX_DATA-1, stdin);
        strip(you.last_name);
        check(in != NULL, "Failed to read last name.");

        printf("How old are you? ");
        int rc = fscanf(stdin, "%d", &you.age);
        check(rc > 0, "You have to input a number.");

        printf("What color are your eyes:\n");
        for(i = 0; i <= OTHER; i++) {
                printf("%d) %s\n", i+1, COLOUR_NAMES[i]);
        }
        printf("> ");

        // Choose eye colour.
        int eyes = -1;
        rc = fscanf(stdin, "%d", &eyes);
        check(rc > 0, "You have to input a number.");

        you.eyes = eyes - 1;
        check(you.eyes <= OTHER && you.eyes >= BLUE, "That's not an option.");

        // Enter income.
        printf("How much do you make an hour? ");
        rc = fscanf(stdin, "%f", &you.income);
        check(rc > 0, "Enter a floating point number.");

        printf("----- RESULTS -----\n");

        printf("Hi, %s %s.\n", you.first_name, you.last_name);
        printf("Age: %d\n", you.age);
        printf("Eyes: %s\n", COLOUR_NAMES[you.eyes]);
        printf("Income: $%.2f\n", you.income);

        return EXIT_SUCCESS;
 error:

        return EXIT_FAILURE;
}
