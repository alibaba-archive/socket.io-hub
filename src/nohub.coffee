Hub = require('./hub')

Nohub = ->
  return this until Hub.adapterActive
  return this