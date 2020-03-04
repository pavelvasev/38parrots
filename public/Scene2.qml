Scene {
  id: scena
  
//  Embed {
//    html: "<style> fieldset legend { color: #fff; } /*checkbox:*/ .ShaderConfig { color: #ddd; } /*params text*/  .ShaderConfig .Text span { color: #777 !important; } .GroupBox span { color: #fff !important; }</style>"
//  }
  Embed {
    html: "<style> fieldset legend { color: #fff; }</style>"
  }
  
  ColorParam {
    text: "Фон"
    tag: "rightbottom"
    property var tag_priority: 10
    id: bgcparam
    onColorChanged: { scena.backgroundColor = color; }
    //component.onCompleted
    color: [0.13,0.12,0.16] // зелененький [0.08,0.14,0.05] // [0.12,0.22,0.09]
    visible: scena.isRoot
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

  property var sceneconf: undefined
  
  Component.onCompleted: {
    if (window.location.hash.length < 10 && (sceneconf||"").length > 0) {
      window.location.hash = "#"+sceneconf;
    }
  }

  PresetsManager {
    id: pm
    visible: scene_obj.isRoot
  }
  
  signal windowHashToParams();
}