// Предназначение - заведовать темой пресетов

Item {
  id: itm
  
  PresetsEditor {
    id: editor
    visible: itm.visible
  }

  PresetGuiGenerator {
    input: editor.value
    visible: itm.visible
  }
}