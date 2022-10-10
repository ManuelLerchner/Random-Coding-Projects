use ndarray::prelude::*;
use ndarray::{Array, Array2};
use ndarray_rand::rand;
pub struct Dataset {
    generate: fn(usize) -> (Array2<f64>, Array2<f64>),
}

impl Dataset {
    pub fn generate(&self, size: usize) -> (Array2<f64>, Array2<f64>) {
        (self.generate)(size)
    }

    pub fn to_string(x: &Array2<f64>, y: &Array2<f64>, output: &Array2<f64>) -> String {
        let mut string = String::new();

        string.push_str(&format!(
            "Input:\n{}\nShould:\n{}\nGuess:\n{}\n\n",
            x, y, output
        ));

        string
    }
}

pub static XOR: Dataset = Dataset {
    generate: (|n: usize| {
        let mut x = Array::zeros((2, n).f());
        let mut y = Array::zeros((1, n).f());

        for i in 0..n {
            let r1 = rand::random::<f64>();
            let r2 = rand::random::<f64>();

            let r1_bool = r1 > 0.5;
            let r2_bool = r2 > 0.5;

            x[[0, i]] = r1_bool as i32 as f64;
            x[[1, i]] = r2_bool as i32 as f64;

            y[[0, i]] = (r1_bool ^ r2_bool) as i32 as f64;
        }

        (x, y)
    }),
};

pub static CIRCLE: Dataset = Dataset {
    generate: (|n: usize| {
        let mut x = Array::zeros((2, n).f());
        let mut y = Array::zeros((1, n).f());

        for i in 0..n {
            let r1 = rand::random::<f64>();
            let r2 = rand::random::<f64>();

            x[[0, i]] = r1;
            x[[1, i]] = r2;

            let dist = ((r1 - 0.5).powi(2) + (r2 - 0.5).powi(2)).sqrt();

            y[[0, i]] = if dist < 0.5 { 1.0 } else { 0.0 };
        }

        (x, y)
    }),
};

#[cfg(test)]
mod tests {

    use super::*;

    #[test]
    fn test_xor() {
        let (x, y) = (XOR.generate)(100);
        assert_eq!(2, x.shape()[0]);
        assert_eq!(100, x.shape()[1]);

        for i in 0..x.shape()[0] {
            let a = x[[0, i]];
            let b = x[[1, i]];
            let y = y[[0, i]];

            let a_bool = a > 0.5;
            let b_bool = b > 0.5;
            let y_bool = y > 0.5;

            assert_eq!(a_bool ^ b_bool, y_bool);
        }
    }
}
