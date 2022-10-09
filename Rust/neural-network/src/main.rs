pub mod activation_function;
pub mod cost_function;
pub mod neural_network;

use ndarray::{arr2, Array2};

use crate::{
    activation_function::activation_function::SIGMOID,
    cost_function::cost_function::MEAN_SQUARED_ERROR, neural_network::network::Network,
};

fn main() {
    let mut network = Network::new(vec![4, 4, 2], 0.2, &SIGMOID, &MEAN_SQUARED_ERROR);

    let input: Array2<f64> = arr2(&[[1., 0., 1.], [1., 0., 0.], [1., 0., 1.], [1., 0., 0.]]);
    let expected: Array2<f64> = arr2(&[[0.7, 0., 0.5], [0., 1., 0.5]]);

    let initial_output = network.predict(&input);
    println!("Initial guess: {:?}", initial_output);

    for i in 0..2000 {
        network.train(&input, &expected);

        if i % 100 == 0 {
            let output = network.predict(&input);
            let cost = network.cost_function.cost(&output, &expected);

            println!("Step: {:4} Cost: {:.8}", i, cost);
        }
    }

    let output = network.predict(&input);
    println!("Trained guess: {:?}", output);
}
