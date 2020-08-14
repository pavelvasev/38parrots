Column {

  property var tag: "right"

  /* а чекбокс нам нужен потому что иногда надо на маленькое время эту штуку отключить */
  CheckBoxParam {
        text: "Накоплять"
        onValueChanged: setac( value<1 );
        value: 1
        width: 120
        guid: "on"
  }

  Component.onCompleted: setac( false )
  
  Component.onDestruction: setac( true )
  
  function setac(v) {
    renderer.autoClearColor = v;
    renderer.autoClearDepth = v;
  }
}