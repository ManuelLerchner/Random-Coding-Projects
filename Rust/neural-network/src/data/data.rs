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
        let mut x = Array::zeros((n, 2).f());
        let mut y = Array::zeros((n, 1).f());

        for i in 0..n {
            let r1 = rand::random::<f64>();
            let r2 = rand::random::<f64>();

            let r1_bool = r1 > 0.5;
            let r2_bool = r2 > 0.5;

            x[[i, 0]] = r1_bool as i32 as f64;
            x[[i, 1]] = r2_bool as i32 as f64;

            y[[i, 0]] = (r1_bool ^ r2_bool) as i32 as f64;
        }

        (x, y)
    }),
};

pub static CIRCLE: Dataset = Dataset {
    generate: (|n: usize| {
        let mut x = Array::zeros((n, 2).f());
        let mut y = Array::zeros((n, 1).f());

        for i in 0..n {
            let r1 = rand::random::<f64>();
            let r2 = rand::random::<f64>();

            x[[i, 0]] = r1;
            x[[i, 1]] = r2;

            y[[i, 0]] = (r1 * r1 + r2 * r2 < 0.7 * 0.7) as i32 as f64;
        }

        (x, y)
    }),
};

pub static ADD: Dataset = Dataset {
    generate: (|n: usize| {
        let mut x = Array::zeros((n, 2).f());
        let mut y = Array::zeros((n, 1).f());

        for i in 0..n {
            let r1 = rand::random::<f64>();
            let r2 = rand::random::<f64>();

            x[[i, 0]] = r1;
            x[[i, 1]] = r2;

            y[[i, 0]] = r1 + 0.5*r2;
        }

        (x, y)
    }),
};

#[cfg(test)]
mod tests {

    use super::*;

    #[test]
    fn test_xor() {
        let (x, y) = XOR.generate(10);
        assert_eq!(x.shape(), &[10, 2]);

        for i in 0..10 {
            let a = x[[i, 0]];
            let b = x[[i, 1]];
            let y = y[[i, 0]];

            let a_bool = a > 0.5;
            let b_bool = b > 0.5;
            let y_bool = y > 0.5;

            assert_eq!(a_bool ^ b_bool, y_bool);
        }
    }
}
