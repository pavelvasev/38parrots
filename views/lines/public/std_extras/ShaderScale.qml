Shader {
  id: shader1
  
  property var input_0: 10000
  
  // работаем только на рост.. иначе получается что если диапазон уменьшается, то слайдеры съезжают на уменьшение, что неприемлемо
  onInput_0Changed: {
    //console.log("inpuit_0 changed to",input_0);
    if (pcoef < input_0) {
      pcoef = input_0;
    }
  }
  
  property var output: shader1
  
  property var pcoef: 10000
  property alias p1: pp1
  property alias p2: pp2
  property alias p3: pp3
  
  property var tag: "right"
  
  GroupBox {
  
    title: "Масштабы"
    property var tag: "right"
    
    Column {
    
  Param {
    id: pp1
    min: 0
    max: 10
    step: 0.1
    value: 1
    text: "x-scale"
    enableSliding: true
    comboEnabled: false
    textEnabled: true
    property var enableScopeDuplicated: true
  }
  
  Param {
    id: pp2
    min: 0
    max: 10
    step: 0.1
    value: 1
    text: "y-scale"
    enableSliding: true
    comboEnabled: false
    textEnabled: true    
    property var enableScopeDuplicated: true
  }  
  
  Param {
    id: pp3
    min: 0
    max: 10
    step: 0.01
    value: 1
    text: "phi-scale"
    enableSliding: true
    comboEnabled: false
    textEnabled: true        
    property var enableScopeDuplicated: true
  }  
  
  
    } // col
  
  } //grp

  property var vertex: "
          // your things
          uniform float sceneTime;
          uniform float p1;
          uniform float p2;
          uniform float p3;
          
          void main()
          {
            gl_Position.x = gl_Position.x *p1;
            gl_Position.y = gl_Position.y *p2;
            gl_Position.z = gl_Position.z *p3;
          }
        "
}
