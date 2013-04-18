faithful = require "faithful"

Memo = require "./memo"
  
module.exports = memoblock =
  makeMemo: (values) ->
    values = {} unless values
    faithful.collect(values).then (resolvedValues) ->
      new Memo resolvedValues
  Memo: Memo
  
  do: (functions) ->
    memo = {}
    doStep = (fn) ->
      fn.call memo, memo
      faithful.collect memo
    faithful.eachSeries functions, doStep,
      handleResult: (result) -> memo = result
      getFinalValue: -> memo