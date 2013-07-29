var RedisEmitter = require('redis-emitter').RedisEmitter;

var emitter = new RedisEmitter();

emitter.on('a nice channel', function(data) {
  console.log('got data on a nice channel:', data);
});