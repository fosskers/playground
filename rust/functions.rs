use deeply::nested::function;

fn main () {
    let n = 10;

    println!("sum [1 .. {}] = {}", n, sum_to(n));

    function();
}

fn sum_to(max: int) -> int {
    let mut count = 0;

    for n in range(1, max + 1) {
        count += n;
    }

    count
}

pub mod deeply {
    pub mod nested {
        pub fn function() {
            println!("Yeah!");
        }
    }
}
