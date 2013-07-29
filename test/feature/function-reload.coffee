# clone two object and overload the first object's property

_ = require('underscore')

obj1 =
  foo: ->

obj1.foo.prototype.alert = ->
  return 'hello obj1'

obj2 = _.clone(obj1)

obj2.foo = ->  # try to delete this line and see the difference

obj2.foo.prototype.alert = ->
  console.log 'obj2 first'
  foo1 = new obj1.foo
  return foo1.alert.apply(this, arguments)

$foo1 = new obj1.foo
$foo2 = new obj2.foo

console.log $foo1.alert()
console.log $foo2.alert()