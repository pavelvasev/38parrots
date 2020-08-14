Shader {
  id: shader1
  
  property var titl: "1"
  
  property var input_1: timevalue
  property var input_0: cliprange // опирается получается на кого-то сверху, ибо у нас биндинги недоделанные в Loader

  property var output: shader1
  
  property var tag: "right"
  
  property var orbitControl: shader1.scene.cameraControlC.sceneControl
  
  Param {
        min: -1
        max: 360
        text: "Поворот тета"
        guid: "cam_theta"
        id: ptheta
        onValueChanged: {
          if (!orbitControl) return;
          orbitControl.manualTheta = value < 0 ? undefined : 2*Math.PI * value / 360.0;
          orbitControl.update();
        }
      }
      
      Param {
        min: -1
        max: 1
        step: 0.1
        value: 0.1
        id: pauto
        text: "Авто-поворот"
        guid: "cam_auto_inc"
        textEnabled: true
        comboEnabled: false
      }
      
      Button {
        text: "Стоп"
        onClicked: pauto.value = 0;
      }
  
  property var iControl: false
  RenderTick {
    enabled: pauto.value != 0 && orbitControl
    onEnabledChanged: if (orbitControl) orbitControl.manualTheta = enabled ? 0.0 : undefined;
    onAction: {
      if (!orbitControl) return;

      shader1.thisIsIchanging = true;
      ptheta.value = ((ptheta.value + pauto.value) % 360 + 360)%360;
      shader1.thisIsIchanging = false;
    }
  }

}
