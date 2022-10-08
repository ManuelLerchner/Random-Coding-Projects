use ndarray::{arr2, Array2};
use neural_network::network::Network;

use crate::activation_function::activation_function::SIGMOID;

pub mod activation_function;
pub mod neural_network;

fn main() {
    let network = Network::new(vec![4, 3, 2], 0.1, &SIGMOID);

    let input: Array2<f64> = arr2(&[[4., 5., 6.], [1., 2., 3.], [7., 8., 9.], [10., 11., 12.]]);

    let res = network.predict(input);

    println!("{:?}", res);
}
