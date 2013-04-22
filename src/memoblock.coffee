faithful = require "faithful"
  
module.exports = memoblock =
  do: (functions) ->
    @doWith {}, functions
      
  doWith: (memo, functions) ->
    doStep = (fn) ->
      r = fn.call memo, memo
      if r and typeof r.then is "function"
        r.then -> faithful.collect memo
      else
        faithful.collect memo
    faithful.eachSeries functions, doStep,
      handleResult: (result) -> memo = result
      getFinalValue: -> memo
    