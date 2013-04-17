RSVP = require "rsvp"
RSVPHash = require "./rsvp-hash"

Memo = require "./memo"
  
module.exports = memoblock =
  makeMemo: (values) ->
    RSVPHash(values).then (resolvedValues) ->
      new Memo resolvedValues
  Memo: Memo