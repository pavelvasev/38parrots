Shader {
  id: shader1
  
  property var titl: "1"
  
  property var input_1: timevalue
  property var input_0: cliprange // опирается получается на кого-то сверху, ибо у нас биндинги недоделанные в Loader

  property var output: shader1
  
  property var tag: "right"
  
  property var orbitControl: shader1.scene.cameraControlC.sceneControl
  
  GroupBox {
  
    title: "Камера"
    property var tag: "right"
    
    Column {
      Button {
        text: "Посмотреть на объект"
        width: 180
        onClicked: {
          console.log("CameraLook: objects=",shader1.objects );
          var c = shader1.objects[0].sceneObject.geometry.boundingSphere.center;
          var sk = shader1.objects[0].scale;
          var s = shader1.scene;
          console.log("CameraLook: using center",c);
          s.cameraCenter = [ c.x *sk, c.y *sk, c.z *sk ];
          //console.log("scene is",s);
          //console.log("cc is ",s.cameraControlC );
          //console.log("ccc is ",s.cameraCenter );
          
          //console.log("assigned",scene,scene.cameraCenter);
          //scene.cameraControlC.centerPoint = c;
          //cameraCenter
        }
      }

    } // col
  
  } //grp
  

}
