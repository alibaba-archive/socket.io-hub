Atom = require('./require-atom')

Atom.prototype.$emit = Atom.prototype.emit

Atom.prototype.emit = ->
  console.log 'atom2'
  this.$emit.apply()

module.exports = Atom