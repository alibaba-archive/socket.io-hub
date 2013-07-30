redis = require('redis')
redisClient = redis.createClient()

redisClient.publish '1', 'hello world', (err, data) ->
  console.log data
