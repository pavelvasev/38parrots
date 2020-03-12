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
    input: editor.value
    visible: itm.visible
    stateManager: itm.stateManager
  }
}