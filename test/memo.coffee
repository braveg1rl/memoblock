assert = require "assert"
RSVP = require "rsvp"
faithful = require "faithful"

memoblock = require "../"


testValues =
  author: "Meryn Stol"
  date: new Date
  location: "The Hague"
  subject: "Testing memo behavior"
  testNumber: 123
  signature: "Signed by HyperTrust Secure Message Verification Service. Really. Trust us."
  body: "Message authoring outsourced to Mechanicul Turk. Laziness is a virtue."
  
makePromise = (func) ->
  promise = new RSVP.Promise
  resolve = (value) -> promise.resolve value
  reject = (error) -> promise.reject error
  func resolve, reject
  promise

describe "memo.set", ->
  describe "when I set a regular value", ->
    it "return a promise for a memo with this value set", (next) ->
      memoblock.makeMemo()
        .then (memo) ->
          memo.set "location",testValues.location
        .then (memo) ->
          assert.equal memo.location, testValues.location
          assert.equal (memo.get "location"), testValues.location
          next null
        .then null, (err) ->
          next err
    it "immediately makes this value available", ->
      memoblock.makeMemo()
        .then (memo) ->
          memo.set "location",testValues.location
          assert.equal memo.location, testValues.location
          assert.equal (memo.get "location"), testValues.location
        .then null, (err) ->
          next err
  describe "when I set a promised value", ->
    it "return a promise for a memo with this value set", (next) ->
      memoblock.makeMemo()
        .then (memo) ->
          memo.set "location", faithful.return testValues.location
        .then (memo) ->
          assert.equal memo.location, testValues.location
          next null
        .then null, (err) ->
          next err
  describe "when I use memo in a chain", ->
    it "makes all values available eventually", (next) ->
      memoblock.makeMemo()
        .then (memo) ->
          memo.set "name", faithful.return testValues.name
        .then (memo) ->
          memo.set "signature", faithful.return testValues.signature
          memo.set "location", testValues.location
        .then (memo) ->
          memo.set "body", faithful.return testValues.signature
          memo.set "testNumber", testValues.testNumber
        .then (memo) ->
          memo.set "body", faithful.return testValues.signature
          memo.set "date", faithful.return testValues.signature
        .then (memo) ->
          assert.equal memo[name],value for name, value in testValues
          next null
        .then null, (err) ->
          next err

  
size = (object) ->
  size = 0
  size++ for prop of object
  size