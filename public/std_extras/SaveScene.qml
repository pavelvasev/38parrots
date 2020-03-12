import "../presets"

SimpleDialog {
  id: proc

  property var tag: "other"
  
  onAfterOpen: {
    addcurrent();
  }
  
  height: tabview.height+40
  width: tabview.width+40
  
  TabView {
    width: 650
    id: tabview
    height: 500

/*    Tab {
      title: "TiniUrl"
      id: tab0
    }
*/
    
    Tab {
      id: tab1
      title: "Файл"
      height: col.height+30
      width: col.width
      
      Column {
        id: col
        TextEdit {
          height: 400
          width: 600
          id: tep
        }
        Row {
         spacing: 3
         Button {
           text: "ПРИМЕНИТЬ"
           onClicked: txt2value()
         }
         Text {
           id: svstatus
           text: "status"
         }
      }

      }
    }

  }
  
  YamlParser {
    id: yparser
  }
  
  /*
  ParamUrlHashing {
    name: "-"
    enabled: false
    id: hasher
    manual: true
  }*/
  
  property var stateManager:qmlEngine.rootObject.stateManager

  function addcurrent() {
    var obj = stateManager.getState();
    // var obj = hasher.read_hash_obj();
    var txt = JSON.stringify( obj, null, '  ');
           
    //var txt = yparser.generate_yaml( obj, true );
    tep.text = txt;
  }

  property bool blocked: false
  function txt2value() {
    if (blocked) return; blocked=true;
    txt = tep.text;
    console.log("txt2value..");
    var obj = {};
    try {
      var obj = JSON.parse( txt );
      //var obj = yparser.compute( txt );
      svstatus.text = "ok";
    } catch(e) {
      console.error(e);
      svstatus.text = "ОШИБКА!";
      blocked = false;
      return;
    }
    setparams( obj )
    //value = obj;
    blocked = false;
  }

//  property var value: new Object({})
//  onValueChanged: setparams( value )
  
  function setparams( obj ) {
    console.log("SaveScene: setting params!",obj)
    stateManager.setState( obj );
    stateManager.broadcastState();
    //hasher.overwriteParamsInHash( obj.params );
    //console.log("sending event!");
    //findRootScene( proc ).windowHashToParams();
  }

}
