_ = require('underscore')

Hub = (options) ->
  this.socket = require('./socket')
  this.namespace = require('./namespace')
  adapterName = options.adapter or 'redis'
  if adapterName not in Hub.adapters
    throw "adapter #{adapterName} is not exist!"
  Adapter = require("./#{adapterName}-adapter")
  Hub.adapter = new Adapter(options)
  Hub.adapter.sub(Hub.channel)
  Hub.adapterActive = true
  return this

Hub.channel = 'socket.io.hub'

Hub.adapter = null

Hub.adapterActive = false

Hub.adapters = ['redis']

module.exports = Hub