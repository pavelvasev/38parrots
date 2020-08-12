Shader {
  id: shader1
  
  property var os: "x"
  property var titl: "X"
  

  property var input_0: cliprange // опирается получается на кого-то сверху, ибо у нас биндинги недоделанные в Loader
  
  // работаем только на рост.. иначе получается что если диапазон уменьшается, то слайдеры съезжают на уменьшение, что неприемлемо
  onInput_0Changed: {
    //console.log("inpuit_0 changed to",input_0);
    if (pcoef < input_0) {
      pcoef = input_0;
    }
  }
  
  property var output: shader1
  
  property var pcoef: 10
  property alias p1: pp1
  property alias p2: pp2
  property alias p3: pp3  
  
  property var tag: "right"
  
  property var pcoefstep: pcoef > 1000 ? 10 : (pcoef > 100 ? 1 : 0.1)
  
  GroupBox {
  
    title: "Серия "+titl
    property var tag: "right"
    
    Column {
    
  Param {
    id: pp1
    min: 0
    max: pcoef
    step: pcoefstep
    value: pcoef/10.0
    text: "Шаг"
    enableSliding: true
    property var enableScopeDuplicated: true
    textEnabled: true
    comboEnabled: false
  }
  
  
  Param {
    id: pp2
    min: 0
    max: 1
    step: 0.0001
    value: 0.5
    text: "Доля"
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
          varying float q2positionOZ;

          void main()
          {
            //qpositionOZ = mod( position.OZ, p1 );
            q2positionOZ = position.OZ;
          }
           "
  vertex: vertex_t.replace(/OZ/g,os);           

  fragmentOver: true // режим смешения с базовым цветом

  property var fragmenttempl: "
      uniform float sceneTime;
      varying float  q2positionOZ;
          uniform float p1;
          uniform float p2;      
                  void main()
                        {
                          if (mod( q2positionOZ,p1) / p1 > p2) discard;
                          
                          // подсветка краев сечений
                          #ifdef CLIP_EPS_HI
                          if (mod( q2positionOZ + CLIP_EPS_HI,p1) / p1 > p2 || mod( q2positionOZ,p1) < CLIP_EPS_HI)
                            gl_FragColor = vec4(0.0,0.0,0.0,1.0);
                          #endif
                          
            }
           "
  fragment: fragmenttempl.replace(/OZ/g,os);

}
