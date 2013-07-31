# socketIo = require('../../src/socket.io-hub')
socketIo = require('socket.io')
RedisStore = require('socket.io/lib/stores/redis')
redis  = require('socket.io/node_modules/redis')
pub    = redis.createClient()
sub    = redis.createClient()
client = redis.createClient()
http = require('http')
port = process.argv[2] || 3000
rooms = ['a', 'b']

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

io.set('store', new RedisStore({
  redisPub : pub
, redisSub : sub
, redisClient : client
}))

io.sockets.on 'connection', (socket) ->
  # socket.subscribe()
  room = rooms[Math.floor(Math.random()*2)]
  socket.join(room)
  socket.emit('news', "join room #{room}")
  socket.on 'chat', (data) ->
    socket.emit('news', data)
  setInterval (->
    io.sockets.in(room).emit('news', "room notice from room #{room} of #{port}")
    ), 5000
  # setTimeout (->
  #   socket.broadcast.emit('news', "hub closed of #{port}")
  #   socketIo.nohub()
  #   ), 15000

server.listen(port)
console.log "server listen on #{port}"