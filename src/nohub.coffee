Hub = require('./hub')

Nohub = ->
  return this until Hub.adapterActive and Hub.adapter?
  adapter = Hub.adapter
  adapter.close()
  Hub.adapter = null
  Hub.adapterActive = false
  return this

module.exports = Nohub