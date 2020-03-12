SimpleDialog {
  id: edt

  property var stateManager
  property var categoryCode: "-"
  
  title: "Добавление варианта в категорию "+categoryCode
  
  onAfterOpen: addcurrent()

  height: coco.height+40
  width: 720

  Column {
       id: coco
       width: 700 //parent.width
       
       Text {
         text: " "
       }
       
       TextEdit {
         id: tep
         height: 500
         width: parent.width
       }
       
       Row {
         spacing: 3
         Button {
           text: "ДОБАВИТЬ"
           onClicked: gogo()
         }
         Text {
           id: svstatus
           text: "status"
         }
      }
       
    }
  
  YamlParser {
    id: yparser
  }
  
  function addcurrent() {
    var obj = stateManager.getState();
    
    var catInfo = obj.presets[ categoryCode ];
    
    obj = Object.assign( {}, obj )
    delete obj['presets'];
    
    if (catInfo.only) {
      var newobj = {};
      for (var i=0; i<catInfo.only.length; i++) {
         if (typeof( obj[ catInfo.only[i] ] ) != "undefined")
           newobj[ catInfo.only[i] ] = obj[ catInfo.only[i] ];
      }
      obj = newobj;
    }
    
    // это правильное 1 к 1, но сносит мозг
    obj = { __title: "Название варианта", params: obj }
    
    var txt = yparser.generate_yaml( obj, true );
    // txt = "- " + txt; // вот это трююк
    txt = txt.replace("__title","title");
    
    //tep.textInput.accepted();
    console.log("adding. curvalue=",tep.value,"and new is ",txt );
    //tep.value = tep.value + "\n" + txt;
    tep.text = txt;
  }

  
  function gogo() {
    txt = tep.text;
    var obj = {};
    try {
      var obj = yparser.compute( txt );
      svstatus.text = "ok";
    } catch(e) {
      console.error(e);
      svstatus.text = "ОШИБКА!";
      blocked = false;
      return;
    }
    
    var state = stateManager.getState();
    if (!Array.isArray(state.presets[ categoryCode ].variants)) state.presets[ categoryCode ].variants = []
    state.presets[ categoryCode ].variants = state.presets[ categoryCode ].variants.concat( [obj] ); // concat а не пуш чтобы объект изменился
    
    //stateManager.pstate = JSON.parse( JSON.stringify( state ) );
    stateManager.pstate.presets = JSON.parse( JSON.stringify( state.presets ) );
    //state
    
    //state.presets = Object.assign( {}, state.presets ); // важно чтобы тут было новое значнеие, а то они там в qml проверят и не пришлют changed
    // stateManager.pstateChanged();
    stateManager.broadcastState();
    //stateManager.patchState2( obj,"AddVariant",["presets",categoryCode] )
  }

}