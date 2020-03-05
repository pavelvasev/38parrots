// Предназначение - по заданному списку групп-и-пресетов построить гуи для их вызова
Item {
  id: gen
  property var input: new Object();
  
    // массив вида
    // [{ title: имя категории, variants: [....]}]
    // где каждый вариант это: {значения-параметров}
  
  onInputChanged: {
    console.log("PresetGuiGenerator input changed:",input );
    setTimeout( function() {
      findRootScene( gen ).refineSelf();
    } );
  }

  property var cats: input
  
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
    model: cats.length
    Row {
      spacing: 3
      
      property var cat: cats[index]
      Text {
        text: cat.title || String(index)
        y: 2
      }
      Repeater {
        model: cat.variants.length
        
        Button {
          text: cat.variants[index].title || String(index)
          onClicked: perform( cat.variants[index] )
        }
      }
    }
  }
  
  }
  
  function perform( variant_record ) {
    console.log("PresetGuiGenerator: user click preset variant: ",variant_record );
    
    var newparams = variant_record.params;
    // var newparams = variant_record.params; // это сокращенный вариант
    
    delete newparams['title'];
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

}