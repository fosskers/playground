// Control structures

fn main() {
    let n: int = 5;

    if n > 0 {
        println!("It's positive!");
    } else if n < 0 {
        println!("No wait, it's negative.");
    } else {
        println!("It's 0.");
    }

    // An infinite loop.
    loop {
        break
    }

    // Nested loop breaking with labelling.
    'outer: loop {
        loop {
            loop {
                break 'outer;
            }
        }
    }

    println!("Got out of the loop!");

    let mut count: int = 0;

    for m in range(1i, 10) {
        count += m;
    }

    println!("Sum is: {}", count);
}
