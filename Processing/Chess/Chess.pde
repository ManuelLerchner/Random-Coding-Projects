// A Lerchner Ind. Production
//08.09.2019
//1639 Lines of Code 

///////////////////////////////////////
boolean helpEnabled = true;
float animationSpeed = 0.1;
///////////////////////////////////////

void setup() {
  size(800, 800);
  loadImmages();
  initialize();
}

void draw() {
  Board();
  mousePos();
  showPossibleMoves();
  //////////////////

  SetOccupiedSpots();
  CalculatePossibleNexttMoves();
  ChessPieceFunctions();

  //////////////////
  setPathToBlock();
  showHud(); 
  detectStates(); 
  clearLists();
}
