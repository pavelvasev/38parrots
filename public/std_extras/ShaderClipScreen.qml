Shader {
  id: shader1
  
  property var os: "z"
  property var titl: "к экрану"
  
  property var input_0: cliprange // опирается получается на кого-то сверху, ибо у нас биндинги недоделанные в Loader
  
  property var output: shader1
  
  property var pcoef: 1000 // делал 200 ерунда выходит
  property alias p1: pp1
  property alias p2: pp2
  
  property var tag: "right"
  
  property var pcoefstep: pcoef > 1000 ? 10 : (pcoef > 100 ? 1 : 0.1)
//  onPcoefstepChanged: console.log("ShaderClip: pcoefstep=",pcoefstep);
    
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


  property var vertex_t: "
          // your things
          uniform float sceneTime;
          uniform float p1;
          uniform float p2;
          varying vec4  sqpositionOZ;
          
          void main()
          {
            sqpositionOZ = modelViewMatrix * gl_Position;
          }
           "
  vertex: vertex_t.replace(/OZ/g,os);           
                        
  fragmentOver: true // режим смешения с базовым цветом

  property var fragmenttempl: "
      uniform float sceneTime;
      varying vec4  sqpositionOZ;
          uniform float p1;
          uniform float p2;
                  void main()
                        {
                          if (sqpositionOZ.OZ < p1) discard;
                          //if (qpositionOZ.OZ > p1+p2) discard;
                          if (sqpositionOZ.OZ > p1+p2) 
                            discard;
                            
                          // подсветка краев сечений
                          #ifdef CLIP_EPS_HI
                          if (sqpositionOZ.OZ-CLIP_EPS_HI/20.0 < p1 || sqpositionOZ.OZ+CLIP_EPS_HI/20.0 > p1+p2)
                            gl_FragColor = vec4(0.0,0.0,0.0,1.0);
                          #endif
                            
                            //gl_FragColor = vec4(1.0,0.0,0.0,0.1);;
                            //gl_FragColor.a = 0.2;
                            //gl_FragColor = vec4(1.0,0.0,1.0,1.0);;
            }
           "
  fragment: fragmenttempl.replace(/OZ/g,os);
                        
}
