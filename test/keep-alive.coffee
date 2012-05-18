http = require "http"

should = require "should"

helper = require "#{__dirname}/helper"

describe "keep-alive", () ->
  http.Agent.maxSockets = 1
  before (done) ->
    helper.app.start () ->
      helper.proxy.start done

  after (done) ->
    helper.proxy.stop () ->
      helper.app.stop done

  it "works", (done) ->
    options =
      path: '/',
      port: helper.proxy.port
      headers:
        connection: "keep-alive",
        "test-host": 'awesome-test-app.com'
    
    responses = 200
    errorFound = false
    handleResponse = (err, res) ->
      #prevent calling error handler multiple times
      return if errorFound
      if err?
        errorFound = true
        done(err)
      unless res.statusCode == 200
        console.log res.statusCode
      res.statusCode.should.eql 200
      res.headers.connection.should.eql "keep-alive"
      done() unless --responses

    helper.request options, handleResponse for n in [responses..0]
