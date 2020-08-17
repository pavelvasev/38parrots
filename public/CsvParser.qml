Item {

  property var input: ""
  property var output: new Object({});
  property var output_columns: []

  onInputChanged: processInput()

  function processInput() {
      var q = parse_csv( input );
      output_columns = q["colnames"]
      output = q; // последним, чтобы когда output то уже и columns как бы
  }

// вход - текст целиком и разделитель
// выход = хеш имя -> массив.
function parse_csv(data,separator) { // data is text blob
  var lines = data.split("\n"); 
  //console.log("lines=",lines.length)
/* ну вот что она делает.. ну парсит таблицу.. выдает массивчег.. из массивчегов.. ну хоть так для начала
   а дальше.. а дальше нам надо создать из этой штуки поле..
*/
   var trim1 = function (str) {
     return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
   }
   
   var splittrim = function( str,sep ) {
     return str.split( sep ).map( function(e) { return e.trim(); } );
   }

   var filter = function ( item ) {
     return parseFloat( item );
   }

   var skip="";
   // if (typeof(separator)=="undefined") separator="(\\s|,)";
   //if (typeof(separator)=="undefined") separator="[,;]"; // чето второй раз сепаратор в csv мне попался запятая )))
   if (typeof(separator)=="undefined") separator=","; // чето второй раз сепаратор в csv мне попался запятая )))

   var separator_rx = new RegExp( separator );
   console.log("using separator:",separator_rx );

   proj_names = splittrim( lines[0], separator_rx );
   var acc = [];

    for (var i=1; i<lines.length; i++) {
      var line = trim1( lines[i] );
      if (skip.length > 0 && line.indexOf(skip) >= 0) continue;

      if (line.length == 0) continue;

      //var s = line.split(/\s+/);

      // todo вытаскивать закавыченные данные надо уметь

      var attrs = splittrim(line,separator_rx).map( function(item) {
        // хотя.. может быть стоит сделать такую штуку, которая потом уже csv прочитанный таким методом оснащает данными (парсит)
        // float?
        if (/^[+-]?([0-9]*[.])?[0-9]+((e[+-]?\d+)?)$/.test(item)) // https://stackoverflow.com/questions/12643009/regular-expression-for-floating-point-numbers
          return parseFloat( item );
        // date?
        if (/^([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/.test(item)) // 2019-10-18
          return Date.parse( item );
        if (/^((0[1-9]|[12]\d|3[01])\/(0[1-9]|1[0-2])\/[12]\d{3})/.test(item)) { // 31/04/2015 - но это не обрабатывается date.parse, засим перевернем месяц и год для него, см ниже 
          // гребаные уроды
          var s = item.split("/");
          var s2 = s[1] + "/" + s[0] + "/" + s[2]; // в s[2] окажется и остаток
          return (Date.parse( s2 ) || item);
        }
        if (/^((0[1-9]|[12]\d|3[01])\.(0[1-9]|1[0-2])\.[12]\d{3})/.test(item)) { // 31.04.2015 - но это не обрабатывается date.parse, засим перевернем месяц и год для него, см ниже 
          var s = item.split(".");
          var s2 = s[1] + "/" + s[0] + "/" + s[2]; // в s[2] окажется и остаток
          return (Date.parse( s2 ) || item);
        }        
        return item;
      } );

      for (var j=0; j<attrs.length; j++) {
        acc[j] = acc[j] || [];
        acc[j].push( attrs[j] );
      }
    }
      
    var res = {};
    for (var j=0; j<proj_names.length; j++)
      res[ proj_names[j] ] = acc[j];
    // ну кстати оно тут порядок не сохраняет.. а мы (ну Миша) его любим..
    res[ "colnames" ] = proj_names;
    
    //console.log("csv parse res=",res );

    //output = revert ? acc.reverse() : acc; -- оставим в качестве памятника тупости некомпозиционности
    return res;
    
    // todo позаниматься загрузкой во флоаты 
    // https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/from
    // https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/Float32Array
}

}