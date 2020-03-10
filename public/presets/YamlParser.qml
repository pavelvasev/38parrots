// Предназначение - дать функции парсинга йамла и его генерации. Ну и заодно вычислительной компонентой быть.
Item {

  // https://github.com/nodeca/js-yaml
  /*
  Embed {
    html: "<script src=\""+Qt.resolvedUrl("js-yaml.min.js") + "\"></script>"
    onHtmlChanged: console.log("embed html=",html );
  }
  */

  property var input: ""
  property var output: new Object({});
  
  onInputChanged: processInput()
  
  property var liburl: Qt.resolvedUrl("js-yaml.min.js")
  function processInput() {
    la_require( liburl, function() {
      output = compute( input );
    })
  }

  function compute( txt ) {
    var r = jsyaml.safeLoad( txt );
    console.log("YamlParser: res=",r);
    return r;
  }
  
  // обратная функция.. решил сюда же запихать
  function generate_yaml( obj,sorting ) {
    if (Object.keys(obj).length == 0) return "";
    var r = jsyaml.safeDump( obj, {'sortKeys' : sorting ? true : false, 'lineWidth': 200} );
    console.log("YamlParser: obj=",obj );
    console.log("YamlParser: generated txt=",r,typeof(r));
    //if (r == "{}") r = ""; // бред какой-то у них для пустых объектов
    return r;
  }
  
  Component.onCompleted: {
    la_require( liburl )
  }

}