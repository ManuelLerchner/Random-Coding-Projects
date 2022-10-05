use rand::Rng;
use std::{cmp::Ordering, io};
fn main() {
    println!("Guess the number!");

    let secret_number= rand::thread_rng().gen_range(1..=100);

    let mut tries = 0;
    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess).expect("Error");

        println!("You guessed: {}", guess);

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("Please enter a number");
                continue;
            }
        };

        match guess.cmp(&secret_number) {
            Ordering::Less => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal => {
                println!("You win!");
                break;
            }
        }
        tries += 1;
    }

    println!("You found the correct number in {} tries!", tries);
}
