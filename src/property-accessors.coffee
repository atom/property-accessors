Mixin = require 'mixto'
WeakMap = global.WeakMap ? require 'es6-weak-map'

module.exports =
class PropertyAccessors extends Mixin
  accessor: (name, definition) ->
    if typeof definition is 'function'
      definition = {get: definition}
    Object.defineProperty(this, name, definition)

  advisedAccessor: (name, definition) ->
    if typeof definition is 'function'
      getAdvice = definition
    else
      getAdvice = definition.get
      setAdvice = definition.set

    values = new WeakMap
    @accessor name,
      get: ->
        getAdvice?.call(this)
        values.get(this)
      set: (newValue) ->
        setAdvice?.call(this, newValue, values.get(this))
        values.set(this, newValue)

  lazyAccessor: (name, definition) ->
    values = new WeakMap
    @accessor name,
      get: ->
        if values.has(this)
          values.get(this)
        else
          values.set(this, definition.call(this))
          values.get(this)
      set: (value) ->
        values.set(this, value)
