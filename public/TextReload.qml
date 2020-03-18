TextButton {
  id: reload_btn
  text: "Прочитать повторно"
  onClicked: { var r = findRootScene(reload_btn); r.textLoaderIterations = r.textLoaderIterations+1; }
  property var tag: "left"
}
