var WebSocketServer = new require('ws');

// подключённые клиенты
var clients = {};

var webSocketServer = new WebSocketServer.Server({
  port: 5555
});
console.log( "started server",webSocketServer );

webSocketServer.on('connection', function(ws) {

  var id = Math.random();
  clients[id] = ws;
  console.log("новое соединение " + id);

  ws.on('close', function() {
    console.log('соединение закрыто ' + id);
    delete clients[id];
  });

});


var i=0;
function broadcast() {
  i = i+1;
  var msg = "X,Y,Z,X2,Y2,Z2";
  for (var j=0; j<15; j++) {
    var angle = Math.PI * i/360.0;
    var r = 5;
    var x = r*Math.cos( angle );
    var y = r*Math.sin( angle );
    var line = [x.toString(),y.toString(),0,0,0,0].join(",");
    msg = msg + "\n" + line;
  }
  
  for (var key in clients) {
    clients[key].send(msg);
  }
}

setInterval( broadcast, 10 );