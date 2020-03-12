// Предназначение - редактировать пресеты
Item {
  id: itm
  
  property var stateManager

  Button {
    property var tag: "top"
    text: "Варианты"
    onClicked: {
      value2txt();
      edt.open();
    }
    visible: itm.visible
  }
  
  SimpleDialog {
    id: edt

    title: "Настройки вариантов"

    height: coco.height+40
    width: 720

    Column {
       id: coco
       width: 700 //parent.width
       
       Button {
         text: "Добавить категорию"
         onClicked: itm.addcurrent();
         width: 250
       }

       TextEdit {
         id: tep
         height: 500
         width: parent.width
       }
       
       Row {
         spacing: 3
         Button {
           text: "СОХРАНИТЬ"
           onClicked: txt2value()
         }
         Text {
           id: svstatus
           text: "status"
         }
      }
       
    }
  }
  
  // это собственно значение пресетов
  property var value: new Object({});
  //onValueChanged: console.log("preseteditor value changed",value );
  
  ParamUrlHashing {
    name: globalName
    id: hasher
    //здесь это уже бесполезно - тут присылают объект propertyWrite: "valueurlencoded"
  }

/*  property var valueurlencoded
  onValueurlencodedChanged: {
    var s = decodeURIComponent( valueurlencoded );
    console.log("WE GOT encoded value=",valueurlencoded,"and decoded it:",s)
    value = s;
  }
*/  

  property var globalName: scopeNameCalc.globalName
  property var globalText: scopeNameCalc.globalText
  ScopeCalculator {
    id: scopeNameCalc
    name: "presets"
    text: "presets"
    // globalName, globalText
  }  
  
  YamlParser {
    id: yparser
  }
  
  function addcurrent() {
    var obj = stateManager.getState();
    obj = Object.assign( {}, obj ); // защитим копированием
    delete obj['presets']; // от сиего удаления
    
    // это правильное 1 к 1, но сносит мозг
    obj = { __title: "Название варианта", params: obj }
    //obj = [ {title: "Смысл", variants: []} ] // [obj]
    record = {}
    record["category"+(new Date()).getTime()] = { title: "Смысл", variants: [obj]}
    
    var txt = yparser.generate_yaml( record, true );
    txt = txt.replace("__title","title");
    
    console.log("adding. curvalue=",tep.value,"and new is ",txt );
    tep.text = txt + "\n" + tep.text;
  }
  
  function addcateg() {
    record = {}
    record["category"+(new Date()).getTime()] = { title: "Смысл", variants: []}
    
    var txt = yparser.generate_yaml( record, true );
    tep.text = txt + "\n" + tep.text;
  }  

  
  property bool blocked: false
  function txt2value() {
    if (blocked) return; blocked=true;
    txt = tep.text;
    console.log("txt2value..");
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
    value = obj;
    blocked=false;
  }
  
  function value2txt() {
    if (blocked) return; blocked=true;  
    var obj = value;
    console.log("value2txt..");
    var txt = yparser.generate_yaml( obj );
    tep.text = txt;
    blocked=false;
  }

}