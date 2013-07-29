socketIo = require('socket.io')

socketIo.hub = require('./hub')

socketIo.nohub = require('./nohub')

module.exports = socketIo