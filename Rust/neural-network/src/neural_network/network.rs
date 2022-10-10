use super::layer::Layer;
use crate::{
    activation_function::activation_function::ActivationFunction,
    cost_function::cost_function::CostFunction,
};

use itertools::izip;
use ndarray::Array2;

pub struct Network<'a> {
    pub layers: Vec<Layer<'a>>,
    pub shape: Vec<usize>,
    pub eta: f64,
    pub cost_function: &'a CostFunction,
}

impl Network<'_> {
    pub fn new<'a>(
        shape: Vec<usize>,
        eta: f64,
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
            eta,
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

    // Calculates the needed adjustments to the weights and biases for a given input and expected output
    pub fn backprop(
        &self,
        x: &Array2<f64>,
        y: &Array2<f64>,
    ) -> (Vec<Array2<f64>>, Vec<Array2<f64>>) {
        let mut nabla_b = Vec::new();
        let mut nabla_w = Vec::new();

        // Forward pass
        let mut activation = x.clone();
        let mut activations = vec![activation.clone()];
        let mut zs = Vec::new();
        for layer in &self.layers {
            let z = layer.forward(&activation);
            zs.push(z.clone());
            activation = layer.activation.function(&z);
            activations.push(activation.clone());
        }

        // Calculate the cost
        let nabla_c = self.cost_function.cost_derivative(&activation, &y);

        // Calculate sensitivity
        let sig_prime = self.layers[self.layers.len() - 1]
            .activation
            .derivative(&zs[zs.len() - 1]);

        // Calculate delta for last layer
        let mut delta = nabla_c * sig_prime;

        // Calculate nabla_b and nabla_w for last layer
        nabla_b.push(delta.clone());
        nabla_w.push((&activations[activations.len() - 2]).t().dot(&delta));

        // Loop backwards through the layers, calculating delta, nabla_b and nabla_w
        for i in 2..self.shape.len() {
            let sig_prime = self.layers[self.layers.len() - i]
                .activation
                .derivative(&zs[zs.len() - i]);

            let nabla_c = &delta.dot(&self.layers[self.layers.len() - i + 1].weights.t());

            delta = nabla_c * sig_prime;

            nabla_b.push(delta.clone());
            nabla_w.push((&activations[activations.len() - i - 1].t()).dot(&delta));
        }

        nabla_b.reverse();
        nabla_w.reverse();

        (nabla_b, nabla_w)
    }

    // Trains the network given an input and the expected output
    pub fn train(&mut self, (x, y): &(Array2<f64>, Array2<f64>)) -> f64 {
        let (nabla_b, nabla_w) = self.backprop(x, y);

        let batch_size = x.nrows() as f64;

        for (layer, nabla_b, nabla_w) in izip!(&mut self.layers, nabla_b, nabla_w) {
            let nabla_b_average = &nabla_b
                .mean_axis(ndarray::Axis(0))
                .unwrap()
                .into_shape((1, nabla_b.ncols()))
                .unwrap();

            layer.weights = &layer.weights - (self.eta / batch_size) * nabla_w;
            layer.biases = &layer.biases - (self.eta / batch_size) * nabla_b_average;
        }

        let cost = self.cost_function.cost(&self.predict(x), y);
        cost
    }
}
