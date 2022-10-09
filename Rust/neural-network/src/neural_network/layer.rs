use crate::activation_function;
use activation_function::activation_function::ActivationFunction;

use ndarray::Array2;
use ndarray_rand::{rand_distr::Uniform, RandomExt};

pub struct Layer<'a> {
    pub weights: Array2<f64>,
    pub biases: Array2<f64>,
    pub activation: &'a ActivationFunction,
}

impl Layer<'_> {
    pub fn new(input_size: usize, output_size: usize, activation: &ActivationFunction) -> Layer {
        Layer {
            weights: Array2::random((output_size, input_size), Uniform::new(-1.0, 1.0)),
            biases: Array2::random((output_size, 1), Uniform::new(-1.0, 1.0)),
            activation,
        }
    }

    pub fn predict(&self, input: &Array2<f64>) -> Array2<f64> {
        self.activation.function(&self.forward(input))
    }

    pub fn forward(&self, input: &Array2<f64>) -> Array2<f64> {
        self.weights.dot(input) + &self.biases
    }
}
