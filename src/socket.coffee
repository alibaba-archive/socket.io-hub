Socket = require('socket.io/lib/socket')
Hub = require('./hub')
_ = require('underscore')

Socket.prototype.$$emit = Socket.prototype.emit

Socket.prototype.subscribe = ->
  if Hub.adapterActive and not this.isSubscribed
    this.isSubscribed = true
    Hub.adapter.on (data) =>
      this.namespace.name = data._namespace || ''
      if this.needSubEmit(data)
        delete data._pid
        delete data._flags
        delete data._namespace
        return this.$$emit.apply(this, _.toArray(data))

Socket.prototype.emit = (ev) ->
  if this.needAdapter()
    data = _.clone(arguments)
    data._pid = process.pid
    data._flags = this.flags
    Hub.adapter.pub(Hub.channel, data)
  return this.$$emit.apply(this, arguments)

Socket.prototype.needAdapter = ->
  if Hub.adapterActive
    return true
  else
    return false

Socket.prototype.needSubEmit = (data)->
  return false if process.pid == data._pid  # don't emit to self
  return true if data._flags.broadcast
  if data._flags.endpoint != ''
    namespace = data._namespace || ''
    cutLength = if namespace.length > 0 then namespace.length + 1 else 0
    room = data._flags.endpoint.substr(cutLength)
    if (this.manager.rooms[room]? and this.id in this.manager.rooms[room])
      return true
  return false

exports = module.exports = Socket