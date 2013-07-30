socketIo = require('../../src/socket.io-hub')
http = require('http')
port = process.argv[2] || 3000

server = http.createServer (req, res) ->
  res.end('<script src="/socket.io/socket.io.js"></script>
    <script src="http://code.jquery.com/jquery-2.0.3.min.js"></script>
    <script>
      var socket = io.connect("http://localhost:' + port + '");
      $(document).ready(function() {
        $("body").append("' + process.pid + '<hr/>");
          socket.on("news", function (data) {
            $("body").append("<li>" + data + "</li>");
          });
        });
    </script>')

io = socketIo.hub({
  adapter: 'redis'
  }).listen(server)

io.sockets.on 'connection', (socket) ->
  socket.subscribe()
  socket.broadcast.emit('news', 'I am coming')
  socket.on 'chat', (data) ->
    console.log data

server.listen(port)
console.log "server listen on #{port}"