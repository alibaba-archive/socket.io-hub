_ = require('underscore')

hub = (options) ->
  socketIo = _.clone(this)
  this.socket = require('./socket')
  this.socket.hub(options)
  return this

module.exports = hub