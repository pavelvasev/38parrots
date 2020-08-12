// Предназначение - добавка, которая разрешает послойные добавки
Item {
  property var eb

  Component.onCompleted: {
    eb.enableAll = true;
  }
  Component.onDestruction: {
    eb.enableAll = false;
  }
  
}