Item {

    property var input_0: "not-overrided"
    property var input_1: undefined

    // тот кто использует эту компоненту должен объявить проперти input_0 - путь и input_1 - пейлоад

    property var file: {
      if (typeof(input_1) == "undefined") return input_0; // обычный способ загружать файл по путю
      // загружаем с пейлоадом через аякс пост
      return { path: input_0, payload: JSON.stringify( input_1 ) }
    }
    //////
  
    //property var file    // входной файл
    property var output  // загруженные данные
    property bool enabled: true
    property bool loading: false

    signal loaded( string loadedFile, string loadedOutput );
    
    property var q: {
      if (!file || !enabled) {
        output = "";
        return;
      }
      var f = file;
      loading = true;
      console.time( f ); // todo сделать такую штуку измерение вычислений.. для всех компонент.. интерфейс - инпуты изменились - засекаем
      loadFile( f, function(res) {
        //debugger;
        console.timeEnd( f );
        output = res;
        loading = false;
        loaded( f,res );
      }, function (err) {
        console.timeEnd( f );
        var res = "";
        // console.log(err);
        output = res;
        loading = false;
        loaded( f,res );

      } ); 
    }
    
    
///////////// patch

function file_on() {
  setTimeout( function() {
  qmlEngine.rootObject.propertyComputationPending = qmlEngine.rootObject.propertyComputationPending+1;
  }, 0);
}
function file_off() {
  setTimeout( function() {
  qmlEngine.rootObject.propertyComputationPending = qmlEngine.rootObject.propertyComputationPending-1;
  }, 0);
}
    
function loadFile( file_or_path, handler, errhandler ) {
    return loadFileBase( Qt.resolvedUrl(file_or_path), true, handler, errhandler );
}
function loadFileBinary( file_or_path, handler, errhandler ) {
    return loadFileBase( Qt.resolvedUrl(file_or_path), false, handler, errhandler );
}

function loadFileBase( file_or_path, istext, handler, errhandler ) {
    if (file_or_path instanceof File) {
        // http://www.html5rocks.com/en/tutorials/file/dndfiles/
        setFileProgress( file_or_path.name,"loading");
        file_on();

        var reader = new FileReader();

        window.setTimeout( function() {

            reader.onload = function () {
                //console.log(reader.result);
                setFileProgress( file_or_path.name,"parsing");
                window.setTimeout( function() {
                    try {
                      handler( reader.result, file_or_path.name );
                    } catch (err) {
                      console.error(err);
                      setFileProgress( file_or_path,"PARSE ERROR");
                      if (errhandler) errhandler(err,file_or_path);
                      file_off();
                      return;
                    }
                    setFileProgress( file_or_path.name );
                    file_off();
                },5 );

            };

            if (istext)
                reader.readAsText( file_or_path );
            else
                reader.readAsArrayBuffer( file_or_path );

        }, 5); //window.setTimeout

        var result = {};
        result.abort = function() { reader.abort(); setFileProgress( file_or_path.name ); file_off(); }
        return result;
    }
    else
    {
        if (file_or_path && file_or_path.content) {
          handler( file_or_path.content, "data" );
          return;
        }
        
        var payload;
        if (file_or_path && file_or_path.path) {
          payload = file_or_path.payload;
          file_or_path = file_or_path.path;
        }

        if (file_or_path && file_or_path.length > 0) {
            setFileProgress( file_or_path,"loading");
            file_on();

            var xhr = new XMLHttpRequest();
            //xhr.open('GET', file_or_path, true);
            // нет слов.. чтобы работало payload, надо слать с post
            xhr.open( payload ? 'POST' : 'GET', file_or_path, true);
            xhr.responseType = istext ? 'text' : 'arraybuffer';

            xhr.onload = function(e) {
                //console.log("xhr loadFileBase onload fired",file_or_path);            
                // response is unsigned 8 bit integer
                //var responseArray = new Uint8Array(this.response);
                setFileProgress( file_or_path,"parsing");
                file_off();
                handler( this.response, file_or_path );
                
                /* тяжело отлаживаться получается
                try {
                  handler( this.response, file_or_path );
                } catch (err) {
                  console.error(err);
                  setFileProgress( file_or_path,"PARSE ERROR");
                  if (errhandler) errhandler(err,file_or_path);
                  //throw err;
                  return;
                }*/

                setFileProgress( file_or_path );
            };

            xhr.onerror = function(e) {
                file_off();
                setFileProgress( file_or_path,"AJAX READ ERROR");
                setTimeout( function() {
                    setFileProgress( file_or_path );
                }, 25000 );
                console.log("xhr error. file_or_path=",file_or_path);
                if (errhandler) errhandler(e,file_or_path); // но вообще это спорно, то что мы передаем вторым параметром урль..
            }
            
            if (payload) {
              console.log("SENDING PAYLOAD",payload);
//              debugger;
              xhr.setRequestHeader("Content-Type", "application/json");
              xhr.send( payload );
            }
            else
              xhr.send();

            var result = {};
            result.abort = function() { xhr.abort(); setFileProgress( file_or_path ); file_off(); }
            return result;

                /* ранее вызывали по jquery так. но еще нужен был для arraybuffer
               https://github.com/henrya/js-jquery/blob/master/BinaryTransport/jquery.binarytransport.js
            // https://api.jquery.com/jquery.get/
            var jqxhr = jQuery.get( file_or_path, function(data) {
                setFileProgress( file_or_path,"parsing");
                handler(data);
                setFileProgress( file_or_path );
            }, istext ? "text" : "binary" );
            // надо указать явно datatype text, а то если будет json-файл то его нам уже пропарсят, что неожиданно для нас.
            jqxhr.fail(function() {
                setFileProgress( file_or_path,"AJAX READ ERROR",-5000 );
                setTimeout( function() {
                    setFileProgress( file_or_path );
                }, 5000 );
            });
            */
            
        }
        else
        {
            if (errhandler) errhandler(null,file_or_path);
        }

    }
} 
}