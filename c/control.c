// Control Structures

#include <stdio.h>

int main(int argc, char* argv[]) {
        if(argc > 1) {
                puts("No args allowed!");

                // Abort.
                return 1;
        }

        int i;

        printf("argc = %d\n", argc);

        // Playing with CL args.
        for(i = 0; i < argc; i++) {
                printf("%02d: %s\n", i, argv[i]);
        }

        if(5 < 2) {
                puts("Foo");
        } else if(3 < 1) {
                puts("Bar");
        } else {
                puts("Woo!");
        }

        char* cats = "Kittens";

        // The result of what you pass `switch` has to result to an int.
        // Likewise, the values matched in cases must also be ints
        // (implicitely or otherwise).
        switch(cats[0]) {
        case 'P':
                puts("Puppies");
                break;

        case 'K':
                puts("Kitties!");
                break;

        default:
                puts("Couldn't find kitties.");
        }

        return 0;
}
