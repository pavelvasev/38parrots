/*
  Вписыватель в заданные габариты.
  
  Идея - вписать исходный объект в коробочку заданных габаритов

  Вход:
    * размеры коробочки по осям bx,by,bz
    * по идее - объект для анализа... ну можно всех конечно, но это будет странно
    если там появятся доп-точки которые дают вылет и типа все уменьшится?
    
  Алгоритм
    * анализировать текущие габариты threejs, при этом довольно часто это надо делать
    (либо следить за обновлениями геометрий)
    и вычитывать коффэффициенты сдвига и масштаба

  Мысли
    * формально дальше надо управлять модулями сдвиг и масштаб. ну а чего дублировать то..
    * так то это сервис. ну а что, нам так удобно
    
  TODO
    * разобраься с наблюдаемым объектом и уже ловить изменение его геометрии
    и тогда будет все просто и понятно, можно даже boundingbox самим рассчитывать
    для этого требуется - уметь видеть перечень объектов viewlang-а..

*/

Shader {
  id: shader1
  
  property var input_0: 10000
  property var output: shader1
  
  // сдвиг
  property var ax: 0
  property var ay: 0
  property var az: 0
  // масштаб
  property var cx: 1
  property var cy: 1
  property var cz: 1
  
  property var tag: "left"
  
  function getClipRangeFromThreeJs2() {

    var trylocate = function (tp) {
    for (var i=0; i<threejs.scene.children.length; i++) {
      //var c = scene.children[scene.children.length -1 - i];
      var c = threejs.scene.children[i];
      if (c.qmlParent && c.qmlParent.iAxis) continue;

      if (c.type == tp) return c;
    }
    }
    
      // хак на хаке сидит и хаком погоняет.
      // найдем первое хоть что-нибудь    
    var objToAnalyze = trylocate("Mesh") ||  trylocate("LineSegments") || trylocate("Points");
//    console.log("gg:",objToAnalyze);
    
    if (objToAnalyze && objToAnalyze.geometry && objToAnalyze.geometry.boundingSphere) {
        var s = objToAnalyze.geometry.boundingSphere;
//        console.log("found s=",s);
        ax = -s.center.x;
        ay = -s.center.y;
        az = -s.center.z;
        // вот так зло и работает. нас qml прямо приглашает писать в глобальные переменные..
        // но с другой стороны а кто в них должен писать?..
        // cx = s.radius;
        // с радиусом непонятно.. кривенько.. надо boundingbox по уму.. ну ладно покамест..
        if (pp1.value > 0) cx =  pp1.value / s.radius; else cx=1;
        if (pp2.value > 0) cy =  pp2.value / s.radius; else cy=1;
        if (pp3.value > 0) cz =  pp3.value / s.radius; else cz=1;
      }
  }

  Timer {
    interval: 100 // по идее надо ловить изменение геометрии наблюдаемого объекта
    //running: true
    repeat: true
    onTriggered: getClipRangeFromThreeJs2()
    id: timer
  }
  Component.onCompleted: timer.start();

  

      Param {
        id: pp1
        min: 0
        max: 100
        step: 10
        value: 50
        text: "x-size"
        enableSliding: true
        comboEnabled: false
        textEnabled: true
        property var enableScopeDuplicated: true
      }
      
      Param {
        id: pp2
        min: 0
        max: 100
        step: 10
        value: 50
        text: "y-size"
        enableSliding: true
        comboEnabled: false
        textEnabled: true
        property var enableScopeDuplicated: true
      }
      
      Param {
        id: pp3
        min: 0
        max: 100
        step: 10
        value: 50
        text: "z-size"
        enableSliding: true
        comboEnabled: false
        textEnabled: true
        property var enableScopeDuplicated: true
      }
      
/*      
      ComboBoxParam {
        id: ppObj
        text: "object"
        values: ["1","2","3"]
        property var enableScopeDuplicated: true
      }
*/


  property var vertex: "
          // your things
          uniform float sceneTime;
          uniform float ax;
          uniform float ay;
          uniform float az;
          uniform float cx;
          uniform float cy;
          uniform float cz;
          
          void main()
          {
            gl_Position.x = (gl_Position.x+ax) *cx;
            gl_Position.y = (gl_Position.y+ay) *cy;
            gl_Position.z = (gl_Position.z+az) *cz;
          }
        "
}
