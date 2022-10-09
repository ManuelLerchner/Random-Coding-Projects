use ndarray::{arr2, Array2};
use neural_network::network::Network;

use crate::activation_function::activation_function::{RELU, SIGMOID};
use crate::cost_function::cost_function::MEAN_SQUARED_ERROR;

pub mod activation_function;
pub mod cost_function;
pub mod neural_network;

fn main() {
    let mut network: Network = Network::new(vec![4, 3, 2], 0.1, &SIGMOID, &MEAN_SQUARED_ERROR);

    let input: Array2<f64> = arr2(&[[1., 0., 1.], [1., 0., 0.], [1., 0., 1.], [1., 0., 0.]]);

    let expected: Array2<f64> = arr2(&[[1., 0., 0.5], [0., 1., 0.5]]);

    let sample_input = arr2(&[[1.], [0.], [1.], [0.]]);

    let initial_output = network.predict(&sample_input);
    println!("Initial guess: {:?}", initial_output);

    for i in 0..2000 {
        let cost = network.train(&input, &expected);

        if i % 10 == 0 {
            println!("Step: {:4} Cost: {:.8}", i, cost);
        }
    }

    let output = network.predict(&sample_input);
    println!("Trained guess: {:?}", output);
}
