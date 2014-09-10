#include "scope.h"
#include "../dbg.h"

const char* MY_NAME = "Colin";

void scope_demo(int count) {
        log_info("count is: %d", count);

        if(count > 10) {
                int count = 100;

                log_info("The inner count is: %d", count);
        }

        log_info("Now count is: %d", count);

        count = 3000;

        log_info("After reassign: %d", count);
}

int main(int argc, char** argv) {
        log_info("My name is %s and I am %d years old.", MY_NAME, get_age());

        set_age(100);

        log_info("Now I'm older! I'm %d.", get_age());

        log_info("The size is: %d", THE_SIZE);
        print_size();

        THE_SIZE = 9;

        log_info("The size is now: %d", THE_SIZE);
        print_size();

        // test the ratio function static
        log_info("Ratio: %f", *update_ratio(2.0));
        log_info("Ratio: %f", *update_ratio(10.0));
        log_info("Ratio: %f", *update_ratio(300.0));

        double* evil = update_ratio(1.0);

        // H4X. I grabbed a static function variable and am changing its
        // contents here.
        log_info("%f", *evil);
        *evil = 123.0;
        log_info("%f", *evil);
        update_ratio(9);

        // test the scope demo
        int count = 4;
        scope_demo(count);
        scope_demo(count * 20);

        log_info("count after calling scope_demo: %d", count);

        return 0;
}
