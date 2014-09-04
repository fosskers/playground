#include <stdio.h>

int main(int argc, char *argv[]) {
        // Primatives.
        int    egral    = 1;
        long   john     = 9000000000;
        float  ing      = 1.0;
        double team     = 1.0001;
        char   mander   = 'A';
        char   izard[]  = "Do C Strings have to be hard?";  // Auto nulling?

        printf("%d %ld %f %f %c %s\n", egral, john, ing, team, mander, izard);

        // Arrays
        int   nums[]    = {1,2,3,4,5};
        char  string2[] = { 'C','o','l','i','n', '\0' };  // Manual nulling?
        //char* string3   = "This is possible too.";

        // Data type sizes. `int` seems to be 32.
        printf("Size of int: %ld\n", sizeof(int));
        printf("Size of long: %ld\n", sizeof(long));
        printf("Size of nums[]: %ld\n", sizeof(nums));
        printf("%s\n", string2);

        // Since C is evil these are totally legal.
        // At least Valgrind will whine.
        //printf("Will something appear? -> %c\n", string2[100]);
        //printf("How about now? -> %c\n", string2[-1]);

        // This is a C-String.
        //char* foo = "bar";

        // This is an array of C-Strings.
        //char* foos[] = {"bar1", "bar2", "bar3"};

        int i;

        printf("argc = %d\n", argc);

        // Playing with CL args.
        for(i = 0; i < argc; i++) {
                printf("%02d: %s\n", i, argv[i]);
        }

        return 0;
}
