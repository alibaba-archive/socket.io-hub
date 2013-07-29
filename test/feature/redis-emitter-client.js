var RedisEmitter = require('redis-emitter').RedisEmitter,
    redis = require('redis').createClient();

var emitter = new RedisEmitter();
emitter.emit('a nice channel', 'some data');

// Close the connection to redis
redis.end();
