pub struct ActivationFunction {
    function: fn(f64) -> f64,
    derivative: fn(f64) -> f64,
}
