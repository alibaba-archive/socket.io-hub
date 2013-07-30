redis = require('redis')

module.exports =
class RedisAdapter
  constructor: (options) ->
    config = options.config || null
    # sub and pub command should not both exist in one client
    @redisPubClient = redis.createClient(config)
    @redisSubClient = redis.createClient(config)
  pub: (channel, data) ->
    @redisPubClient.publish(channel, @_stringify(data))
  sub: (channel, callback) ->
    @redisSubClient.subscribe(channel)
  on: (callback) ->
    @redisSubClient.on 'message', (channel, message) =>
      callback(@_parse(message))
  close: ->
    @redisPubClient.end()
    @redisSubClient.end()
  _stringify: (data) ->
    return JSON.stringify(data)
  _parse: (data) ->
    return JSON.parse(data)