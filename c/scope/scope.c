#include <stdio.h>
#include "../dbg.h"
#include "scope.h"

int THE_SIZE = 1337;

static int THE_AGE = 26;

int get_age() {
        return THE_AGE;
}

void set_age(int age) {
        THE_AGE = age;
}

double* update_ratio(double new_ratio) {
        // This is generally bad to do.
        static double ratio = 1.0;
        
        log_info("Old ratio: %f", ratio);
        
        ratio = new_ratio;

        return &ratio;
}

void print_size() {
        log_info("The size is surely: %d", THE_SIZE);
}

