import com.bestcode.mathparser.*;
import com.bestcode.util.*;

IMathParser parser;

//////////////////////////////////////////////////////////////////////////////
void setupParser() {
  parser = MathParserFactory.create();
  parser.setOptimizationOn(true);
  parser.setExpression(input);
  try {
    parser.createVar("E", Math.E);
    parser.createFunc("asin", new asin()); 
    parser.createFunc("acos", new acos()); 
    parser.createFunc("fak", new fak());
    parser.createFunc("gamma", new gamma());
    parser.createFunc("rootN", new rootN());
    parser.createFunc("Simpson", new Simpson());
    parser.createFunc("f", new f());
    parser.createFunc("monteCarlo", new monteCarlo());
  }
  catch(Exception ex) {
  }
  println("Available Functions:"); 
  for (String s : parser.getFunctions()) {
    print(s+" ");
  }
}

//////////////////////////////////////////////////////////////////////////////
double y(double x) {
  if (!input.equals("")) {
    try {
      parser.setX(x);
      return parser.getValue();
    }
    catch(Exception ex) {
      println(ex);
    }
  }
  return Double.NaN;
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//Custom functions
public class asin extends OneParamFunc {
  public double run(IParameter[] p) {
    return Math.asin(p[0].getValue());
  }
}
public class acos extends OneParamFunc {
  public double run(IParameter[] p) {
    return Math.acos(p[0].getValue());
  }
}
public class gamma extends OneParamFunc {
  public double run(IParameter[] p) {
    return gamma(p[0].getValue());
  }
}
public class fak extends OneParamFunc {
  public double run(IParameter[] p) {
    return fak(p[0].getValue());
  }
}
public class rootN extends TwoParamFunc {
  public double run(IParameter[] p) {
    return Math.exp(Math.log(p[0].getValue())/p[1].getValue());
  }
}
public class f extends TwoParamFunc {
  public double run(IParameter[] p) {
    double x=p[0].getValue();
    int n=(int)p[1].getValue();
    return f(x, n);
  }
}

//Integration from Simpson(a,b,precision,#Predifined Function)
public class Simpson implements IFunction {
  public double run(IParameter[] p) {
    int pre=(int)p[2].getValue();
    int n=(int)p[3].getValue();
    double step = (p[1].getValue()-p[0].getValue())/pre;
    double val=0;
    for (int i=0; i < pre; i++) {
      double a=p[0].getValue()+i*step;
      double b=a+step;
      double add = (b-a)/6*(f(a, n)+4*(f((a+b)/2, n))+f(b, n));
      if (Double.isFinite(add)) {
        val += add;
      }
    }
    return val;
  }
  int getNumberOfParams() {
    return 4;
  }
}

//Integration from Montecarlo(a,b,precision,#Predifined Function)
public class monteCarlo implements IFunction {
  public double run(IParameter[] p) {
    float xMin=(float)p[0].getValue();
    float xMax=(float)p[1].getValue();
    int pre=(int)p[2].getValue();
    int n=(int)p[3].getValue();
    double sum=0;
    for (int i=0; i < pre; i++) {
      double rx = xMin+random(1)*(xMax-xMin);
      double yx = f(rx, n);
      sum+=yx*(xMax-xMin);
    }
    return sum/pre;
  }
  int getNumberOfParams() {
    return 4;
  }
}


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
double fak(double x) {
  //stirling aproximation
  return Math.sqrt(2*Math.PI*x)*Math.pow(x/Math.E, x);
}

//////////////////////////////////////////////////////////////////////////////
double gamma(double x) {
  double[] p = {0.99999999999980993, 676.5203681218851, -1259.1392167224028, 
    771.32342877765313, -176.61502916214059, 12.507343278686905, 
    -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7
  };
  double g = 7;
  if (x < 0.5) {
    return Math.PI / (Math.sin(Math.PI * x) * gamma(1 - x));
  }
  x -= 1;
  double a = p[0];
  double t = x + g + 0.5;
  for (int i = 1; i < p.length; i++) {
    a += p[i] / (x + i);
  }
  return Math.sqrt(2 * Math.PI) * Math.pow(t, x + 0.5) * Math.exp(-t) * a;
}
