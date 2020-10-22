// Предназначение - редактировать пресеты
Item {
  id: itm
  
  property var stateManager

  Button {
    property var tag: "top"
    text: "Добавить меню"
    onClicked: {
      itm.value.push( { "title" : "Новое меню", "id":"new-menu", "gui": "combo" } );
      itm.value = JSON.parse( JSON.stringify( itm.value )); // без этого оно чето не реагирует
      //console.log("changing menu to:",itm.value);
      //itm.valueChanged();
    }
    visible: itm.visible
  }
  
  
  // это собственно значение пресетов (сиречь нашего меню)
  property var value: []
  onValueChanged: console.log("PRESET EDITOR: value changed",value );
  
  ParamUrlHashing {
    name: globalName
    id: hasher
  }

  property var globalName: scopeNameCalc.globalName
  property var globalText: scopeNameCalc.globalText
  ScopeCalculator {
    id: scopeNameCalc
    name: "menu"
    text: "menu"
    // globalName, globalText
  }
  
  // convertor из старых presets в наше новое menu
  Item {
    ScopeCalculator {
      id: scopeNameCalc2
      name: "presets"
      text: "presets"
      // globalName, globalText
    }
    ParamUrlHashing {
      name: scopeNameCalc2.globalName
      id: hasher
    }
    property var value: new Object({});
    
    onValueChanged: {
      console.log("IMPORTING PRESETS",value );
      var v = value;
      var acc = [];
      for (p in v) {
        var neo = v[p];
        neo.id = p;
        acc.push( neo )
      }
      if (acc.length > 0 && itm.value.length == 0) itm.value=acc;
      // кстати отстойная ситуация - тут я не могу контролировать что делать если и menu и presets приехали...
      // только косвенно через itm.value.length
      // было бы лучше, видимо, как-то выяснять что произошла загрузка страницы, например, и проводить опрос значений самостоятельно
      // без paramurlhashing.. кстати с учетом появления state это кажется возможно.. ну те же trackParam и в нем два гет-а... хммм
    }
    
  }

}