foo1 = ->

foo1.prototype.alert = ->
  console.log 'foo1'

foo2 = ->

foo2.prototype.__proto__ = foo1.prototype

foo2.prototype.$alert = foo1.prototype.alert

foo2.prototype.alert = ->
  console.log 'foo2'

$foo1 = new foo1
$foo2 = new foo2
$foo1.alert()
$foo2.$alert()
$foo2.alert()
