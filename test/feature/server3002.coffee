socketIo = require('../../lib/socket.io-hub')
http = require('http')
port = 3002

server = http.createServer (req, res) ->
  res.end('<script src="/socket.io/socket.io.js"></script>
    <script>
      var socket = io.connect("http://localhost:' + port + '");
      socket.on("news", function (data) {
        console.log(data);
        socket.emit("chat", { my: "data" });
      });
    </script>')

io = socketIo.hub({
  adapter: 'redis'
  }).listen(server)

io.sockets.on 'connection', (socket) ->
  socket.subscribe()
  socket.emit('news', {hello: 'world'})
  socket.on 'chat', (data) ->
    console.log data

server.listen(port)
console.log "server listen on #{port}"
