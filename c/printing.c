#include <stdio.h>

int main(int argc, char *argv[]) {
        // Adds the `\n` for you.
        puts("Hello world!");

        // Lots of languages have a C-inspired `printf` now.
        printf("I have %d cat.\n", 1);

        // Pad with spaces.
        printf("I have %2d cat.\n", 1);

        // Pad with zeroes.
        printf("I have %02d cat.\n", 1);

        // Set the desired decimal places.
        printf("I have %.2f cat.\n", 1.0);

        // Put variables in there too.
        int age = 26;
        printf("I was %d when I made this.\n", age);

        // Compiler warns you about this.
        //printf("");

        return 0;
}
