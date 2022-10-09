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

    pub fn predict(&self, input: &Array2<f64>) -> Array2<f64> {
        let mut output = input.clone();
        for layer in &self.layers {
            output = layer.predict(&output);
        }
        output
    }

    pub fn train(&mut self, input: &Array2<f64>, expected: &Array2<f64>) -> f64 {
        let batch_size = input.shape()[1];

        //Collect Forward Pass Data
        let mut a = input.clone();
        let mut z_results = Vec::new();
        let mut a_results = Vec::new();
        for layer in &self.layers {
            let z = layer.forward(&a);
            a_results.push(a.clone());
            z_results.push(z.clone());
            a = layer.activation.function(&z);
        }

        let mut deltas = Vec::new();

        let mut partial_derivative = self.cost_function.nabla_c(&a, &expected);
        let cost = self.cost_function.cost(&a, &expected);

        for (layer, z) in (&self.layers).iter().zip(z_results).rev() {
            let sensitivity = layer.activation.derivative(&z);

            let delta = &partial_derivative * sensitivity;
            deltas.push(delta.clone());

            partial_derivative = layer.weights.t().dot(&delta);
        }

        deltas.reverse();

        for (layer, delta) in (self.layers).iter_mut().zip(&deltas) {
            let delta_average = delta.mean_axis(ndarray::Axis(1)).unwrap();

            let len = delta_average.len();
            let delta_average_mat = &delta_average.into_shape((len, 1)).unwrap();

            layer.biases = &layer.biases - &delta_average_mat.mul(self.learning_rate);
        }

        for (layer, delta, a) in izip!(&mut self.layers, &deltas, &a_results) {
            let t = delta.dot(&a.t());

            layer.weights = &layer.weights - &t.mul(self.learning_rate / batch_size as f64);
        }

        cost
    }
}
