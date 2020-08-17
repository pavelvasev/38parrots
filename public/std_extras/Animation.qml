Column {
  id: main
  
  property var tag: "right"

  Param {
    id: anim_p
    guid: anim_p
    //text: anim_name + (colParams[anim_name] != anim_p ? "(duplicate)" : "")
    onValueChanged: {
      me=true;
      set_p_value( anim_name, value )
      me=false;
    }
    property bool me: false
  }
  
  Text {
    id: anim_t
    text: anim_name + "=" + anim_value
    visible: !anim_p.visible
  }

  Button {
    text: "Настроить.."
    onClicked: proc.open()
  }
  

  SimpleDialog {
    id: proc
    
    height: tabview.height+40
    width: tabview.width+40
    
    TabView {
      width: 650
      id: tabview
      height: 300

      Tab {
        id: tab1
        title: "Код анимации"
//        height: col.height+30
//        width: col.width
        
        Column {
//          id: col
          
          TextEditParam {
            width: tabview.width
            height: tabview.height
            id: tep
            guid: "anim"
            // onValueChanged: parser.input = value;
            value: "T,ax,ay\n0,0,0\n50,3,3"
          }

        } // col
      } // tab
      Tab {
        title: "Список параметров"
        //Column {
        TextEdit {
          width: tabview.width
          height: tabview.height
          id: params_help
        }
        //Button {
        //  text: "Обновить"
        //}
        //}
      }
   } // tabview
   
   onAfterOpen: update_params_help()
   
   function update_params_help()
   {
      var q = findRootScene( main ).gatheredParams;
      var s = "";
      q.forEach( function(v) {
        s = s + v.target.globalName + "\n";
      } );
      //console.log("computed help=s",s);
      params_help.text=s;
   }


  } // dialog

  
  CsvParser {
    id: parser
    input: tep.value
    // output, output_columns
    onOutputChanged: setup_anim( output, output_columns )
  }
  
  function setup_anim(values,columns) {
    anim_name = columns[0];
    anim_p.text = columns[0];
    var pc =values[ columns[0] ];
    if (pc) {
        anim_p.min = pc[0];
        anim_p.max = pc[ pc.length-1 ];
        anim_p.step = (anim_p.max - anim_p.min)/200.0;
        anim_p.globalName= "anim-"+columns[0];
      }
  }
  
  property var anim_name: ""
  property var anim_value: get_p_value( anim_name )

  property var colParams: find_pars( parser.output_columns )

  //find_pars( parser.output_columns )
  function find_pars(cols) {
    var q = findRootScene( main ).gatheredParams; //qmlEngine.rootElement.gatheredParams;
    //console.log("gp=",q);
    var f = function( name ) {
      for (var i=0; i<q.length; i++)
        if (q[i].target.globalName == name) return q[i].target;
      return undefined;
    }
    var acc = {};
    //var acc = [];
    for (var j=0; j<cols.length; j++) {
      var p = f( cols[j] );
      if (!p && j == 0) p = anim_p; // вот так-то
      acc[ cols[j] ] = p;
      //acc.push(p);
    }
    //console.log("found params for names=",cols,"res=",acc);
    return acc;
  }

  // у нас 2 способа получить параметры.. - у параметра и через state (в state пишут псевдо-параметры типа камеры)
  function get_p_value( name ) {
    var p = colParams[name];
    if (p) {
      //if (p["val"]) return p.val; // codemusic
      // индексный режим
      if (p["values"] && p.values.length > 0) return p.values[p.value];
      // обычный
      return p.value;
    }
    if (stateManager.pstate.hasOwnProperty(name));
      return stateManager.pstate[name];
    return undefined;
  }
  
  // patchState эффективнее за счет массовости..
  // вероятно надо сделать аналог, который все что в параметрах выставляет через setAppValue а остальное махом..
  // хотя и это неэффективно. эффективнее freeze сделать
  function set_p_value( name,value ) {
    var p = colParams[name];
    if (p) {
      p.setAppValue( value );
    }
    else {
      var p = {};
      p[name]=value;
      stateManager.patchState(p);
    }
  }

  onAnim_valueChanged: pass( anim_name, anim_value, parser.output, parser.output_columns )
  
  ///////////////////////////////////////////////////
    function findClosestBottomForSorted(num, arr) {
      var mid;
      var lo = 0;
      var hi = arr.length - 1;
      while (hi - lo > 1) {
        mid = Math.floor ((lo + hi) / 2);
        if (arr[mid] < num) {
          lo = mid;
        } else {
          hi = mid;
        }
      }
      if (num >= arr[hi]) return hi;
      return lo;
  }
  
  ///////////////////////////////////////////////////
  
  // параметр выбрал значение v
  function pass( name, v, values, columns ) {
//    console.log("pass called! (invoked only when anim_value changes... name=",name," v=",v);
    var st = {};
    
    if (!values) {
      console.error( "interpolation values are blank",values );
      return;
    }
    if (!columns || columns.length == 0)
    {
      console.error("interpolation columns are empty");
      return;
    }
    var values0 = values[ columns[0] ];
    if (!values0) {
      console.error("values0 are empty");
      return;
    }
    
    // выставим ка ему
    if (anim_p.value != v && !anim_p.me) anim_p.value = v;
    
    var i1 = findClosestBottomForSorted( v, values0 );
    // i1 это у нас номер строки
    var i2 = i1 < values0.length-1 ? i1+1 : i1;
    var step = (values0[i2] - values0[i1]);
    var ratio = step > 0 ? (v - values0[i1]) / step : 0;
    //ratio это шаг с которым надо ходить между i1 и i2
    console.log("i1 i2 ratio step values0=",i1,i2,ratio,step,values0);
    
    // сейчас будем управлять зависимыми параметрами
    for (var i=1; i<columns.length; i++) {
      var n = columns[i];
      var valuesn=values[n];
      // todo строчки..
      var nv = valuesn[i1] + (valuesn[i2]-valuesn[i1])*ratio;
      console.log("computed n=",n,"val=",nv);
      set_p_value( n, nv );
    }
    //st[name]=v;

    //console.log("patching with",st );
    //stateManager.patchState( st );
  }
  
  property var stateManager: qmlEngine.rootObject.stateManager

}