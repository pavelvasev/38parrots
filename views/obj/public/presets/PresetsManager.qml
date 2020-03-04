// Предназначение - заведовать темой пресетов
// Возможно стоит разделить на РедакторПресетов и ПоказывательПресетов.
// по крайней мере так оно содержит теперь сейчас. И потом еще загрузчик пресетов будет.
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