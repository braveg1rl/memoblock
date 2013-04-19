faithful = require "faithful"
  
module.exports = memoblock =
  do: (functions) ->
    @doWith {}, functions
      
  doWith: (memo, functions) ->
    doStep = (fn) ->
      fn.call memo, memo
      faithful.collect memo
    faithful.eachSeries functions, doStep,
      handleResult: (result) -> memo = result
      getFinalValue: -> memo
    