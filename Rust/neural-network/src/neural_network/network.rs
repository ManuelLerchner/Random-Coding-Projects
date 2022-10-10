use super::layer::Layer;
use crate::{
    activation_function::activation_function::ActivationFunction,
    cost_function::cost_function::CostFunction,
};

use itertools::izip;
use ndarray::Array2;
use std::ops::Mul;

pub struct Network<'a> {
    pub layers: Vec<Layer<'a>>,
    pub shape: Vec<usize>,
    pub learning_rate: f64,
    pub cost_function: &'a CostFunction,
}

impl Network<'_> {
    pub fn new<'a>(
        shape: Vec<usize>,
        learning_rate: f64,
        activation_function: &'a ActivationFunction,
        cost_function: &'a CostFunction,
    ) -> Network<'a> {
        let mut layers = Vec::new();
        for i in 0..shape.len() - 1 {
            layers.push(Layer::new(shape[i], shape[i + 1], &activation_function));
        }
        Network {
            layers,
            shape,
            learning_rate,
            cost_function,
        }
    }

    // Predicts the output of the network given an input
    pub fn predict(&self, input: &Array2<f64>) -> Array2<f64> {
        let mut output = input.clone();
        for layer in &self.layers {
            output = layer.predict(&output);
        }
        output
    }

    // Predicts the output of the network given an input
    pub fn test(&self, input: &Array2<f64>, expected: &Array2<f64>) -> (Array2<f64>, f64) {
        let mut output = input.clone();
        for layer in &self.layers {
            output = layer.predict(&output);
        }

        let cost = self.cost_function.cost(&output, &expected);

        (output, cost)
    }

    // Trains the network given an input and the expected output
    pub fn train(&mut self, input: &Array2<f64>, expected: &Array2<f64>) {
        //Forward Pass
        let mut a = input.clone();
        let mut z_results = Vec::new();
        let mut a_results = Vec::new();
        a_results.push(a.clone());
        for layer in &self.layers {
            let z = layer.forward(&a);
            z_results.push(z.clone());
            a = layer.activation.function(&z);
            a_results.push(a.clone());
        }

        let mut partial_derivative = self.cost_function.nabla_c(&a, &expected);

        // Backward Pass
        let mut deltas = Vec::new();
        for (layer, z) in (&self.layers).iter().zip(z_results).rev() {
            let sensitivity = layer.activation.derivative(&z);

            let delta = &partial_derivative * sensitivity;
            deltas.push(delta.clone());

            partial_derivative = layer.weights.t().dot(&delta);
        }

        deltas.reverse();

        // Update Biases
        for (layer, delta) in (self.layers).iter_mut().zip(&deltas) {
            let delta = delta.mean_axis(ndarray::Axis(1)).unwrap();
            let len = delta.len();
            let deriv = &delta.into_shape((len, 1)).unwrap();

            layer.biases = &layer.biases - &deriv.mul(self.learning_rate);
        }

        // Update Weights
        for (layer, delta, a) in izip!(&mut self.layers, &deltas, &a_results) {
            let deriv = delta.dot(&a.t()) / input.shape()[1] as f64;

            layer.weights = &layer.weights - &deriv.mul(self.learning_rate);
        }
    }
}
