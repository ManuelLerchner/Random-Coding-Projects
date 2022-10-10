use crate::activation_function;

use activation_function::activation_function::ActivationFunction;
use ndarray::Array2;
use ndarray_rand::{rand_distr::Normal, RandomExt};

pub struct Layer<'a> {
    pub weights: Array2<f64>,
    pub biases: Array2<f64>,
    pub activation: &'a ActivationFunction,
}

impl Layer<'_> {
    pub fn new(input_size: usize, output_size: usize, activation: &ActivationFunction) -> Layer {
        let weights = Array2::random((output_size, input_size), Normal::new(0.0, 1.0).unwrap())
            / (input_size as f64).sqrt();
        let biases = Array2::random((output_size, 1), Normal::new(0.0, 1.0).unwrap());
        Layer {
            weights: weights,
            biases: biases,
            activation,
        }
    }

    // Predicts the output of the layer given an input
    pub fn predict(&self, input: &Array2<f64>) -> Array2<f64> {
        self.activation.function(&self.forward(input))
    }

    // Calculates the weighted sum of the input
    pub fn forward(&self, input: &Array2<f64>) -> Array2<f64> {
        self.weights.dot(input) + &self.biases
    }
}

#[cfg(test)]
mod tests {
    use ndarray::arr2;

    use crate::activation_function::activation_function::SIGMOID;

    use super::*;

    #[test]
    fn test_forward() {
        let mut layer = Layer::new(2, 2, &SIGMOID);
        layer.weights = arr2(&[[1., 2.], [-1., 1.]]);
        layer.biases = arr2(&[[1.], [1.]]);

        let input = arr2(&[[1.], [2.]]);
        let expected = arr2(&[[6.], [2.]]);

        let output = layer.forward(&input);

        assert_eq!(output, expected);
    }

    #[test]
    fn test_predict() {
        let mut layer = Layer::new(2, 2, &SIGMOID);
        layer.weights = arr2(&[[-1., 1.], [234., 1.]]);
        layer.biases = arr2(&[[1.], [1.]]);

        let input = arr2(&[[1.], [2.]]);
        let expected = arr2(&[[0.8807970779778823], [1.]]);

        let output = layer.predict(&input);

        assert_eq!(output, expected);
    }
}
