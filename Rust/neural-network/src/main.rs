use ndarray::{arr2, Array2};
use neural_network::network::Network;

use crate::activation_function::activation_function::SIGMOID;

pub mod activation_function;
pub mod neural_network;

fn main() {
    let mut network: Network = Network::new(vec![4, 3, 2], 0.1, &SIGMOID);

    let input: Array2<f64> = arr2(&[[1., 0., 1.], [1., 0., 0.], [1., 0., 1.], [1., 0., 0.]]);

    let expected: Array2<f64> = arr2(&[[1., 0., 0.5], [0., 1., 0.5]]);

    let sample_input = arr2(&[[1.], [1.], [1.], [1.]]);

    let initial_output = network.predict(&sample_input);
    println!("Initial guess: {:?}", initial_output);

    for _ in 0..6 {
        network.train(&input, &expected);
    }

    let output = network.predict(&sample_input);
    println!("Trained guess: {:?}", output);
}
