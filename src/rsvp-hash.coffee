RSVP = require "rsvp"

module.exports = hash = (promises) ->
  # console.log promises
  results = {}
  bigPromise = new RSVP.Promise
  remaining = size promises
  bigPromise.resolve {} if remaining is 0
  resolver = (prop) ->
    (value) ->
      resolveAll prop, value
  resolveAll = (prop, value) ->
    results[prop] = value
    bigPromise.resolve results if --remaining is 0
  rejectAll = (error) ->
    bigPromise.reject error
  for name, promise of promises
    unless promise and typeof promise.then is "function"
      resolveAll name, promise # value of promise may be "undefined"
    else
      try
        promise.then resolver(name), rejectAll
      catch error
        rejectAll error
  bigPromise
  
size = (object) ->
  s = 0
  s++ for name,value of object
  s

###
This code is adapted from RSVP.js 2.0, and will be here until 2.0 is released.

RSVP.js
Copyright (c) 2013 Yehuda Katz, Tom Dale, and contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
###