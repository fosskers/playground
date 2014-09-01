// Prefix a variable with `_` to silence warnings about it not being used.

fn main() {
    // Immutable by default.
    let _n = 1i;

    // Evil is also allowed.
    let mut _m = 2i;

    _m += 1;

    // Can't do this!
    // _n += 1;

    // Scoping. Can create `blocks` anywhere.
    {
        let mut _o = 0i;
        _o += 1;
    }

    // Can't do this! It's out of scope.
    // o += 1;

    // --- Types --- //
    let _f: f64  = 1.0;
    let _p: int  = 1;  // Signed.
    let _q: uint = 1;  // Unsigned.

    // Rust doesn't do implicit type coercion! Yay!
    // You can do it explicitely though.
    let r: int  = 45;
    let s: uint = r as uint;

    // Only `u8` can be cast to a `char`.
    let t: char = (r as u8) as char;

    println!("{} -> {} -> {}", r, s, t);

    // Type aliases
    type MyInt = int;
    let _u: MyInt = 4;

    // Suppressing return values
    // This is easy to miss and probably stupid.
    let v: () = {
        1 + 2;
    };  // `v` will be `()`

    let w: int = {
        1 + 2
    };  // `w` will be 3

    println!("{} {}", v, w);
}
