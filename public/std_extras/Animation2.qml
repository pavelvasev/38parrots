Column {
  id: main
  
  property var tag: "right"
  
  property var sceneMenu: menuManager.menu || []
  
  ComboBoxParam {
    id: film_src
    text: "Выбор фильма"
    guid: "film-track"
    values: sceneMenu.map( function(m,index) { return m ? m.title || m.id || index : "-" } )
    acombo.width: 200
  }
  
  ComboBoxParam {
    acombo.width: 200
    id: film_episode
    text: "Эпизод"
    guid: "film-episode"
    values: selectedMenu && selectedMenu.variants ? selectedMenu.variants.map( function(v) { return v.title } ) : []
    
    property bool mayreact: true
    onValueChanged: {
      if (mayreact)
        anim_p.value = value * 100; // ну покамест
    }
    property var pval: anim_p.value
    onPvalChanged: { 
      mayreact = false;
      value = Math.ceil( pval / 100 -0.1 );
      mayreact = true;
    }
    // здесь впервые применена практика qml-аспектов, когда у нас внедренный модуль сам встроился в систему
    // до этого обработка anim_p.value была в объекте параметра
  }

  Param {
    id: anim_p
    guid: "film-T"
    text: "Время в фильме (film-T)"
    min: player.mult.tmin
    max: player.mult.tmax
    step: player.mult.tstep
    onValueChanged: {
      player.t = value;
    }
  }
  
  Animation2Mult {
    id: player
  }

  property var stateMenu: sceneMenu[ film_src.value ] || {}
  property var selectedMenu: {}

  onStateMenuChanged: {
    var s = stateMenu;
    if (s != selectedMenu) {
      selectedMenu = s;
      player.input = menu2states( s );
    }
  }
  
  
  // вход - меню, выход - массив состояний
  function menu2states( selectedMenu ) {
    if (!selectedMenu) return [];
    if (!selectedMenu.variants) return [];
    console.log("film_src.value=",film_src.value );
    var states = selectedMenu.variants.map( function(v) { return v.params; } );
    return states;
  }
  
  property var stateManager: qmlEngine.rootObject.stateManager
  property var menuManager: qmlEngine.rootObject.menuManager

}