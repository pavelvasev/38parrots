// Предназначение - редактировать пресеты
Item {
  id: itm

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
         text: "Приписать текущие параметры"
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
  
  ParamUrlHashing {
    name: globalName
    id: hasher
  }

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
  
  /*  у нас уже есть  один
  ParamUrlHashing {
    enabled: false
    manual: true
    id: hasher
  }*/
  
  function addcurrent() {
    
    var obj = hasher.read_hash_obj();
    if (obj && obj.params) delete obj['params']['presets'];
    //var txt = JSON.stringify( [obj], null, '\t');
    
    // это сокращенный слегка вариант, для человека якобы
    //obj = Object.assign( {title:"Название варианта"}, obj.params || {} )
    //obj = [ {title: "Группа", variants: [obj]} ]
    
    // это правильное 1 к 1, но сносит мозг
    obj = { __title: "Название варианта", params: obj.params }
    obj = [ {title: "Группа", variants: [obj]} ]
    
    var txt = yparser.generate_yaml( obj, true );
    // txt = "- " + txt; // вот это трююк
    txt = txt.replace("__title","title");
    
    //tep.textInput.accepted();
    console.log("adding. curvalue=",tep.value,"and new is ",txt );
    //tep.value = tep.value + "\n" + txt;
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