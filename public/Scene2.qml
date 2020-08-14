Scene {
  id: scena
  
//  Embed {
//    html: "<style> fieldset legend { color: #fff; } /*checkbox:*/ .ShaderConfig { color: #ddd; } /*params text*/  .ShaderConfig .Text span { color: #777 !important; } .GroupBox span { color: #fff !important; }</style>"
//  }
  Embed {
    html: "<style> 
        #infoDark, fieldset legend {
          color: #fff;  mix-blend-mode: difference;
        }
        .CheckBoxParam {
          color: #000;
        }
    </style>"
  }
  
  ColorParam {
    text: "Фон"
    tag: "rightbottom"
    property var tag_priority: 10
    id: bgcparam
    onColorChanged: { 
      if (visible && parent && scena.isRoot) { // хакобаг двойной - проверка на parent и дублирование scena.isRoot.. иначе qmlweb не досчитывает - можно повыяснять почему
        // console.log("SETTING BG COLOR",color,scena.isRoot);
        scena.backgroundColor = color; 
      }
    }
    onParentChanged: colorChanged()
    //component.onCompleted
    color: [0.13,0.12,0.16] // зелененький [0.08,0.14,0.05] // [0.12,0.22,0.09]
    visible: (scena.isRoot === true)
  }
  
/* не работает чето tag-priority
  Text {
    property var tag: "right"
    text: "qq\nqq"
    property var tag_priority: +5
  }
  */

/* не работает что-то подключение оного (без указания obj_0.)
  function combine_arrays() {
    // ну упаковка.. дали набор одномерных массивов - выдай из них сборку, один массив во viewlang-упаковке
    // todo можно сделать ускоренную версию для 3х входов - var arr1=arguments[0]; и т.д.
    var acc = [];
    var len1 = arguments[0].length;
    for (var line=0; line<len1; line++)
      for (var i=0; i<arguments.length; i++)
        acc.push( arguments[i][line] );
    return acc;
  }
*/  

  PresetsManager {
    id: pm
    visible: scene_obj.isRoot
    stateManager: psm
  }
  
  signal windowHashToParams();
  signal setParamValues( object params );
  
  property alias stateManager: psm
  StateManager {
    id: psm
  }
  property var sceneconf: undefined
  
  ////
  property var textLoaderIterations: 0
}