Column {
  id: main
  
  property var tag: "right"
  
  ComboBoxParam {
    id: film_src
    text: "Выбор фильма"
    guid: "film-track"
    values: (stateManager.pstate.menu || []).map( function(m,index) { return m ? m.title || m.id || index : "-" } )
  }

  Param {
    id: anim_p
    guid: "film-T"
    text: "Время в фильме (film-T)"
    min: mult.tmin
    max: mult.tmax
    step: mult.tstep
    onValueChanged: {
      main.anim_v_changed( value )
    }
  }
  
  ///////////////////////////////////////////////////
  
  // наполняет state1 значениями из стека состояний,
  // которые представлены в state2 но не в state1
  // таким образом у нас выравниваются все параметры
  function fix_state( state1, state2, prev_arr )
  {

    for (k in state2)
      if (typeof(state1[k]) == "undefined") {
        console.log("need to fix param ",k );
        for (var i=prev_arr.length-1; i>= 0; i--) {
          var teststate = prev_arr[i];
          if (typeof(teststate[k]) == "undefined") {} else {
            console.log("param found!",teststate[k]);
            state1[k] = teststate[k];
            break;
          }
        }
    };
    //return state1;
  }
  
  // выравнивает мультик заполняя стадии недостающими параметрами
  function fix_states( state_chain ) {
    var arr = [stateManager.pstate];

    var chain = JSON.parse( JSON.stringify( state_chain ) );
    
    for (var i=0; i<chain.length-1; i++) {
       //console.log("fix_states: fixing state",chain[i]);
       fix_state( chain[i], chain[i+1], arr );
       arr.push( chain[i] );
    }
    return chain;
  }
  
  // интерполяция 1го значения с рекурсией по массивам и хешам
  function interp1( v1, v2, r )
  {
    if (Array.isArray(v2)) {
      if (!Array.isArray(v1)) return v2;
        
      var res = [];
      for (var i=0; i<v2.length; i++)
        res.push( interp1( v1[i], v2[i], r ) );
      return res;
    }
    
    if (typeof(v1) == "undefined") return v2;
    if (typeof(v2) == "undefined") return v1;
    
    if (typeof(v2) == "object") {
      if (!v1) return v2; // защита тоже
      
      var res = {};
      for (k in v2)
        res[k] = interp1( v1[k], v2[k], r );
      return res;
    }
    
    if (isNaN(v1) || isNaN(v2)) {
      return r >= 0.5 ? v2 : v1;
    }
    var middle = v1 + (v2 - v1) * r;
    return middle;
  }
  
  // интерполяция между двумя состояниями
  function interp( state1, state2, r )
  {
    return interp1( state1, state2, r );
  }
  
  // по мультику arr выполнить установку параметров системы
  // arr = набор четверок (state1, state2, t1, t2),...
  function apply_mult( arr, t )
  {
    for (var i=0; i<arr.length; i++) {
      var a = arr[i];
      if (a[2] <= t && t <= a[3]) {
        var ratio = (t - a[2]) / (a[3] - a[2]);
        var res = interp( a[0], a[1], ratio );
        setParams( res );
      }
    }
  }
  
  // итак мультик у нас это массив четверок + инфа по параметрам
  function states2mult( states ) {
    var res = [];
    var t = 0;
    for (var i=0; i<states.length-1; i++) {
      var step = 100;
      var tnext = t+step;
      res.push( [ states[i], states[i+1],t,tnext] );
      t = tnext;
    }
    res.tmin = 0;
    res.tmax = t;
    res.tstep = 1;
    return res;
  }
  
  /////////////////////////
  //property var mult: states2mult( [ as1(), as2(), as3(), as4() ] )
  
  property var stateMenu: stateManager.pstate.menu[ film_src.value ]
  property var selectedMenu: {}

  onStateMenuChanged: {
    var s = stateMenu;
    if (s != selectedMenu) {
      selectedMenu = s;
      mult = computeMult( s, stateManager.pstate );
    }
  }
  
  property var mult: []
  
  function computeMult( selectedMenu, baseState ) {
    console.log("film_src.value=",film_src.value );
    var states = selectedMenu.variants.map( function(v) { return v.params; } );
    console.log( "see states for mult:",states.toString() );
    states = fix_states( states );
    console.log( "fixed states for mult:",states );
    
    var res =  states2mult(states);
    //console.log(res);
    return res;
  }
  
  ///////////////////////// 
  
  function anim_v_changed( value ) {
    apply_mult( main.mult, value );
  }

  ///////////////////////////////////////////////////
  
  property var stateManager: qmlEngine.rootObject.stateManager
  
  // у нас 2 способа получить параметры.. - у параметра и через state (в state пишут псевдо-параметры типа камеры)
  function getParam( name ) {
    if (stateManager.pstate.hasOwnProperty(name));
      return stateManager.pstate[name];
    return undefined;
  }
  
  // patchState эффективнее за счет массовости..
  // вероятно надо сделать аналог, который все что в параметрах выставляет через setAppValue а остальное махом..
  // хотя и это неэффективно. эффективнее freeze сделать
  function setParam(name,value ) {
      var p = {};
      p[name]=value;
      stateManager.patchState(p);
  }
  
  // todo один setTimeout при нескольких вызовах

  function setParams(hash) {
    console.log("mult patch",hash );
    stateManager.patchState( hash );
    // сразу же нельзя ибо там еще в эти параметры основной не пропатчился параметр анимации
    setTimeout( function() {
      stateManager.broadcastState()
    }, 10 );
  }
  
  function getParams() {
    return stateManager.pstate;
  }

}