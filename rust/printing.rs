// Comments
fn main() {
    println!("Hello Rust!");

    // String formatting.
    println!("I am {} years old.", 26i);

    // Numbers in placeholders.
    println!("You are {0} and I am {1}. Where are you {0}?", "Jack", "Colin");

    // Naming the placeholders.
    println!("I am very {emotion}!", emotion="happy");

    // Format codes.
    println!("{:i} is {:x} in hex.", 9206i, 9206i);

    // Underscores for readability.
    println!("Look how readble {} is!", 100_000_000i);
}
