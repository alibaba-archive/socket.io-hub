Socket = require('socket.io/lib/socket')
adapter = null
adapterActive = false
adapters = ['redis']

Socket.hub = (options)->
  adapterName = options.adapter || 'redis'
  if adapterName not in adapters
    throw "adapter #{adapter} is not exist!"
  Adapter = require("./#{adapterName}-adapter")
  adapter = new Adapter(options)
  adapter.sub('socket.io.hub')
  adapterActive = true
  return this

Socket.prototype.subscribe = ->
  if adapterActive and not this.isSubscribe
    this.isSubscribe = true
    adapter.on (data) =>
      if this.id != data.socketId  # don't emit to self
        delete data.socketId
        console.log data
        return this.$emit.apply(this, data)

Socket.nohub = ->
  adapter.close()
  adapterActive = false
  return this

Socket.prototype.$emit = Socket.prototype.emit

Socket.prototype.emit = (ev) ->
  if adapterActive
    data = arguments
    data.socketId = this.id
    adapter.pub('socket.io.hub', data)
  return this.$emit.apply(this, arguments)

exports = module.exports = Socket