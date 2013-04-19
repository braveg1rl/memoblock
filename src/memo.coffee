forbiddenNames = ['set','read','write','put','get','setValue','setPromise','await','_values','_promises','_all']

module.exports = class Memo
  constructor: (values = {}) ->
    @_promises = {}
    @_values = values
    @_all = {}
    @_all[name] = value for name, value of values
    @[name] = value for name, value of values
    
  set: (name, value) ->
    throw new Error if name in forbiddenNames
    if isPromise value then @setPromise name, value else @setValue name, value
  
  get: (name) ->
    @_all[name]
    
  setValue: (name, value) ->
    throw new Error if name in forbiddenNames
    throw new Error "Supplied value may not be a promise." if isPromise value
    @[name] = value
    @_values[name] = value
    @_all[name] = value
    makeMemo @_all
    
  setPromise: (name, promise) ->
    throw new Error if name in forbiddenNames
    throw new Error "Supplied variable is not a promise" unless isPromise promise
    @[name] = promise
    @_promises[name] = promise
    @_all[name] = promise
    makeMemo @_all
    
  getResolvedValues: ->
    @_values

isPromise = (value) ->
  typeof value is "object" and typeof value.then is "function"
  
memoblock = undefined
makeMemo = (values) ->
  memoblock = require('./memoblock') unless memoblock?
  memoblock.makeMemo values