#include <stdio.h>
#include <stdlib.h>
#include "Cello.h"

void hr() {
        println("\n---");
}

int main(int argc, char** argv) {
        println("Cello World!");

        /* Arrays */
        var a = new(Array, Int);
        push(a, $(Int, 32));
        push(a, $(Int, 6));
        show(a);
        delete(a);

        hr();
        
        /* Lists */
        var i0 = new(Int, $(Int, 21));
        var i1 = new(String, $(String, "Hello"));
        var b = new(List);
        push(b,i0);
        push(b,i1);
        show(b);
        delete(b);
        delete(i0);
        delete(i1);

        hr();
        
        /* Named Lambdas */
        lambda(foo, args) {
                var name = cast(at(args,0), String);
                println("Hello %s!", name);

                // Has to return.
                return None;
        }

        call(foo, $(String, "Colin"));

        /* Higher order functions */
        var names = new(List,
                        $(String,"Jack"),
                        $(String,"Tinsel"),
                        $(String,"Shamrock"));
        map(names, foo);
        delete(names);

        // Works on Arrays too.
        var names2 = new(Array, String,
                         $(String,"Oh"),
                         $(String,"Hi"),
                         $(String,"Does this work?"));
        map(names2, foo);
        delete(names2);

        /* Partially applied functions */
        lambda(add, args) {
                int fst = as_long(cast(at(args,0), Int));
                int snd = as_long(cast(at(args,1), Int));

                println("%i", $(Int, fst + snd));
                //return $(Int, fst + snd);
                return None;
        }
        call(add, $(Int,1), $(Int,2));

        lambda_partial(add_p, add, $(Int,8));
        call(add_p, $(Int,1));

        // Can use `lambda_uncurry` to uncurry real functions.

        return EXIT_SUCCESS;
}
