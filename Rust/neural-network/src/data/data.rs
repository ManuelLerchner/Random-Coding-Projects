use ndarray::prelude::*;
use ndarray::{Array, Array2};
use ndarray_rand::{rand, RandomExt};

pub enum DatasetType {
    Static(fn() -> (Array2<f64>, Array2<f64>)),
    Dynamic(fn(Array1<f64>) -> Array1<f64>, usize),
}

pub struct Dataset {
    pub dataset_type: DatasetType,
}

impl Dataset {
    pub fn new(dataset_type: DatasetType) -> Dataset {
        Dataset { dataset_type }
    }

    pub fn get_full(&self) -> (Array2<f64>, Array2<f64>) {
        match &self.dataset_type {
            DatasetType::Static(f) => f(),
            _ => panic!("Cannot get full dataset from dynamic dataset"),
        }
    }

    pub fn get_2d_unit_square(resolution: usize) -> Array2<f64> {
        let linspace = Array::linspace(0.0, 1.0, resolution);

        let mut x = Array::zeros((resolution * resolution, 2).f());
        for i in 0..resolution {
            for j in 0..resolution {
                x[[i * resolution + j, 0]] = linspace[i];
                x[[i * resolution + j, 1]] = linspace[j];
            }
        }

        x
    }

    pub fn get_batch(&self, batch_size: usize) -> (Array2<f64>, Array2<f64>) {
        match &self.dataset_type {
            DatasetType::Static(f) => {
                let (data, labels) = f();

                let indices = Array1::random(
                    batch_size,
                    rand::distributions::Uniform::new(0, data.shape()[0]),
                )
                .to_vec();

                let data = data.select(Axis(0), &indices);
                let labels = labels.select(Axis(0), &indices);

                (data, labels)
            }
            DatasetType::Dynamic(f, dim) => {
                let x = Array::random(
                    (batch_size, *dim),
                    rand::distributions::Uniform::new(0.0, 1.0),
                );

                let mut y = Array2::zeros((batch_size, 1));
                for (i, xi) in x.outer_iter().enumerate() {
                    let yi = f(xi.to_owned());
                    y.slice_mut(s![i, ..]).assign(&yi);
                }

                (x, y)
            }
        }
    }
}

pub static XOR: Dataset = Dataset {
    dataset_type: DatasetType::Static(|| {
        let x = array![[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]];
        let y = array![[0.0], [1.0], [1.0], [0.0]];
        (x, y)
    }),
};

pub static CIRCLE: Dataset = Dataset {
    dataset_type: DatasetType::Dynamic(
        |x| {
            let dist_from_center = ((x[0] - 0.5).powi(2) + (x[1] - 0.5).powi(2)).sqrt();
            let y = if dist_from_center < 0.25 { 1.0 } else { 0.0 };
            array![y]
        },
        2,
    ),
};
