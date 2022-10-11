use std::fs::File;
use std::io::BufWriter;
use std::path::Path;

use ndarray::Array1;

pub fn plot_png(name: &str, dims: (usize, usize), data: &Array1<f64>, color_type: png::ColorType) {
    let path = Path::new("images").join(name);

    if let Some(parent) = path.parent() {
        std::fs::create_dir_all(parent).unwrap();
    }

    let file = File::create(&path).unwrap();
    let ref mut w = BufWriter::new(file);

    let width = dims.0.try_into().unwrap();
    let height = dims.1.try_into().unwrap();

    let mut encoder = png::Encoder::new(w, width, height);
    encoder.set_color(color_type);

    let mut writer = encoder.write_header().unwrap();

    let mut data = data.to_vec();

    let data_uint8: Vec<u8> = data
        .iter_mut()
        .map(|x| {
            *x = (*x * 255.0).min(255.0).max(0.0);
            *x as u8
        })
        .collect();

    writer.write_image_data(&data_uint8).unwrap();
}
