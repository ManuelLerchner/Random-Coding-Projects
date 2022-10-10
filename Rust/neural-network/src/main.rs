pub mod activation_function;
pub mod cost_function;
pub mod data;
pub mod neural_network;

#[allow(unused_imports)]
use crate::{
    activation_function::activation_function::{ID, RELU, SIGMOID},
    cost_function::cost_function::QUADRATIC_COST,
    data::data::{Dataset, ADD, CIRCLE, XOR},
    neural_network::network::Network,
};

fn main() {
    let mut network = Network::new(vec![2, 32, 32, 1], 0.2, &RELU, &QUADRATIC_COST);

    let (x_test, y_test) = CIRCLE.generate(1000);

    for _ in 0..1000 {
        let data_train = CIRCLE.generate(8);
        let cost = network.train(&data_train);
        println!("cost: {}", cost);
    }

    let pred = network.predict(&x_test);
    let cost = network.cost_function.cost(&pred, &y_test);

    println!("guess {:?}", pred);
    println!("cost: {}", cost);
    println!("actual {:?}", (pred - y_test).mapv(|x| x.abs()).sum());
}
