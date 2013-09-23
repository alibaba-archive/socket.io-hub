redis = require('redis')
crypto = require('crypto')
sha1 = (str)->
  crypto.createHash('sha1').update(str.toString()).digest('hex')

class RedisAdapter

  constructor: (options) ->
    @options = options
    config = options.config || null
    # sub and pub command should not both exist in one client
    @redisPubClient = redis.createClient(config)
    @redisSubClient = redis.createClient(config)

  pub: (channel, data) ->
    data._sign = @_signature(data, @options.salt) if @options.salt?
    @redisPubClient.publish(channel, @_stringify(data))

  sub: (channel, callback) ->
    @redisSubClient.subscribe(channel)

  on: (callback) ->
    @redisSubClient.on 'message', (channel, message) =>
      data = @_parse(message)
      if data._sign? or @options.salt?
        sign = data._sign || ''
        salt = @options.salt || ''
        delete data._sign
        if sign != @_signature(data, salt)
          return false
      callback(data)

  close: ->
    @redisPubClient.end()
    @redisSubClient.end()

  _signature: (data, salt) ->
    return sha1(@_stringify(data) + salt)

  _stringify: (data) ->
    return JSON.stringify(data)

  _parse: (data) ->
    try
      message = JSON.parse(data)
      return message
    catch e
      return null

module.exports = RedisAdapter