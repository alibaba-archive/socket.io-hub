SocketNamespace = require('socket.io/lib/namespace')
Hub = require('./hub')
_ = require('underscore')

SocketNamespace.prototype.$$emit = SocketNamespace.prototype.emit

SocketNamespace.prototype.emit = ->
  if this.needAdapter()
    data = _.clone(arguments)
    data._pid = process.pid
    data._flags = this.flags
    data._namespace = this.name if this.name != ''
    Hub.adapter.pub(Hub.channel, data)
  return this.$$emit.apply(this, arguments)

SocketNamespace.prototype.needAdapter = ->
  if Hub.adapterActive
    return true
  else
    return false