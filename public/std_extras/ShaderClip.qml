Shader {
  id: shader1
  
  property var os: "x"
  property var titl: "X"
  
  property var input_0: cliprange // опирается получается на кого-то сверху, ибо у нас биндинги недоделанные в Loader
  
  // работаем только на рост.. иначе получается что если диапазон уменьшается, то слайдеры съезжают на уменьшение, что неприемлемо
  onInput_0Changed: {
    console.log("inpuit_0 changed to",input_0);
    if (pcoef < input_0) {
      pcoef = input_0;
      console.log("ShaderClip: pcoef changed to",pcoef );
    }
      else
      console.log("ShaderClip: pcoef NOT changed, using",pcoef ); 
  }
  
  property var output: shader1
  
  property var pcoef: 10
  property alias p1: pp1
  property alias p2: pp2
  
  property var tag: "right"
  
  property var pcoefstep: pcoef > 1000 ? 10 : (pcoef > 100 ? 1 : 0.1)
//  onPcoefstepChanged: console.log("ShaderClip: pcoefstep=",pcoefstep);
  
  GroupBox {
  
    title: "Отсечение "+titl
    property var tag: "right"
    
    Column {
    
  Param {
    id: pp1
    min: -pcoef
    max: pcoef
    step: pcoefstep
    value: -pcoef
    text: "p1"
    enableSliding: true
    property var enableScopeDuplicated: true
    textEnabled: true
    comboEnabled: false
  }
  
  
  Param {
    id: pp2
    min: 0
    max: 2*pcoef
    step: pcoefstep
    value: 2*pcoef
    text: "p2"
    enableSliding: true    
    property var enableScopeDuplicated: true
    textEnabled: true
    comboEnabled: false
    
  }
  
    } // col
  
  } //grp

//      property real time: scen.sceneTime
//      property real custom1: pCustom1.value


  property var vertex_t: "
          // your things
          uniform float sceneTime;
          uniform float p1;
          uniform float p2;
          varying vec3  qpositionOZ;
          
          void main()
          {
            qpositionOZ = position.xyz;
          }
           "
  vertex: vertex_t.replace(/OZ/g,os);           
                        
  fragmentOver: true // режим смешения с базовым цветом

  property var fragmenttempl: "
      uniform float sceneTime;
      varying vec3  qpositionOZ;
          uniform float p1;
          uniform float p2;
                  void main()
                        {
                          if (qpositionOZ.OZ < p1) discard;
                          //if (qpositionOZ.OZ > p1+p2) discard;
                          if (qpositionOZ.OZ > p1+p2) 
                            discard;
                            //gl_FragColor = vec4(1.0,0.0,0.0,0.1);;
                            //gl_FragColor.a = 0.2;
                            //gl_FragColor = vec4(1.0,0.0,1.0,1.0);;
            }
           "
  fragment: fragmenttempl.replace(/OZ/g,os);
                        
}
