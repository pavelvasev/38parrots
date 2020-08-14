// Предназначение - по заданному списку групп-и-пресетов построить гуи для их вызова
Item {
  id: gen
  property var input: new Object();
  
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
    onModelChanged: console.log("pgen keys=",catsKeys );
    Row {
      spacing: 3
      
      property var cat: cats[catName]
      property var catName: catsKeys[index]
      Text {
        text: "<a href='javascript:;'>" + (cat.title || catName) + "</a>"
        y: 2
        id: txt
        onTextChanged: {
          var r = txt.dom;
          // console.log("llllllll r=",r);
          var link = r.children[0].children[0];
          // console.log("setting up to link",link);
          link.onclick = function() {
            console.log("clicked");
            addvariant.categoryCode = catName;
            addvariant.open();
          }
          //debugger;
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
        model: ["..."].concat( cat.variants.map( function(v) { return v.title } ) )
        onCurrentIndexChanged: {
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

/*  
    

    var obj = hasher.read_hash_obj();
    if (!obj.params)
      obj.params = newparams;
    else {
      for (paramname in newparams)
        if (newparams.hasOwnProperty(paramname))
          obj.params[paramname] = newparams[paramname];
    }
    // теперь obj.params это то что надо итого
    hasher.overwriteParamsInHash( obj.params );
    console.log("sending event!");
    findRootScene( gen ).windowHashToParams();
    // возможный побочный эффект - все write себе скажут, будет много change-ов
    // ну и ладно так надежнее
    console.log("PresetGuiGenerator: click processed");
  }
  
  ParamUrlHashing {
    enabled: false
    manual: true
    id: hasher
  }
*/

  AddVariant {
    id: addvariant
    stateManager: gen.stateManager
  }


}