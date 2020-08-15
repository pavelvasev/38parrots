/*
  Предназначение
  По входному перечню имен колонок артефактов и их значений сгенерировать список Loader-ов,
  загрузить их, и передать им значения артефактов
*/

Item {
  id: cv
  
  signal viewLoaded( object view );
  
  //property var tag: "left"
  
  property var input: { 
    return {}
  }
  //onInputChanged: console.log("qq",input );
  
  property var artefact_col_names: []
  property var artefacts: []

  Item {
    id: loaderholder
    
    Repeater {
      id: rep
      model: artefact_col_names.length
      Loader {
        id: ldr
        source: find_artefact_viewer( artefact_col_names[index], artefacts[index] )
        
        property var scopeName: colname // важный параметр, означающий что суб-параметры этих сцен должны быть в этом scopeName-имени тусоваться; включая добавки вложенных сцен.
        property var title: colname
        
        onItemChanged: {
          //console.log("loader item changed!!!!!!");
          if (item) {
            item.afile.text = ""; //colname;
            item.afile.ahasher.enabled = false; // отключаем сохранение параметров в урли
            item.afile.atabview.visible = false; // отключаем выбор файла - уже не надо (я считаю)
            item.afile.atabview.height = 0;
            item.text = colname.replace("FILE_",""); // текст сцены
            item.title = item.text;
            
            cv.viewLoaded( item );

            // подцепим элементы управления
            //console.log("calling refine...");
            qmlEngine.rootObject.addSpace( item );
            //console.log("refined");
            
            feed_item();
            cv.rescanviews();
          }
        }
        property var colname: artefact_col_names[index]
        property var artfile: artefacts[index];
        onArtfileChanged: feed_item();
        
        // feature: в отключенные вьюшки не посылаем файла данных
        property var itemActive: item && item.visible
        onItemActiveChanged: feed_item();
        
        // предназначение - передать объект файла, который надо рассматривать в этом вьювере
        function feed_item() {
          //console.log("CinemaViews: feed_item called! Ldr source=",ldr.source, "colname=",ldr.colname,"artfile=",artfile );
          if (!ldr.item) {
            console.log("CinemaViews: viewer not loaded, skipping" );
            return;
          }
          if (!ldr.item.visible) {
            return;
          }          
          if (!artfile) {
            console.error("CinemaViews: warning, artefact file is emtpy.");
          }
          //console.log("ldr item=",ldr.item );
          ldr.item.afile.values = [artfile];
          
        }
      }
    }
  }
  
  function find_artefact_viewer( colname, val )
  {
    //console.log("CinemaViews:find-viewer",colname,val );
    var parts = colname.split("_");
    var type = parts[1]; // вот такой вот алгоритм
    var src  = "views/"+type+"/result.vl";
    //console.log(" computed viewer: ",src );
    return src;
  }
  
  // onArtefact_col_namesChanged: console.log("viewer artefact_col_names=",artefact_col_names );
  
  property var views: []
  function rescanviews() {
    var cc = loaderholder.children;
    var res = [];
    for (var i=0; i<cc.length; i++) {
      if (cc[i].item)
        res.push( cc[i].item );
    }
    views = res;
  }


  GroupBox {
    title: "Артефакты"
    property var tag: "left"
    GuiBox2 {
    input: {
      var acc = [];
      var m2 = rep2.model;
      for (var i=0; i<m2; i++) {
        var item = rep2.itemAt( i );
        if (!item) break;
        acc.push( item );
      }
      return acc;
    }
    //dasiface.children.filter( function(c) { return !!c.title; } )
    }
  }
  
  Item {
    id: dasiface
    Repeater {
      id: rep2
      model: views.length
      
      Column {
        id: dascol
        property var myview: views[index]
        property var title: myview.title
        CheckBoxParam {
          width: 150
          text: "Отображать"
          guid: "visible_"+myview.title
          value: 1
          onValueChanged: { 
            var u = myview;
            //console.log("ee va=",value, "setting to u=",u );
            u.visible = value > 0;
          }
        }
        // перетаскиваем параметры
        Component.onCompleted: {
          myview.params.forEach( function(p) {
            p.parent = dascol;
            //p.tag = undefined;
          } );
        }
      }
    }  
  }

}
