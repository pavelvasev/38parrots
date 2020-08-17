Shader {
  id: shader1
  
  property var input_0: cliprange

  property var output: shader1
  
  property alias p1: pp1
  
  property var tag: "right"
  
  function copyScales(sca) {
    return;
    
    var s = sca || pp1.value;
    
    var objs = objects;
    for (var i=0; i<objs.length; i++) {
      objs[i].scale = s;
      //console.log("copied scale s",s,"to obj",objs[i]);
    }
  }
  
  onObjectsChanged: copyScales();
  
  Param {
    id: pp1
    min: 0.0001
    max: 5
    step: 0.01
    value: 1
    text: "Масштаб"
    enableSliding: true
    comboEnabled: false
    textEnabled: true
    property var enableScopeDuplicated: true
    onValueChanged: copyScales();
  }
  
  
  Button {
    text: "Подобрать масштаб"
    width: 160
    onClicked: {
      pp1.value = 50.0/input_0;
      copyScales();
      console.log("used input_0",input_0);
    }
  }
  
  property var vertex: "
          // your things
          uniform float sceneTime;
          uniform float p1;

          void main()
          {
            gl_Position.x = gl_Position.x *p1;
            gl_Position.y = gl_Position.y *p1;
            gl_Position.z = gl_Position.z *p1;
          }
        "


}
