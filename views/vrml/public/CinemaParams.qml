/*
  Предназначение
  По входному значению синема-базы (т.е. csv-файла, поле input - js-хеш с полем colnames)
  1. Построить графические элементы управления - параметры.
  2. Выдать перечень артефактов для загрузки:
     2.1 имена колонок
     2.2 значения из колонок артефактов
  
*/

GroupBox {
  id: cp
  
  property var tag: "left"
  title: "Параметры"
  
  property var input: { 
    return { 'colnames' : [] }
  }
  
  property var artefact_col_names: cp.artefact_names
  property var artefacts: find_possible_values( cp.param_names.length, cp.selected_param_values, cp.dict )
  
  property var output: {
    return { 'artefact_col_names' : cp.artefact_col_names, 'artefacts' : cp.artefacts };
    // так то в аутпут можно и строчку параметров-значений напихать для прикола
  }
  property var val: output
  
  // хеш имяпараметра -> значение
  property var param_values: gather_with_names( parcol )
  
  // также доступны: param_names
    
  ////////////////////////////////
  property var col_names: input && input['colnames'] ? input['colnames'] : []
  
  property var param_names: filter_p( col_names )
  function filter_p( names ) {
    return names.filter( function(name) { return !name.match(/^FILE_/) } )
  }
  
  property var artefact_names: filter_a( col_names )
  function filter_a( names ) {
    return names.filter( function(name) { return name.match(/^FILE_/) } )
  }
    
  Column {
    id: parcol
    Repeater {
      model: param_names.length
      Param {
        text: param_names[index]
        values: find_possible_values( index, cp.selected_param_values, cp.dict )
        property var val: values[ value ]
        //Component.onCompleted: console.log("cinema param completed",text );
        property bool animationPriority: true
        enableSliding: false
      }
    }
  }
  
  property var selected_param_values: gather(parcol)
  function gather( id ) {
    var cc=id.children.filter( function(i) { return i.$properties['val'] ? true : false; })
    var vals = cc.map( function(i) { return i.val } );
    return vals;
  }
  function gather_with_names( id ) {
    var res = {};
    var cc=id.children.filter( function(i) { return i.$properties['val'] ? true : false; })
    cc.forEach( function(i) { res[ i.text ] = i.val } );
    return res;
  }  
  
  // возвращает массив значений, соответствующих i-му параметру при условии текущих выбранных параметров current_values (анализируются 0..i-ый)
  function find_possible_values( i, current_values, datadict ) {
    //debugger;
    var cur = datadict;
    for (var u=0; u<i; u++) {
      if (!cur) return [];
      var i_param_value = current_values[ u ];
      cur = cur[ i_param_value ];
    }
    if (!cur) return []; // тут должны были быть артефакты но - чето нету
    if (Array.isArray( cur )) return cur; // это значит уже - артефакты (ну должны быть)
    // теперь cur это dict для нашего текущего параметра
    var param_values = Object.keys(cur).sort();
    return param_values;
  }

  /*
  Построим индекс на данных.
  Запись индекса это такой хеш: dict = { value1 => subdict1, value2 => subdict, ... }
  
  Задача функции add_to_dict это вписать в словарь dict новое значение из line_of_values[i]. При этом такое значение уже может быть в словаре, а может не быть/
  И сообразно передать этот запрос рекурсивно дальше.
  */
  function add_to_dict( line_of_values, i, artefact_start_index, subdict )
  {
    if (i >= artefact_start_index) return line_of_values.slice( artefact_start_index ); // на последних параметрах будем возвращать перечень адресов артефактов
    
    var val = line_of_values[i];
    
    if (subdict.hasOwnProperty( val )) { // значение уже есть в нашем словаре - перейдем к нему и попросим добавить суб-значения в суб-словарь
      add_to_dict( line_of_values, i+1, artefact_start_index, subdict[val] );
    }
    else
    {  // значений еще нет - создадим новую запись и перейдем заполнению суб-словаря
      subdict[val] = add_to_dict( line_of_values,i+1, artefact_start_index, new Object() );
    }
    return subdict;
  }
  
  function create_dict( csv ) {
    var param_names = filter_p( csv.colnames );
    var dict = new Object();
    if (param_names.length == 0 || param_names[0].length == 0) {
       console.log("CinemaParams::create_dict: param_names is blank, probably csv is not loaded yet" );
       return dict;
    }
    var first_param_col = csv[ param_names[0] ];
    if (!first_param_col) {
      console.error("your csv may have errors. dont see first param col csv=",csv );
      return dict;
    }
    var artefact_start_index = param_names.length; // вот так наивно

    for (var i=0; i<first_param_col.length; i++) {
      var line = [];
      for (var j=0; j<csv.colnames.length; j++)
        line.push( csv[ csv.colnames[j] ][i] );

      add_to_dict( line, 0, artefact_start_index, dict );
    }
    return dict;
  }
  
  property var dict: create_dict( input )
  
//  onParam_namesChanged: console.log("pp=",param_names);
//  onInputChanged: console.log("input=",input);
//  onCol_namesChanged: console.log("cn=",col_names);
  
  onDictChanged: console.log("dict=",dict );
  onArtefactsChanged: console.log("arte=",artefacts );
}