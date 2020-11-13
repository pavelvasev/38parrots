// Проигрыватель мультика

// вход: input[] - массив состояний
//       t - время
// выход: при изменении времени - устанавливает новое состояние системы

Item {
  id: main
  
  property var t: 0
  onTChanged: main.anim_v_changed( t )

  ///////////////////////////////////////////////////
  // Проблема - у нас состояния содержат минимальную информацию (это удобно пользователю я считаю)
  // но интерполятору нужна полная информация - т.е. вобоих состояниях параметр должен быть указан
  // идея - пройти по списку состояний и вычислить информацию там, где ее нет
  // а) пройти от начала мультика к концу, и если видим что в стадии1 нет того что есть в стадии2 - попытаться
  //    найти от начала мультика (искать ближайшие)
  // б) пройти также от начала мультика к концу, и если видим что в стадии2 нет того что есть в стадии1 - 
  //    наверное тупо взять из стадии 1 
  
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
  
  // проход (а) - добавляем в первое состояние инфу из предыдущих к ней
  function fix_states_1( state_chain ) {
    var arr = [stateManager.pstate];

    var chain = JSON.parse( JSON.stringify( state_chain ) );
    
    for (var i=0; i<chain.length-1; i++) {
       //console.log("fix_states: fixing state",chain[i]);
       fix_state( chain[i], chain[i+1], arr );
       arr.push( chain[i] );
    }
    return chain;
  }
  
  // проход (б) - добавляем во второе состояние (отсутствующую инфу) из первого
  function fix_states_2( state_chain ) {
    var arr = [stateManager.pstate];

    var chain = JSON.parse( JSON.stringify( state_chain ) );
    
    for (var i=0; i<chain.length-1; i++) {
       fix_state( chain[i+1], chain[i], [chain[i]] );
    }
    return chain;
  }
  
  function fix_states( state_chain ) {
    return fix_states_2( fix_states_1( state_chain ) );
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
  
  // input - массив состояний
  property var input: []
  
  // mult - массив четверок
  property var mult: []
  // computeMult( input );
  
  // надо разорвать связь, образующуюся в computeMult и pstate. 
  // тут мы делаем это
  property var currentInput: []
  onInputChanged: {
    var s = input;
    if (s != currentInput) {
      currentInput = s;
      mult = computeMult(s);
    }
  }
 
  // здесь mult это мультик (четверки)
  
  // вход - меню, выход - мультик
  function computeMult( states, baseState ) {
    if (!Array.isArray(states)) return [];
    states = fix_states( states );
    var res =  states2mult(states);
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

  property var sptid
  function setParams(hash) {
    console.log("mult patch",hash );
    stateManager.patchState( hash );
    // сразу же нельзя ибо там еще в эти параметры основной не пропатчился параметр анимации
    if (sptid) {
      clearTimeout( sptid );
    }
    sptid = setTimeout( function() {
      sptid=undefined;
      stateManager.broadcastState()
    }, 10 );
  }
  
  function getParams() {
    return stateManager.pstate;
  }

}