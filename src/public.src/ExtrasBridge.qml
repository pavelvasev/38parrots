// Предназначение: следить за загружаемыми cinema-views и отключать им свои добавки,
//   а затем позволять их включать если пользователь выберет.
Item {
  id: eb
  property var cinemaViews
  property var masterExtrasManager
  //: findRootScene(cv).local_extras_manager
  
  function onviewloaded( view ) 
  {
    // console.log( "EMM: onviewloaded",view.text );
    view.external_extras_manager = masterExtrasManager;
    view.local_extras_manager.enabled = enableAll;
    view.local_extras_manager.visible = enableAll;
  }
  
  onCinemaViewsChanged: {
    cinemaViews.viewLoaded.connect( onviewloaded )
  }
  
  onMasterExtrasManagerChanged: {
    masterExtrasManager.input_api.push( ["Послойные добавки", "EnableViewsExtras",{eb: eb}] )
  }
  property bool enableAll: false
  onEnableAllChanged: {
    console.log("enableAll changed:",enableAll);
    var views = cinemaViews.views;
    for (var i=0; i<views.length; i++) {
      var view = views[i];
      onviewloaded( view );
    }
  }

}