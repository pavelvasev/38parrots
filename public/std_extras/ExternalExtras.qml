import "../presets"

SimpleDialog {
  id: proc
  
  property var extrasManager
  property var tag: "other"
  
  // это собственно значение списка добавок
  property var value: []
  
  onAfterOpen: {
    val2text();
  }
  
  height: main.height+40
  width: main.width+40
  
  Column {
    id: main
    TextEdit {
      width: 600
      height: 200
      id: tep
    }
    
    Row {
         spacing: 3
         
         Button {
           text: "ПРИМЕНИТЬ"
           onClicked: {
             text2val();
             doapply()
           }
         }
         
         Text {
           id: svstatus
           text: "status"
         }
    } //row
  }
  

  property bool block: false
  function text2val() {
    if (block) return;
    block = true;
    proc.value = JSON.parse( tep.text );
    block = false;
  }
  
  function val2text() {
    if (block) return;
    block=true;
    tep.text = JSON.stringify( proc.value,null,"  " );
    block=false;
  }
  
  function doapply() {
    if (block) return;
    extrasManager.input_api2 = value;
  }
  
  onValueChanged: {
    doapply();
  }

  ParamUrlHashing {
    name: scopeNameCalc.globalName
    target: proc
  }

  ScopeCalculator {
    id: scopeNameCalc
    name: "list"
  }
}
