// Предназначение - редактировать пресеты

// выход: output - массив пунктов меню пресетов, каждый пункт есть запись вида 
//    { title: ..., id: ..., gui: ..., variants: ... }
// где variants это массив записей вида 
//    { title: ..., params: ... } - здесь params это патч к состоянию системы
Item {
  id: itm

  property var output: []
  
  ////////////////////////
  // это собственно значение пресетов (сиречь нашего меню)
  // мы приехали к финальной стадии - это просто набор js-кодов безо всякой подготовки,
  // который может работать с апи
  property var value: []
  //onValueChanged: console.log("PRESET EDITOR: value changed",value );  
  
  onValueChanged: output = compute(value)
  
  // самое интересное
  // recs - набор js кодов, каждый генерит свой набор пресетов (сиречь меню)
  // а на выходе output-структура с пресетами
  function compute(recs) {
    var res = [];
    console.log("computing presets menu..");

    for (var i=0; i<recs.length; i++) {
      var createMenu = function(title) {
        var menu = { title: title, variants: [], gui: "combo" }
        //new Object( {} );
        menu.add = function( title, params ) {
          menu.variants.push( { title: title, params: params } );
        }
        menu.name = function(title) {
          menu.title = title;
        }
        res.push( menu );
        return menu;
      }
      var addMenu = createMenu;
      // передаем управление туды - пусть добавляют меню или что хотят делают
      try {
        eval( recs[i] );
      } catch(ex) {
        console.error( "ERROR computing menu ",i);
        console.error( "menu code was",recs[i]);
        console.error( ex );
      }
      //res.push( menu );
    }
    console.log("computed: ",res );
    return res;
  }
  
  ////////////////////////
  
  property var stateManager

  Button {
    property var tag: "top"
    text: "Добавить меню"
    onClicked: {
      var code = "var menu=createMenu( \"Новое\" );";
      //itm.value.push( { "title" : "Новое меню", "id":"new-menu", "gui": "combo" } );
      itm.value.push( code );
      itm.value = JSON.parse( JSON.stringify( itm.value )); // без этого оно чето не реагирует
      //itm.val
      //console.log("changing menu to:",itm.value);
      //itm.valueChanged();
    }
    visible: itm.visible
  }
  

  
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
      // у нас дан набор пресетов, причем они там хеш вида имя->объект
      for (p in v) {
        var obj = v[p];
        // итак у нас есть p - имя, и obj - объектна запись
        //var code = "menu.name(\""+obj.title+"\");";
        var code = "var menu = createMenu(\""+obj.title+"\");";
        var vs = obj.variants || [];
        for (var i=0; i<vs.length; i++) {
          var variant = vs[i];
          code = code + "\n\n" + "menu.add( \""+variant.title + "\"," + JSON.stringify(variant.params,null, '  ') + ");";
        }
        // двык вот, у нас отныне - меню это js-код. хахахаха.
        acc.push( code )
      }
      console.log("imported presets are",acc);
      if (acc.length > 0 && itm.value.length == 0) {
        console.log("assigning them to modern presets");
        itm.value=acc;
      }
      
      // кстати отстойная ситуация - тут я не могу контролировать что делать если и menu и presets приехали...
      // только косвенно через itm.value.length
      // было бы лучше, видимо, как-то выяснять что произошла загрузка страницы, например, и проводить опрос значений самостоятельно
      // без paramurlhashing.. кстати с учетом появления state это кажется возможно.. ну те же trackParam и в нем два гет-а... хммм
    }
    
  }
  
  function editMenu( index ) {
    editdlg.catName = index;
    editdlg.input = itm.value[ index ];
    editdlg.open();
  }
  
  EditMenu {
    id: editdlg
    stateManager: itm.stateManager
    property var catName
    onEdited: {
      // сохраним в объект состояния наше изменение по меню
      // может можно сказать setParam( "menu", getParam("menu")[catName]=obj )?
      console.log("saving menu content to state. name=",catName,"value=",obj);
      
      itm.value[ catName ] = obj;
      itm.valueChanged();
      // ну вроде бы а как еще то?

//      stateManager.pstate.menu[catName] = obj;
//      stateManager.pstate.menu = JSON.parse( JSON.stringify( stateManager.pstate.menu ) );
      // без этого оно не хотит признавать шо объект изменился?
//      stateManager.broadcastState();
    }
  }

}