socketIo = require('socket.io')
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

io = socketIo.listen(server)

io.sockets.on 'connection', (socket) ->
  socket.volatile.emit('news', "Socket Connect")
  socket.on 'chat', (data) ->
    socket.emit('news', data)

server.listen(port)
console.log "server listen on #{port}"