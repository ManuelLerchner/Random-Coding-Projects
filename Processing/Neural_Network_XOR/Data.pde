class Data { 
  float [] inputs;
  float [] outputs;
  int output;

  Data() {
    inputs = new float [nnDim[0]];
    outputs = new float[nnDim[nnDim.length-1]];
  }

  void LoadData() { 
    for (int i = 0; i < inputs.length; i++) {
      inputs[i] = round(random(0, 1));
    }

    int a=round(inputs[0]);
    int b=round(inputs[1]);

    for (int i = 0; i < outputs.length; i++) { 
      if ((!boolean(a)&&boolean(b))||(boolean(a)&&!boolean(b) )) {
        outputs[i] = 1.0;
      } else {
        outputs[i] = -1;
      }
    }
  }
}
