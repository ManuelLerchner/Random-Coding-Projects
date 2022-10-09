use ndarray::{Array1, Array2};

pub struct CostFunction {
    f: fn(&Array1<f64>, &Array1<f64>) -> f64,
    d: fn(&Array1<f64>, &Array1<f64>) -> Array1<f64>,
}

impl CostFunction {
    pub fn cost(&self, a: &Array2<f64>, expected: &Array2<f64>) -> f64 {
        let mut cost = 0.0;
        for i in 0..a.shape()[0] + 1 {
            cost += (self.f)(&a.column(i).to_owned(), &expected.column(i).to_owned());
        }
        cost / a.shape()[0] as f64
    }

    pub fn nabla_c(&self, a: &Array2<f64>, expected: &Array2<f64>) -> Array2<f64> {
        let mut cost_derivative = Array2::zeros(a.raw_dim());
        for i in 0..a.shape()[0] + 1 {
            cost_derivative.column_mut(i).assign(
                &(self.d)(&a.column(i).to_owned(), &expected.column(i).to_owned()).to_owned(),
            );
        }

        cost_derivative
    }
}

pub static MEAN_SQUARED_ERROR: CostFunction = CostFunction {
    f: (|a, expected| (a - expected).iter().fold(0.0, |acc, x| acc + x.powi(2)) / 2.0),
    d: (|a, expected| a - expected),
};
