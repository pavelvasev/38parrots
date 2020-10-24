// Предназначение - заведовать темой пресетов

Item {
  id: itm
  
  property var stateManager
  
  PresetsEditor {
    id: editor
    visible: itm.visible
    stateManager: itm.stateManager
  }

  PresetGuiGenerator {
    input: editor.output
    visible: itm.visible
    stateManager: itm.stateManager
    onMenuClicked: editor.editMenu( index )
  }
  
  property alias menu: editor.output
}