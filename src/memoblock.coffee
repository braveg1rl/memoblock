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
        if containsPromises memo
          if (isPromise r) and not (isPropertyOf r, memo)
            r.then(-> collect memo).then ((m) -> iterate m), (err) -> cb err
          else
            collect(memo).then ((m) -> iterate m), (err) -> cb err
        else
          if (isPromise r)
            r.then (-> iterate memo), (err) -> cb err
          else
            iterate memo
      iterate memo

containsPromises = (obj) ->
  return true for name, value of obj when isPromise value
  return false
  
isPropertyOf = (subject, obj) ->
 return true for name, value of obj when value is subject
 return false