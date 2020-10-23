// Предназначение - по заданному списку групп-и-пресетов построить гуи для их вызова
Item {
  id: gen
  property var input: []
  
  signal menuClicked(int index);
  
  property var stateManager
  
    // массив вида
    // [{ title: имя категории, variants: [....]}]
    // где каждый вариант это: {значения-параметров}
  
  onInputChanged: {
    console.log("PresetGuiGenerator input changed:",input );
    setTimeout( function() {
      findRootScene( gen ).refineSelf();
    },1 );
  }

  property var cats: input
  property var catsKeys: Object.keys( cats )
  // работает и с массивами
  
  Flow {
    property var tag: "top"
    width: Math.min( totalChildrenWidth()+50, findRootScene( gen ).width - 50 )
    
    spacing: 5
    
    function totalChildrenWidth() {
      var acc=0;
      for (var i = 0; i < this.children.length; i++) {
        var child = this.children[i];
        if (child.width)
          acc = acc + child.width;
      }
      return acc;
    }
  
  Repeater {
    model: catsKeys.length
    //onModelChanged: console.log("pgen keys=",catsKeys );
    Row {
      spacing: 3
      
      property var cat: { var q = cats[catName] || {}; if (!Array.isArray(q.variants)) q.variants=[]; return q; }
      property var catName: catsKeys[index]
      Text {
        visible: !iscombo
        text: "<a href='javascript:;'>" + (cat.title || "menu"+catName) + "</a>"
        y: 2
        id: txt
        onTextChanged: {
          var r = txt.dom;
          var link = r.children[0].children[0];
          link.onclick = function() {
            menuClicked( catName );
          }
        }
      }
      property var iscombo: cat.gui == "combo"
      property var isbuttons: !iscombo
      Repeater {
        model: isbuttons ? (cat.variants || []).length : 0
        
        Button {
          text: cat.variants[index].title || String(index)
          onClicked: perform( cat.variants[index] )
        }
      }
      ComboBox {
        visible: iscombo
        model: [""+(cat.title||catName)+""].concat( cat.variants.map( function(v) { return v.title } ) ).concat("..настроить..");
        onCurrentIndexChanged: {
          // кликнули "настроить"
          if (currentIndex == model.length-1) {
            currentIndex = 0;
            menuClicked( catName );
            return;
          }
          if (currentIndex > 0) {
            perform( cat.variants[ currentIndex-1 ] )
            currentIndex = 0;
          }
        }
        width: 120
      }
    }
  }
  
  }
  
  function perform( variant_record ) {
    console.log("PresetGuiGenerator: user click preset variant: ",variant_record );
    var newparams = variant_record.params;
    // var newparams = variant_record.params; // это сокращенный вариант
    delete newparams['title'];
    stateManager.patchState( variant_record.params );
    stateManager.broadcastState();
    return;
  }

  EditMenu {
    id: editmenu
    stateManager: gen.stateManager
    property var catName
    onEdited: {
      // сохраним в объект состояния наше изменение по меню
      // может можно сказать setParam( "menu", getParam("menu")[catName]=obj )?
      console.log("saving menu content to state. name=",catName,"value=",obj);

      stateManager.pstate.menu[catName] = obj;
      stateManager.pstate.menu = JSON.parse( JSON.stringify( stateManager.pstate.menu ) );
      // без этого оно не хотит признавать шо объект изменился?
      
      stateManager.broadcastState();
    }
  }


}