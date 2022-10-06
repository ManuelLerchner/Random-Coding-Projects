use neural_network::network::Network;

use crate::activation_function::activation_function::SIGMOID;

pub mod activation_function;
pub mod neural_network;

fn main() {
    let network = Network::new(vec![4, 3, 2], 0.1, &SIGMOID);

    let input = vec![1.0, 2.0, 2.0, 4.0];

    let _expected_output = vec![0.0, 1.0];

    let res = network.predict(input);

    println!("{:?}", res);
}
