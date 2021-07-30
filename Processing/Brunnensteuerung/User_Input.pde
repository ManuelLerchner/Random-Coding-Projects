void keyPressed() {

  //Start Taster
  if (key=='s' && !AnlageBisMorgenAus && !WartungsModus) {
    AnlageEin=true;
    ManuellerModus=false;
    durchlaufCounter++;

    Wiederholungen =  10; // Drehregler [30,120]
    ZeidauerFaktor =  0.3; // Drehregler [1/3 , 3]


    String msg="Start Automatik Modus:  Wiederholungen: "+ Wiederholungen+ ", ZeitFaktor: "+ ZeidauerFaktor+", Expected Time: "+ ZeidauerFaktor*60+"s";
    Log(new Error("INFO", msg));
  }

  //Manueller Start Taster
  if (key=='m' && !WartungsModus) {
    AnlageEin=true;
    ManuellerModus=true;
    durchlaufCounter++;

    Wiederholungen =  1;
    ZeidauerFaktor =  0.3; // Drehregler [1/3 , 3]


    String msg="Start Manueller Modus:  Wiederholungen: "+ Wiederholungen+ ", ZeitFaktor: "+ ZeidauerFaktor+", Expected Time: "+ ZeidauerFaktor*60+"s";
    Log(new Error("INFO", msg));
  }


  //Reset Anlage
  if (key=='r') {
    WartungsModus=false;
    durchlaufCounter=0;
    AnlageBisMorgenAus=false;


    String msg="Wartung abgeschlossen, Anlage wieder bereit";
    Log(new Error("INFO", msg));
  }


  //Not Halt
  if (key=='h' && AnlageEin) {
    resetAnlage();


    String msg="NOT-HALT betätigt, Anlage wird Ausgeschaltet";
    Log(new Error("WARNING", msg));
  }
}
