#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// --- //

// Comparing with ints is asanine.
typedef enum { LT, EQ, GT } Ordering;

// Easy way to define function pointers.
typedef Ordering (*Comparison)(int a, int b);

// --- //

void die(const char* message) {
        if(errno) {
                perror(message);
        } else {
                printf("ERROR: %s\n", message);
        }

        exit(EXIT_FAILURE);
}

Ordering good_order(int a, int b) {
        if(a > b) {
                return GT;
        } else if(a == b) {
                return EQ;
        } else {
                return LT;
        }
}

Ordering reverse_order(int a, int b) {
        if(a < b) {
                return GT;
        } else if(a == b) {
                return EQ;
        } else {
                return LT;
        }
}

Ordering mod_order(int a, int b) {
        if(b == 0 || a % b == 0) {
                return GT;
        } else {
                return LT;
        }
}

int* sort(const int* nums, int len, Comparison cmp) {
        int  temp   = 0;
        int  i      = 0;
        int  j      = 0;
        int* target = malloc(len * sizeof(int));

        if(!target) { die("Memory error."); }

        memcpy(target, nums, len * sizeof(int));

        for(i = 0; i < len; i++) {
                for(j = 0; j < len - 1; j++) {
                        if(cmp(target[j], target[j+1]) == GT) {
                                temp = target[j+1];
                                target[j+1] = target[j];
                                target[j] = temp;
                        }
                }
        }

        return target;
}

void test_sort(int* nums, int len, Comparison cmp) {
        int* result = sort(nums, len, cmp);
        int i;

        printf("[");

        for(i = 0; i < len-1; i++) {
                printf("%d, ", result[i]);
        }

        printf("%d]\n", result[len-1]);

        free(result);

        unsigned char* data = (unsigned char*)cmp;

        for(i = 0; i < 20; i++) {
                printf("%02x:", data[i]);
        }

        printf("\n");
}

int main(int argc, char** argv) {
        if(argc < 2) { die("Too few arguments."); }

        int* nums = malloc((argc - 1) * sizeof(int));
        if(!nums) { die("Memory error"); }

        int i;
        for(i = 0; i < argc - 1; i++) {
                nums[i] = atoi(argv[i+1]);
        }

        test_sort(nums, argc - 1, good_order);
        test_sort(nums, argc - 1, reverse_order);
        test_sort(nums, argc - 1, mod_order);

        free(nums);

        return 0;
}
