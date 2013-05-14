{isPromise,collect,makePromise} = require "faithful"
  
module.exports = memoblock =
  do: (functions) ->
    @doWith {}, functions
      
  doWith: (memo, functions) ->
    i = -1
    makePromise (cb) ->
      iterate = (memo) ->
        i++
        return cb null, memo if i >= functions.length
        try r = functions[i].call memo, memo
        catch error then return cb error
        if r and typeof r.then is "function"
          r.then(-> collect memo).then ((m) -> iterate m), (err) -> cb err
        else if containsPromises memo
          faithful.collect(memo).then ((m) -> iterate m), (err) -> cb err
        else
          iterate memo
      iterate memo

containsPromises = (obj) ->
  return true for name, value of obj when isPromise value