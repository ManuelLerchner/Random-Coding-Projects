pub struct ActivationFunction {
    function: fn(f64) -> f64,
    derivative: fn(f64) -> f64,
}

impl ActivationFunction {
    pub fn eval(&self, x: f64) -> f64 {
        (self.function)(x)
    }

    pub fn derivative(&self, x: f64) -> f64 {
        (self.derivative)(x)
    }
}

pub static SIGMOID: ActivationFunction = ActivationFunction {
    function: (|x: f64| 1.0 / (1.0 + (-x).exp())),
    derivative: (|x: f64| x * (1.0 - x)),
};

pub static RELU: ActivationFunction = ActivationFunction {
    function: (|x: f64| x.max(0.0)),
    derivative: (|x: f64| if x > 0.0 { 1.0 } else { 0.0 }),
};
