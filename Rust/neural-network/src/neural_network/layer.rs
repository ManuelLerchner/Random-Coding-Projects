use crate::activation_function;
use activation_function::activation_function::ActivationFunction;

use ndarray::{Array1, Array2};
use ndarray_rand::{rand_distr::Uniform, RandomExt};

pub struct Layer<'a> {
    pub weights: Array2<f64>,
    pub biases: Array1<f64>,
    pub activation: &'a ActivationFunction,
}

impl Layer<'_> {
    pub fn new(input_size: usize, output_size: usize, activation: &ActivationFunction) -> Layer {
        Layer {
            weights: Array2::random((output_size, input_size), Uniform::new(-1.0, 1.0)),
            biases: Array1::random(output_size, Uniform::new(-1.0, 1.0)),
            activation,
        }
    }

    pub fn predict(&self, input: Vec<f64>) -> Vec<f64> {
        let input = Array1::from(input);
        let output = self.weights.dot(&input) + &self.biases;

        output.mapv(|x| (self.activation.eval(x))).to_vec()
    }
}
