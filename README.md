socket.io-hub
=============
Scalable Socket.IO

## WARNING!!!

Socket.io is supporting multiple process deployment now, so you should not use this plugin anymore!

Please checkout [this article](https://github.com/LearnBoost/Socket.IO/wiki/Configuring-Socket.IO) and try the offical `RedisStore` model from socket.io.

Also, we appreciate your enthusiasm!

## Installation

`npm install https://github.com/teambition/socket.io-hub`

## Overview

Socket.io is a great middleware to build in-time applications, but it only can run in a single process. So we write this wrapper to support multiprocess applications.

Every node process will create two redis instance and we use redis pub/sub for message exchange.

When socket.io emit an event, we publish data of this event to redis and other processes will catch this event and emit to their own clients.

## Events:

* broadcast.emit
* in(room).emit
* of(/namespace).emit

## options

Options are used for `hub` function, they are all optional, so feel free to try them:

* adapter: redis  # hub adapter, for this moment it only supports redis, and it is the prefered one
* config: {host: '127.0.0.1', port: '6379'}  # redis configurations
* salt: 'some string'  # when use salt, socket.io-hub will add _sign in published messages.

## Usage

Usually we create a simple http server and add socket.io support:

```
socketIo = require('socket.io')
http = require('http')
server = http.createServer (req, res) ->
  res.end('Hello, world!')
io = socketIo.listen(server)
io.sockets.on 'connection', (socket) ->
  socket.emit('news', "new coming")
  socket.on 'chat', (data) ->
    console.log data
server.listen(3000)
console.log "server listen on 3000"
```

To use socket.io-hub, all we need is add two line on the above code:

```
socketIo = require('socket.io-hub')  # replace socket.io with socket.io-hub
http = require('http')
server = http.createServer (req, res) ->
  res.end('Hello, world!')
io = socketIo.hub({adapter: 'redis'}).listen(server)  # add hub adapter, for this moment it only supports redis
io.sockets.on 'connection', (socket) ->
  socket.subscribe()  # add subscribe to emit events from redis
  socket.emit('news', "new coming")
  socket.on 'chat', (data) ->
    console.log data
server.listen(3000)
console.log "server listen on 3000"
```

Done!

## License

MIT