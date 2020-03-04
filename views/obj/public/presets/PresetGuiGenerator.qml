Item {
  id: gen
  property var input: new Object();
  
  onInputChanged: {
    console.log("PresetGuiGenerator input changed:",input );
    setTimeout( function() {
      findRootScene( gen ).refineSelf();
    } );
  }
  
  function parse( inp ) {
    var records = Object.keys( inp );
    var hcats = {};
    records.forEach( function(name) {
      var parts = name.split("/");
      var catname = parts [0];
      var itemname = parts [1] || parts[0];
      
      var title = inp[name].title || itemname;
      if (!hcats[ catname ]) hcats[catname] = [];
      hcats[catname].push( { title : title, params: inp[name] } );
      
      /*var k = Object.assign({}, inp[ name ] );
      if (!k.title) k.title = itemname;
      
      if (!hcats[ catname ]) hcats[catname] = [];
      hcats[catname].push( k );
      */
    });
    
    var catnames = Object.keys( hcats );
    var res = [];
    catnames.forEach( function(catname) {
      res.push( {title: catname, variants: hcats[catname]} );
    } )
    
    console.log("PresetGuiGenerator: parsed to res",res);
    console.log("btw hcats=",hcats );
    return res;
    // итого это теперь это массив вида
    // [{ title: имя категории, variants: [....]}]
    // где каждый вариант это: массив вида:
    //   [ {title: имя варианта, params: {значения-параметров} ]
  }
  
  property var cats: parse( input )
  
  Repeater {
    model: cats.length
    Row {
      spacing: 2
      property var tag: "top"
      property var cat: cats[index]
      Text {
        text: cat.title
        y: 2
      }
      Repeater {
        model: cat.variants.length
        
        Button {
          text: cat.variants[index].title
          onClicked: perform( cat.variants[index] )
        }
      }
    }
  }
  
  function perform( variant_record ) {
    console.log("PresetGuiGenerator: user click preset variant: ",variant_record );
    var newparams = variant_record.params;
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