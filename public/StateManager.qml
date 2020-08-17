/* Предназначение: управлять объектом "состояние сцены", 
   который обновляется параметрами при смене значения,
   а также подразумевается для сохранения в хеш и файлы.

   Потоки событий
   Completed -> initState(чтение window hash и тп) + broadcast
   
   patchState -> update window hash
   а если кому надо распространить это по параметрам то пусть вызывает broadcastState
   
   broadcastState -> сигнал sendStateToParams (все объекты ParamUrlHashing подписаны на него)
   
   Неожиданно и забавно, что во время broadcast все параметры дружно присылают patchState обратно
   ну да ладно.
*/
Item {
  id: man
  
  property bool enabled: parent.isRoot
  
  /// api
  
  function getState() {
    return pstate;
  }
  
  function setState( obj )
  {
    pstate = obj;
  }
  
  function patchState( newparams,callername ) {
    //console.log("patchState called", callername, newparams );
    for (paramname in newparams)
      if (newparams.hasOwnProperty(paramname))
      {
        var v = newparams[paramname];
        if (typeof(v) == "undefined")
          delete pstate[ paramname ];
        else
          pstate[paramname] = v;
      }
    pstateChanged();
  }

  // экспериментально, на будущее.. (и не отлажено)
  function patchState2( newparams,callername,path )
  {
    console.log("patchState called", path, callername, newparams );
    var tstate = pstate;
    for (var i=0; i<path.length; i++) {
      if (typeof( tstate[ path[i] ] ) == "undefined") tstate[ path[i] ] = {};
      tstate = tstate[ path[i] ];
    }
    for (paramname in newparams)
      if (newparams.hasOwnProperty(paramname))
      {
        var v = newparams[paramname];
        if (typeof(v) == "undefined")
          delete tstate[ paramname ];
        else
          tstate[paramname] = v;
    }
    console.log("patched =",pstate );
    pstateChanged();
  }
  
  function broadcastState() {
    //console.log("broadcasting");
    sendStateToParams( pstate )
  }
  
  signal sendStateToParams( object params );
  
  ////// the params state
  
  property var pstate: new Object({})
  
  ////// window hash
  
  ParamUrlHashing {
    id: puh
    enabled: false
    manual: true
  }
  
  onPstateChanged: flowStateToHash()
  
  property var timeout_id
  function flowStateToHash() {
    if (!enabled) return;
    //console.log("flowStateToHash: flow...");
    if (timeout_id) {
      clearTimeout( timeout_id );
      timeout_id = undefined;
    }
    timeout_id = setTimeout( function() {
      //console.log("flowStateToHash: writing to window hash...",pstate);
      var filtered = filterOut( pstate, stateFromFiles )
      //console.log( "filtered=",filtered );
      puh.overwriteParamsInHash( filtered );
    }, 250 );
  }
  
  ////////
  
  // предназначение - хранить значения загруженные из файлов
  // для того чтобы при генерации window-hash не дублировать их
  property var stateFromFiles: new Object({})
  
  // предназначение - убрать из obj все ключи, присутствующие в hint
  function filterOut( obj, hint )
  {
    var newobj = Object.assign( {}, obj );
    //debugger;
    for (paramname in hint)
      if (hint.hasOwnProperty(paramname) && newobj.hasOwnProperty(paramname))
      {
         var hv = hint[paramname];
         /*if (hv === newobj[paramname]) // мне кажется это слишком просто, к тому же массивы
           delete newobj[paramname];
           */
        // вот такой вот метод сравнения
        if (JSON.stringify(hv) == JSON.stringify(newobj[paramname]))
          delete newobj[paramname];
      }
    return newobj;
  }
  
  //////
  
  // занимается инициализацией состояния по данным из внешнего мира
  function initState() {
    if (!enabled) return;
    //console.log("^^^ initState");
    
    // scene conf
    var rs = findRootScene( man );
    if (rs && rs.sceneconf) {
      var obj = JSON.parse( rs.sceneconf );
      patchState( obj.params,"initState/sceneconf" );
      stateFromFiles = Object.assign( {}, pstate );
    }
    
    // load from file
    var urlconf = getParameterByName("conf")
    if (urlconf) {
      loadFile( urlconf, 
        function (str) {
          try {
            var params = JSON.parse( str );
            patchState( params,"initstate/urlconf" );
            stateFromFiles = Object.assign( {}, pstate );
            console.log("^^^ initState urlconf stage finished",getState());
          } catch( err ) {
            console.log("initState urlconf error 2",err );
          }
          initState2();
        },
        function (err) {
          console.log("initState urlconf error 1",err );
          initState2();
        }
      );
    }
    else
      initState2();
  }
  
  // вторая стадия
  function initState2() {
    // window hash  
    var hashobj = puh.read_hash_obj();
    patchState( hashobj.params, "initState/windowhash" );
    
    console.log("^^^ initState finished",getState());
    console.log("^^^ broadcasting to params...");
    broadcastState();
    console.log("^^^ initState finally finished");  
  }
  
  Component.onCompleted: initState();
  
  //// todo
  function loadParser( string, finalfunc ) {
  
  }
}