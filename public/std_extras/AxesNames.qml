SimpleDialog {
  id: proc

  property var tag: "other"
  
  function update() {
    var s = findRootScene( proc );
    s.axes.titles = [namx.value, namy.value, namz.value]
  }
  
  height: col.height+40

  Column {
      id: col

      TextParam {
        text: "X"
        value: "X"
        id: namx
        onValueChanged: proc.update()
        tag: undefined
      }
      TextParam {
        text: "Y"
        value: "Y"
        id: namy
        onValueChanged: proc.update()
        tag: undefined        
      }      
      TextParam {
        text: "Z"
        value: "Z"
        id: namz
        onValueChanged: proc.update()
        tag: undefined        
      }      

  } // col

}
