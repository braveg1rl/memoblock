assert = require "assert"
faithful = require "faithful"

memoblock = require "../"

describe "memoblock.makeMemo", ->
  describe "when passed no arguments", ->
    it "makes a promise for an empty memo", (next) ->
      memoblock.makeMemo()
        .then (memo) ->
          assert.equal size(memo.getResolvedValues()), 0, "Size isn't 0."
          next null
        .then null, (err) ->
          next err
        
  describe "when passed a values object", ->
    values =
      date: new Date
      location: "The Hague"
      subject: "Test of simple values"
      testNumber: 2
    it "makes a promise for a memo with these values set", (next) ->
      memoblock.makeMemo(values)
        .then (memo) ->
          assert.ok size(memo.getResolvedValues()), 4, "Size isn't 4."
          assert.ok values[name] = value for name, value in memo.getResolvedValues()
          next null
        .then null, (err) ->
          next err
      
  describe "when passed a values object containing some promises", ->
    it "makes a promise for a memo with all values resolved", (next) ->
      signatureString = "Signed by HyperTrust Secure Message Verification Service. Really. Trust us."
      bodyString = "Message authoring outsourced to Mechanicul Turk. Laziness is a virtue."
      values =
        date: new Date
        location: "The Hague"
        subject: "Test of promises mixed with values."
        testNumber: 3
        body: faithful.return bodyString
        signature: faithful.return signatureString
      memoblock.makeMemo(values)
        .then (memo) ->
          resolved = memo.getResolvedValues()
          assert.equal size(resolved), 6, "Size isn't 6."
          assert.equal values[name], resolved[name] for name in ['date','location','subject','testNumber']
          assert.equal memo.body, bodyString
          assert.equal memo.signature, signatureString
          next null
        .then null, (err) ->
          next err
  
size = (object) ->
  s = 0
  s++ for prop of object
  s