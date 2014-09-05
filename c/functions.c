#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>
#include <string.h>

// --- //

bool printable(char c);
void printLetters(int len, char* arg);
void printArgs(int argc, char** argv);

// --- //

bool printable(char c) {
        return isalpha(c) || isblank(c);
}

void printLetters(int len, char* arg) {
        int i;

        for(i = 0; i < len; i++) {
                char c = arg[i];

                if(printable(c)) {
                        printf("%c == %d\n", c, c);
                }
        }

        printf("\n");
}

void printArgs(int argc, char** argv) {
        int i;

        puts("Printing args:");

        for(i = 0; i < argc; i++) {
                printLetters(strlen(argv[i]), argv[i]);
        }

        puts("Done printing.");
}

int main(int argc, char** argv) {
        printArgs(argc, argv);

        return 0;
}
