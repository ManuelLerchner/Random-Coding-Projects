use crate::activation_function::activation_function::ActivationFunction;

use super::layer::Layer;

pub struct Network<'a> {
    pub layers: Vec<Layer<'a>>,
    pub shape: Vec<usize>,
    pub learning_rate: f64,
}

impl Network<'_> {
    pub fn new(
        shape: Vec<usize>,
        learning_rate: f64,
        activation_function: &ActivationFunction,
    ) -> Network {
        let mut layers = Vec::new();
        for i in 0..shape.len() - 1 {
            layers.push(Layer::new(shape[i], shape[i + 1], &activation_function));
        }
        Network {
            layers,
            shape,
            learning_rate,
        }
    }

    pub fn predict(&self, input: Vec<f64>) -> Vec<f64> {
        let mut output = input;
        for layer in &self.layers {
            output = layer.predict(output);
        }
        output
    }
}
