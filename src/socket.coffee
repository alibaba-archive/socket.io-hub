Socket = require('socket.io/lib/socket')
Hub = require('./hub')
_ = require('underscore')

Socket.prototype.$$emit = Socket.prototype.emit

Socket.prototype.subscribe = ->
  if Hub.adapterActive and not this.isSubscribed
    this.isSubscribed = true
    Hub.adapter.on (data) =>
      if this.needSubEmit(data)
        delete data.pid
        delete data.flags
        return this.$$emit.apply(this, _.toArray(data))

Socket.prototype.emit = (ev) ->
  if this.needAdapter()
    data = _.clone(arguments)
    data.pid = process.pid
    data.flags = this.flags
    Hub.adapter.pub(Hub.channel, data)
  return this.$$emit.apply(this, arguments)

Socket.prototype.needAdapter = ->
  if Hub.adapterActive
    return true
  else
    return false

Socket.prototype.needSubEmit = (data)->
  return false if process.pid == data.pid  # don't emit to self
  return true if data.flags.broadcast
  if data.flags.endpoint != ''
    room = data.flags.endpoint
    if this.manager.rooms[room]? and this.id in this.manager.rooms[room]  # room exist and socket in this room
      return true
  return false

exports = module.exports = Socket