interface Node {

  String toString();
}

class NumberNode implements Node {
  Token numberToken;
  NumberNode(Token numberToken) {
    this.numberToken=numberToken;
  }

  String toString() {
    return numberToken.toString();
  }
}


class BinOpNode implements Node {
  Node left;
  Node right;
  Token operatorToken;

  BinOpNode(Node left, Token operatorToken, Node right) {
    this.left=left;
    this.right=right;
    this.operatorToken=operatorToken;
  }

  String toString() {
    return "(" +left+ ", " +operatorToken +", "+right +")";
  }
}

class UnaryOpNode implements Node {
  Node Node;
  Token operatorToken;

  UnaryOpNode( Token operatorToken, Node node) {
    this.Node=node;
    this.operatorToken=operatorToken;
  }

  String toString() {
    return "("+operatorToken +", "+Node+")";
  }
}


class VarAssignNode implements Node {

  Token varNameToken;
  Node valueNode;

  VarAssignNode( Token varNameToken, Node valueNode) {
    this.valueNode=valueNode;
    this.varNameToken=varNameToken;
  }

  String toString() {
    return "("+varNameToken +", "+valueNode+")";
  }
}


class VarAccessNode implements Node {
  Token varNameToken;

  VarAccessNode(Token varNameToken) {
    this.varNameToken=varNameToken;
  }

  String toString() {
    return ""+varNameToken;
  }
}

class ifNode implements Node {
  List<if_Case> cases;
  Node elseCase;

  ifNode(List<if_Case> cases, Node elseCase) {
    this.cases=cases;
    this.elseCase=elseCase;
  }

  String toString() {
    String out="[";
    for (if_Case I : cases) {
      out+="( "+I.cond+", " +I.expr +")  ;  ";
    }
    out+="] " + elseCase; 
    return out;
  }
}


class forNode implements Node {

  Token varNameTok;
  Node startValue;
  Node endValue;
  Node bodyNode;

  Node stepValueNode;

  forNode(Token varNameTok, Node startValue, Node endValue, Node bodyNode) {
    this. varNameTok=varNameTok;
    this. startValue=startValue;
    this. endValue=endValue;
    this.bodyNode=bodyNode;
  }

  String toString() {
    String out="///";
    return out;
  }
}

class whileNode implements Node {


  Node conditionNode;
  Node bodyNode;

  Node stepValueNode;

  whileNode(Node conditionNode, Node bodyNode) {
    this.conditionNode=conditionNode;
    this.bodyNode=bodyNode;
  }

  String toString() {
    String out="///";
    return out;
  }
}
