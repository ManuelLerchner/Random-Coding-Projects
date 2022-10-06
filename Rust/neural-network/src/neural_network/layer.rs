use activation_function::activation_function::ActivationFunction;

use crate::activation_function;

pub struct Layer {
    pub weights: Vec<Vec<f64>>,
    pub biases: Vec<f64>,
    pub activation: ActivationFunction,
}
