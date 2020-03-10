// Предназначение: вызывать вычисление func(params) и записывать в target.targetProperty
// делая это с таймаутом. Необходимо если параметры быстро меняются - чтобы qml не считал все по 5 раз

Item {
  id: dc
  
  property var targetProperty
  property var func
  property var params
  
  property var target: parent

  onParamsChanged: {
    if (dc.timerId) 
      clearTimeout( dc.timerId );
    else
      qmlEngine.rootObject.propertyComputationPending = qmlEngine.rootObject.propertyComputationPending+1; // важный момент для анимации
      
    dc.timerId = setTimeout( function() {
      dc.timerId = undefined;
      qmlEngine.rootObject.propertyComputationPending = qmlEngine.rootObject.propertyComputationPending-1;
      var v = func.apply( this, params )
      // console.log("deferred v=",v)
      target[targetProperty] = v;
    }, 0 );
  }
}