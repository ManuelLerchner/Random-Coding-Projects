///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
Complex[][] IDENTITY={
  {new Complex(1, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(1, 0)}, 
};

///////////////////////////////////////////////////////////////////////////////////
Complex[][] NOT={
  {new Complex(0, 0), new Complex(1, 0)}, 
  {new Complex(1, 0), new Complex(0, 0)}, 
};

///////////////////////////////////////////////////////////////////////////////////
Complex[][] PAULIY={
  {new Complex(0, 0), new Complex(0, -1)}, 
  {new Complex(0, 1), new Complex(0, 0)}, 
};

///////////////////////////////////////////////////////////////////////////////////
Complex[][] PAULIZ={
  {new Complex(1, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(-1, 0)}, 
};

///////////////////////////////////////////////////////////////////////////////////
Complex[][] HADAMARD={
  {new Complex(1/sqrt(2), 0), new Complex(1/sqrt(2), 0)}, 
  {new Complex(1/sqrt(2), 0), new Complex(-1/sqrt(2), 0)}, 
};

///////////////////////////////////////////////////////////////////////////////////
Complex[][] S={
  {new Complex(1, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(0, 1)}, 
};


///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
Complex[][] CNOT={
  {new Complex(1, 0), new Complex(0, 0), new Complex(0, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(1, 0), new Complex(0, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(0, 0), new Complex(0, 0), new Complex(1, 0)}, 
  {new Complex(0, 0), new Complex(0, 0), new Complex(1, 0), new Complex(0, 0)}, 
};

///////////////////////////////////////////////////////////////////////////////////
Complex[][] CHADAMARD={
  {new Complex(1, 0), new Complex(0, 0), new Complex(0, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(1, 0), new Complex(0, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(0, 0), new Complex(1/sqrt(2), 0), new Complex(1/sqrt(2), 0)}, 
  {new Complex(0, 0), new Complex(0, 0), new Complex(1/sqrt(2), 0), new Complex(-1/sqrt(2), 0)}
};

///////////////////////////////////////////////////////////////////////////////////
Complex[][] CNOTSWAPPED={
  {new Complex(1, 0), new Complex(0, 0), new Complex(0, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(0, 0), new Complex(0, 0), new Complex(1, 0)}, 
  {new Complex(0, 0), new Complex(0, 0), new Complex(1, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(1, 0), new Complex(0, 0), new Complex(0, 0)}, 
};

///////////////////////////////////////////////////////////////////////////////////
Complex[][] SWAP={
  {new Complex(1, 0), new Complex(0, 0), new Complex(0, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(0, 0), new Complex(1, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(1, 0), new Complex(0, 0), new Complex(0, 0)}, 
  {new Complex(0, 0), new Complex(0, 0), new Complex(0, 0), new Complex(1, 0)}, 
};
