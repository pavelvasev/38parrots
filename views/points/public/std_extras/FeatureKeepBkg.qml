Column {

  property var tag: "right"
  //width: parent.width
  //width: 200
  //anchors.right: parent.right
  
  GroupBox {

    title: "Накоплять фон"
    //width: parent.width
    width: 200
    
    Column {
    
      /* вроде как кнопка эта не нужна, можно чекбокс два раза тыркнуть
      
      Button {
        text: "Очистить"
        onClicked: renderer.clear()
      }
      */
      /* а чекбокс нам нужен потому что иногда надо на маленькое время эту штуку отключить */
      CheckBoxParam {
        text: "Накоплять"
        onValueChanged: setac( value<1 );
        value: 1
        width: 120
        guid: "on"
      }
    }
  }

  Component.onCompleted: setac( false )
  
  Component.onDestruction: setac( true )
  
  function setac(v) {
    renderer.autoClearColor = v;
    renderer.autoClearDepth = v;
  }
}