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
  
  property var tag: "right"
  
  
  property alias p1: pp1
 

  Param {
    id: pp1
    min: 0
    max: 1
    step: 0.01
    value: 0.2
    text: "Граница яркости"
    guid: "p1"
    enableSliding: true
    property var enableScopeDuplicated: true
  }

  fragmentOver: true

  fragment: "
          // your things
          uniform float sceneTime;
          uniform float p1;
          void main()
          {
#ifdef USE_COLOR
//#if (USE_COLOR+1)==2
          if (vColor.r <= p1 && vColor.g <= p1 && vColor.b <= p1) 
             discard;
//#endif
#endif
          }
        "
}
