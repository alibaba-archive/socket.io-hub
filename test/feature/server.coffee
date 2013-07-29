socketIo = require('../../src/socket.io-hub')
http = require('http')

server = http.createServer (req, res) ->
  res.end('<script src="/socket.io/socket.io.js"></script>
    <script>
      var socket = io.connect("http://localhost:3000");
      socket.on("news", function (data) {
        console.log(data);
        socket.emit("chat", { my: "data" });
      });
    </script>')

io = socketIo.hub({
  adapter: 'redis'
  }).listen(server)

# console.log io
# process.exit()

io.sockets.on 'connection', (socket) ->
  socket.emit('news', {hello: 'world'})
  socket.on 'chat', (data) ->
    console.log data

server.listen(3000)
console.log "server listen on 3000"
