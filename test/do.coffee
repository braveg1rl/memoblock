assert = require "assert"
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

describe "memoblock.do", ->
  describe "when I don't provide any functions", ->
    it "return a promise for an empty object", (next) ->
      memoblock.do([])
        .then (memo) ->
          assert.deepEqual memo, {}
          next null
        .then null, (err) ->
          next err
  describe "when I provide some functions that set some values", ->
    it "makes them available to the next function", (next) ->
      memoblock.do([
        ->
          @location = testValues.location
          @subject = testValues.subject
        (memo) ->
          assert.equal @location, testValues.location
          assert.equal memo.subject, testValues.subject
          next null
        ]).then null, (err) ->
          next err
    it "immediately makes this value available", (next) ->
      memoblock.do([
        ->
          @location = testValues.location
          @subject = testValues.subject
        ->
          @date = faithful.return testValues.date
          @author = testValues.author
          @testNumber = faithful.return testValues.testNumber
        ->
          @body = faithful.return testValues.body
          @signature = faithful.return testValues.signature
        (memo) ->
          assert.deepEqual memo, testValues
          assert.deepEqual @, testValues
          assert.equal @location, testValues.location
          assert.equal @subject, testValues.subject
          assert.equal @body, testValues.body
          assert.equal @signature, testValues.signature
          next null
        ]).then null, (err) ->
          next err
size = (object) ->
  size = 0
  size++ for prop of object
  size