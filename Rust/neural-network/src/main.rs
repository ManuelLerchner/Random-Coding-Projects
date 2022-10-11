pub mod activation_function;
pub mod cost_function;
pub mod data;
pub mod neural_network;
pub mod plot;

use plot::plot;

#[allow(unused_imports)]
use crate::{
    activation_function::activation_function::{ID, RELU, SIGMOID},
    cost_function::cost_function::QUADRATIC_COST,
    data::data::{Dataset, CIRCLE, XOR},
    neural_network::network::Network,
};

fn main() {
    let mut network = Network::new(vec![2, 16, 16, 16, 16, 1], 0.2, &RELU, &QUADRATIC_COST);

    for _ in 0..1000 {
        let data_train = XOR.get_batch(16);
        let cost = network.train(&data_train);
        println!("cost: {}", cost);
    }

    let resolution: usize = 100;
    let unit_square = Dataset::get_2d_unit_square(resolution);
    let pred = network.predict(&unit_square);

    let pred_flat = pred
        .to_shape(resolution * resolution)
        .expect("reshape failed")
        .to_owned();

    plot(
        "xor.png",
        (resolution, resolution),
        &pred_flat,
        png::ColorType::Grayscale,
    );
}
