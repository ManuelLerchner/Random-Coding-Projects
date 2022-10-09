use ndarray::Array;

pub struct ActivationFunction {
    pub f: fn(f64) -> f64,
    pub d: fn(f64) -> f64,
}

impl ActivationFunction {
    pub fn function<D>(&self, x: &Array<f64, D>) -> Array<f64, D>
    where
        D: ndarray::Dimension,
    {
        x.mapv(self.f)
    }

    pub fn derivative<D>(&self, x: &Array<f64, D>) -> Array<f64, D>
    where
        D: ndarray::Dimension,
    {
        x.mapv(self.d)
    }
}

pub static SIGMOID: ActivationFunction = ActivationFunction {
    f: (|x: f64| {
        if x < -45.0 {
            0.0
        } else if x > 45.0 {
            1.0
        } else {
            1.0 / (1.0 + (-x).exp())
        }
    }),
    d: (|x: f64| {
        if x < -45.0 {
            0.0
        } else if x > 45.0 {
            0.0
        } else {
            let y = 1.0 / (1.0 + (-x).exp());
            y * (1.0 - y)
        }
    }),
};

pub static RELU: ActivationFunction = ActivationFunction {
    f: (|x: f64| x.max(0.0)),
    d: (|x: f64| if x > 0.0 { 1.0 } else { 0.0 }),
};
