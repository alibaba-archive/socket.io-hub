socketIo = require('socket.io')
RedisStore = require('socket.io/lib/stores/redis')
redis  = require('socket.io/node_modules/redis')
pub    = redis.createClient()
sub    = redis.createClient()
client = redis.createClient()
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

io.set('store', new RedisStore({
  redisPub : pub
, redisSub : sub
, redisClient : client
}))

io.sockets.on 'connection', (socket) ->
  socket.broadcast.emit('news', 'I am coming')
  socket.on 'chat', (data) ->
    socket.emit('news', data)

server.listen(port)
console.log "server listen on #{port}"