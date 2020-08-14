Shader {
  id: shader1
  
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
  
  Param {
    id: pp1
    min: 0
    max: pcoef/100.0
    step: pcoefstep
    value: pcoef/500.0
    text: "Размер края"
    enableSliding: true
    property var enableScopeDuplicated: true
    textEnabled: true
    comboEnabled: false
  }

  fragmentOver: true // режим смешения с базовым цветом
  fragment: "#define CLIP_EPS_HI "+ addpt(pp1.value) + "\nvoid main()\n{\n}\n"
  
  // надо чтобы на флоат было похоже
  function addpt(v) {
    v = v.toString();
    if (v.indexOf(".") < 0) v = v + ".0";
    return v;
  }
}
