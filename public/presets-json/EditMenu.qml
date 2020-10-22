// предназначение - отредактировать заданное меню (евойный код)
// вход: input - описание меню (ако js-объект простой)
//       выход - сигнал edited(obj)

SimpleDialog {
  id: edt
  
  signal edited(object obj);
  
  // здесь input это информация по меню
  property var input: new Object({})

  property var stateManager
  title: "Состав меню "+(input.title || input.id)
  onAfterOpen: showmenucode( edt.input )

  height: coco.height+40
  width: 720

  Column {
       id: coco
       width: 700 //parent.width
       
       Button {
           text: "Добавить текущее состояние в конец списка"
           width: 450
           onClicked: doadd()
         }
       
       Text {
         text: " "
       }       
       
       TextEdit {
         id: tep
         height: 500
         width: parent.width
       }
       
       Text {
         text: " "
       }       
       
       Row {
         spacing: 3
         
         Button {
           text: "Сохранить"
           onClicked: dosave()
         }
         
         Text {
           id: svstatus
           text: "status"
         }
      }
       
    }
  
//  YamlParser {
//    id: yparser
//  }
  
  // обстракция работы с человеком
  function obj2str(obj) {
    return JSON.stringify( obj, null, '  ');
  }
  function str2obj(str)
  { 
    try {
      var obj = JSON.parse( str );
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
  
  function doadd() {
    var mnu = str2obj( tep.text );
    
    var obj = stateManager.getState();
    obj = Object.assign( {}, obj )
    delete obj['menu'];
    delete obj['presets'];
    delete obj['film-T']; // важно чтобы этой переменной там не было тоже
    
    if (!Array.isArray(mnu.variants)) mnu.variants = [];
    
    obj = { title: "Введите название", params: obj }
    mnu.variants.push( obj );
    
    showmenucode( mnu )
  }
  
  function dosave()
  {
    var obj = str2obj( tep.text );
    edt.edited( obj );
  }

}