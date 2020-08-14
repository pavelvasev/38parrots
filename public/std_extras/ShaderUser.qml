Shader {
  id: shader1
  
  property var titl: "1"

  property var input_1: timevalue
  property var input_0: cliprange // опирается получается на кого-то сверху, ибо у нас биндинги недоделанные в Loader
  
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
  
  property var tag: "right"


  Param {
    id: pp1
    min: -pcoef
    max: pcoef
    step: 10
    value: -pcoef
    text: "p1"
    enableSliding: true
    property var enableScopeDuplicated: true
  }
  

  Param {
    id: pp2
    min: 0
    max: 1
    step: 0.01
    value: 1
    text: "p2"
    enableSliding: true    
    property var enableScopeDuplicated: true

  }

  vertex: "
          uniform float sceneTime; // счетчик времени сцены, всегда растет
          uniform float input_0; // размер объекта по z
          uniform float input_1; // номер множества (суть время T)          
          uniform float p1; // параметр 1, -zmax..+zmax
          uniform float p2; // параметр 2, 0..1
          
          varying vec3  my_q; // результат работы шейдера - переменная вида varying
          
          void main()
          {
            gl_Position.z += input_1 * p1;
            my_q = position.xyz;
          }
           "
                        
  fragment: "
          uniform float sceneTime; // счетчик времени сцены, всегда растет
          uniform float input_0; // размер объекта по z
          uniform float input_1; // номер множества (суть время T)          
          uniform float p1; // параметр 1, -zmax..+zmax
          uniform float p2; // параметр 2, 0..1
          
          varying vec3  my_q; // результат работы шейдера вершин
          void main()
          {
            //if (mod( my_q.z,p1) / p1 < p2) gl_FragColor.r = 1.0;
          }
         "
}
