// предназначение - отредактировать заданное меню (евойный код)
// вход: input - описание меню (ако js-объект простой)
//       выход - сигнал edited( obj )

SimpleDialog {
  id: edt
  
  signal edited(object obj);
  
  // здесь input это js-код меню
  property var input: new Object({})

  property var stateManager
  title: "Редактор скрипта меню на языке YAML"; //+(input.title || input.id)
  onAfterOpen: showmenucode( edt.input )

  height: coco.height+40
  width: 720

  Column {
       id: coco
       width: 700 //parent.width
       spacing: 5
       
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
           text: "Добавить&nbsp;состояние&nbsp;в&nbsp;конец&nbsp;списка"
//           width: 400
           onClicked: doadd()
       }
       Button {
           text: "Добавить&nbsp;только&nbsp;отличия"
//           width: 100
           onClicked: doadd2()
       }       
       }
       
       Text {
         text: " "
       }

       
       Row {
         spacing: 3
         
         Button {
           text: "Сохранить"
//           onClicked: dosave();
//           text: "Сохранить&nbsp;и&nbsp;закрыть"
           onClicked: { dosave(); edt.close(); }
         }
         
         Text {
           id: svstatus
           text: "status"
         }
         
         Button {
           text: "Отмена"
           onClicked: edt.close();
//           text: "Выйти&nbsp;не&nbsp;сохраняя"
//           onClicked: edt.close();
         }         
      }
       
    }
  
  YamlParser {
    id: yparser
  }
  
  // обстракция работы с человеком
  function obj2str(obj) {
    return yparser.generate_yaml(obj);
  }
  function str2obj(str)
  { 
    try {
      var obj = yparser.compute( str );
      svstatus.text = "ok";
      return obj;
    } catch(e) {
      console.error(e);
      svstatus.text = "ОШИБКА РАЗБОРА КОДА!";
      blocked = false;
      return;
    }
    //return JSON.parse(str);
  }
  
  function showmenucode( input ) {
    tep.text = obj2str( input );
  }
  
  // добавляет текущее состояние к коду меню
  function doadd() {
    var mnu = str2obj( tep.text );

    var obj = stateManager.getState();
    obj = Object.assign( {}, obj )
    delete obj['menu'];
    delete obj['presets'];
    delete obj['afile']; // пока принудительно добавим и это, хак
    
    // убрать то что касается анимационности
    var objf = {};
    for (var p in obj) {
      if (p.indexOf("Animation2") >= 0) continue;
      objf[p] = obj[p];
    }
    obj = objf;
    
    //delete obj['film-T'];

    if (!Array.isArray(mnu.variants)) mnu.variants = [];

    obj = { title: "Введите название", params: obj }
    mnu.variants.push( obj );
    showmenucode( mnu )
  }
  
  function arreq( a1, a2 ) {
    if (Array.isArray(a1) && Array.isArray(a2)) {
      var s1=a1.toString();
      var s2=a2.toString();
      // debugger;
      if (a1.toString() == a2.toString()) return true;
    } 
    return false;
  }
  
  // добавляет текущее состояние к коду меню - но только отличия
  function doadd2() {
    var mnu = str2obj( tep.text );

    var obj = stateManager.getState();
    obj = Object.assign( {}, obj )
    delete obj['menu'];
    delete obj['presets'];
    //delete obj['film-T'];
    delete obj['afile']; // пока принудительно добавим и это, хак    
    
    // убрать то что касается анимационности
    var objf = {};
    for (var p in obj) {
      if (p.indexOf("Animation2") >= 0) continue;
      objf[p] = obj[p];
    }
    obj = objf;

    if (!Array.isArray(mnu.variants)) mnu.variants = [];
    
    if (mnu.variants.length > 0) {
      var prev = {};
      // вообще понятие "отличие" это я вкладываю в него то что мне удобно )))
      // проехали сверху вниз, накопили - и будем искать только разницу с тем что было
      for (var i=0; i<mnu.variants.length; i++) {
        Object.assign( prev, mnu.variants[i].params );
      }
      //var prev = mnu.variants[ mnu.variants.length-1 ].params;
      var obj2 = {};
      console.log("checking with prev", prev);
      for (prop in prev) {
        if (arreq(prev[prop],obj[prop])) continue;
        if (prev[prop] == obj[prop]) continue;
        if (prop.indexOf("Animation2") >= 0) continue;
        //console.log("value of prop",prop,"not equal:",prev[prop],obj[prop]);
        obj2[prop] = obj[prop];
      }
      obj = obj2;
    }
    
    console.log("add2 computed params: ",obj );

    obj = { title: "Введите название", params: obj }
    mnu.variants.push( obj );
    showmenucode( mnu )
  }  
  
  function dosave()
  {
    edt.edited( str2obj( tep.text ) );
  }

}