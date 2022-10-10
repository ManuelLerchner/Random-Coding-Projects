pub mod activation_function;
pub mod cost_function;
pub mod data;
pub mod neural_network;

use crate::{
    activation_function::activation_function::{RELU, SIGMOID},
    cost_function::cost_function::QUADRATIC_COST,
    data::data::{Dataset, CIRCLE, XOR},
    neural_network::network::Network,
};

fn main() {
    let mut network = Network::new(vec![2, 4, 4, 1], 0.01, &RELU, &QUADRATIC_COST);

    let (x_test, y_test) = CIRCLE.generate(10);

    let output = network.predict(&x_test);

    let initial_guess = Dataset::to_string(&x_test, &y_test, &output);

    println!("{}", initial_guess);

    for i in 0..10000 {
        let (x, y) = CIRCLE.generate(2);
        network.train(&x, &y);

        if i % 100 == 0 {
            let (_, cost) = network.test(&x, &y);

            println!("Step: {:4} Cost: {:.8}", i, cost);
        }
    }

    let output = network.predict(&x_test);
    let final_guess = Dataset::to_string(&x_test, &y_test, &output);

    println!("{}", final_guess);
}
