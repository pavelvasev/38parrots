// Назначение - управлять добавками в рантайме

import "."

Column {
  id: sc
  
  property bool enabled: true
  property var scopeName: "extras"
  
  property var title: "Добавки"
  
  //onTimevalueChanged: console.log("shaderconfig tv changed",timevalue );
  
  property var tag: "right"
//  title: "Добавки"
  
//  Embed {
//    html: "<style> fieldset legend { color: #fff; } /*checkbox:*/ .ShaderConfig { color: #ddd; } /*params text*/  .ShaderConfig .Text span { color: #777 !important; }</style>"
//  }

  /////////////////// part 1  - интерфейс добавления добавки
  
  property var axnames: findRootScene( sc ).axes.titles
  property var xtitle: axnames[0]
  property var ytitle: axnames[1]
  property var ztitle: axnames[2]
  //property var ztitle: "Z"
  
  // таким образом добавки можно добавлять через input_1
  property var input_1: []
  property var input_api: []
  property var input_api2: []

  property var types:  input_1.concat( mytypes ).concat( input_api ).concat( input_api2 )
/*
  property var types: preobr( input_1.concat( mytypes ).concat( input_api ).concat( input_api2 ) )
  
  function preobr( arr ) {
    var m = arr.map( function(v) {
      url = v[1];
      if (url.indexOf("?") >= 0)
        url = url;
      else
        url = url + "?rand=";
      v[1] = url + Math.random();
      return v;
    });
    console.log("m=",m);
    return m;
    
  }
*/  
  
  property var mytypes: [
    ["Сдвиг","ShaderShift"],
    ["Масштаб","ShaderScale"],
    ["Автомасштаб","AutoScale", { tag: "left" }],
    ["Вписать<br/><br/>","ShaderBoxer", { tag: "left" }],
    
    ["Отсечение "+ztitle,"ShaderClip?z", { os: "z", titl: ztitle }],
    ["Отсечение "+xtitle,"ShaderClip?x", { os: "x", titl: xtitle }],
    ["Отсечение "+ytitle,"ShaderClip?y", { os: "y", titl: ytitle }],
    ["Отсечение к экрану<br/><br/>","ShaderClipScreen", {}],
    
    ["Серия "+ztitle,"ShaderClipS?z", { os: "z", titl: ztitle }],
    ["Серия "+xtitle,"ShaderClipS?x", { os: "x", titl: xtitle }],
    ["Серия "+ytitle,"ShaderClipS?y", { os: "y", titl: ytitle }],
    ["Подкраска сечений "+ztitle,"ShaderColorS?z", { os: "z", titl: ztitle }],
    ["Подкраска сечений "+xtitle,"ShaderColorS?x", { os: "x", titl: xtitle }],
    ["Подкраска сечений "+ytitle,"ShaderColorS?y", { os: "y", titl: ytitle }],
    ["Края сечений<br/><br/>","ShaderClipHilite", {}],
    
    ["Убрать черный","ShaderBlack", { }],
    ["Накоплять фон","FeatureKeepBkg", { }],
    
    
    ["Камера: взгляд","CameraLook", { tag: "left" }],
    ["Камера: поворот<br/><br/>","CameraRotate", { tag: "left" }],
    ["Имена осей","AxesNames", { tag: "other" }],
    ["Сохранить сцену","SaveScene", { tag: "other" }],
    ["Внешние добавки","ExternalExtras", { tag: "other" }],
    ["Пользовательский","ShaderUser", { titl: "1" }],
    ["Анимация","Animation", { titl: "1" }],
    ["Фильм","Animation2", { titl: "1" }]
    //["Анимация","http://127.0.0.1:8080/public/std_extras/Animation.qml", { titl: "1" }]
  ]

  SimpleDialog {
    id: adddlg
    
    title: "Добавить"
    
    height: coco.height+40
    
    Row {
    Column {
      
      Text {
        text: "Всего знаю разных видов: "+types.length
      }
      id: coco
      Repeater {
        model: types.length
        
        CheckBoxParam {
          width: 200
          text: types[index][0]
          //guid: types[index][1]
          //guid: "selectshader_"+index
          guid: "onoff_"+typeToScopeName(types[index]);
          property var typeIndex: index
          tag: undefined
          //onClicked: addshader( types[index][1] )
          onValueChanged: rescan()
          paramAnimation.enabled: false
        }
      }
    }
    }
  }
  
  function rescan() {
    var acc = [];
    acc.length = types.length;
    for (var i=0; i<coco.children.length; i++)
       if (coco.children[i].guid && coco.children[i].value > 0) acc[ coco.children[i].typeIndex ] = 1;
    selectedshadermask = acc;
    //console.log("rescan",acc);
    return acc;
  }
  
  // маска 1-0 по колву типов
  // т.е. это функция f: номердобавки -> да/нет
  property var selectedshadermask: []
  
  /*
   история такова что если делать список, то репитер потом совместно с loader-ом дурят
   и при смене списка начинают кого-то создавать, кого-то удалять, и бывает дублируются даже
   один и тот же шейдер, а от этого котовасия с гуидами параметров (но было обойдено через scopeName и enableDuplicated)
   но последней каплей оказалось что onConstruction/destruction я использовал для активации фичи,
   и при смене списка он сначала вызывал очередной constr а затем у старого destr
   ну и короче поэтому теперь все на масках и лоадеры все готовы загружать
  */

  
  //////////////////////// part 2 - загружалка
  
  Column {
    id: shadershere
    
     Button {
      //text: sc.title + "..."
      //text: "* " + sc.title
      text: sc.title
      onClicked: adddlg.open()
      width: 200
     }
     
     Text {
       text: " "
       height: 5
     }
  
  // итого Repeater натаскает N разных item-ом где N это кол-во возможных добавок
  // при этом некоторые из них реально загрузятся Loader-ом
  // эх как нам в qml не хватает "преобразователя типов".. 
  // он на вход получает объекты, и применяет к ним заданное преобразование..
  // например кнопочку добавляет
  // хотя формально это наверное можно сделать как-то
  
  Repeater {
    id: rep1
    model: sc.enabled ? types.length : 0
    
    Loader {
      id: ldr
      source: {
        var q = selectedshadermask[index] > 0 ? types[ index ][1] : undefined;
        //+"?"+Math.random()
        return q;
      }
      //property var s1: selectedshadermask[index] > 0 ? types[ index ][1]+"?"+Math.random() : undefined
      //onSourceChanged: console.log("source=",source);

      timeoutMode:false // иначе оно моргает - шейдеры старые (=сдвинувшиеся) удаляются репитером
      
      property var scopeName: typeToScopeName(types[ index ]) // жили они не тужили в своем скопе
      property var enableScopeDuplicated: true
      
      visible: false // так будет проще для всех
      implicitWidth: 0
      implicitHeight: 0
      
      onItemChanged: {
        // выкинем ка эти итемы лесом пока-что, а там вернем куды надо
        if (item) {
          item.oldSpaceParent = ldr; //item.parent; // но для сохранения скопов надо это сохранить
          item.parent = qmlEngine.rootObject;
        }

        rescanitems(0)
        if (item) init( item );
        // причем этот init уже вызывается ранее лоадером итак
        // но нам надо передать ему заголовки, в противном случае пропуск получается
      }
      
      onInit: {
        //console.log(" ~~~ init")
        var opts = types[ index ][2] || {};
        for (k in opts) {
          //obj[k] = Qt.binding( function() { return opts[k]; } )
          obj[k] = opts[k];
        }
        obj.title = ldr.title;
        obj.extrasManager = sc;
      }
      
      property var mparams: types[ index ][2] || {}
      onMparamsChanged: {
        //console.log(" * * * mparams",mparams, "item=", item );
        if (item) init( item )
      }
      
      // решил я отдельно title генерировать для них пересылать
      property var title: nbsp( types[ index ][0] )
      onTitleChanged: if (item) item.title = title
      function nbsp(text) { return text.replace( / /g,"&nbsp;"); }
    }
  }
  }

  function rescanitems(t) {
    //setTimeout( realrescanitems, t );
    realrescanitems(); // короче реальное моргание тут отрубается
  }
  
  function realrescanitems() {
    var acc = [];
    //for (var i=0; i<shadershere.children.length; i++) 
    var coll = rep1.$items; // shadershere.children

    for (var i=0; i<coll.length; i++) 
      if (coll[i].item) acc.push(coll[i].item);
      
    //console.log("realrescanitems: found shaders",acc);
    shaders=acc;
    return acc;
  }
  
  property var shaders: []
  
  // а вот это нам для двидиум надо
  // итого в shaders и output содержится то что пользователь активировал
  property var output: shaders
  
 
  ////////////////////////////////////// тема cliprange и других параметров
  property var cliprange: 10 // timer внизу
  property var timevalue: 0
  
  /////////////////
  function getClipRangeFromThreeJs() {
    // console.log("getcliprangefrom3");
    var r = 10; // minimum

    for (var i=0; i<scene.children.length; i++) {
      var c = scene.children[i];
      if (c.qmlParent && c.qmlParent.iAxis) continue;
      //debugger;
      if (c.geometry && c.geometry.boundingSphere) {
        var s = c.geometry.boundingSphere;
        var q = s.radius + Math.max( Math.abs(s.center.x),Math.abs(s.center.y),Math.abs(s.center.z) );
        if (q > r) r = q;
      }
    }
    return r;
  }
  
  Timer {
    interval: 500 // было раз в 5 секунд - это долго. ладно уж, пусть пока крутится, это вроде не сложный обход
    //running: true
    repeat: true
    onTriggered: sc.cliprange = getClipRangeFromThreeJs()
    id: timer
  }
  Component.onCompleted: timer.start();
  // по некоей загадочной причине их надо пнуть вручную, по крайней мере если это загружается через loader
  
  //////
  function typeToScopeName( rec ) {
    return rec[1].replace(/[\W]+/g,"_"); // не буква не цифра
  }
  
  /////////////////////// Рисовалка гуев
  GuiBox {
    function crit(item) {
      return item.tag == "right";
    }
    input: shaders
    
    // ну ей надо там быть
    Component.onCompleted: {
      parent = shadershere;
    }
  }
  
  GroupBox {
    title: "Важное"
    visible: gbprimary.myarr.length >0
    
    property var tag: "left"
    GuiBox {
      id: gbprimary
      function crit(item) { 
        return item.tag == "left";
      }
      input: shaders
    }
    Component.onCompleted: {
      parent = qmlEngine.rootObject
    }
  }

  GroupBox {
    title: "Разное"
    property var tag: "left"

    visible: gbother.myarr.length >0
    GuiBox {
      function crit(item) {
        return item.tag == "other";
      }
      id: gbother
      input: shaders
    }
    Component.onCompleted: {
      parent = qmlEngine.rootObject
    }
  }
  
  
  // пробельчиг
//  Text {
//    text: " "
//    height: 5
//  }
  
}