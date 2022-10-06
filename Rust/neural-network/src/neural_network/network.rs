use super::layer::Layer;

pub struct Network {
    pub layers: Vec<Layer>,
    pub shape: Vec<usize>,
    pub learning_rate: f64,
}
