Socket = require('socket.io/lib/socket')
adapter = null
adapterActive = false
adapters = ['redis']
_ = require('underscore')

Socket.prototype.$$emit = Socket.prototype.emit

Socket.hub = (options)->
  adapterName = options.adapter or 'redis'
  if adapterName not in adapters
    throw "adapter #{adapter} is not exist!"
  Adapter = require("./#{adapterName}-adapter")
  adapter = new Adapter(options)
  adapter.sub('socket.io.hub')
  adapterActive = true
  return this

Socket.nohub = ->
  adapter.close()
  adapterActive = false
  return this

Socket.prototype.subscribe = ->
  if adapterActive and not this.isSubscribed
    this.isSubscribed = true
    adapter.on (data) =>
      if process.pid != data.pid  # don't emit to self
        delete data.pid
        return this.$$emit.apply(this, _.toArray(data))

Socket.prototype.emit = (ev) ->
  if this.needAdapter()
    data = _.clone(arguments)
    data.pid = process.pid
    adapter.pub('socket.io.hub', data)
  return this.$$emit.apply(this, arguments)

Socket.prototype.needAdapter = ->
  if adapterActive and this.flags.broadcast
    return true
  return false

exports = module.exports = Socket