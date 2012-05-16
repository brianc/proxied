helper = require "#{__dirname}/helper"
should = require "should"

appBehavior = (port) ->
  before helper.app.start
  after helper.app.stop
  helper.get "/"
    port: port
    headers:
      "test-host": 'awesome-test-app.com'
    expect: () ->
      should.have.statusCode 200
      should.be.html()
      should.have.body "okay"

describe "app", () ->
  appBehavior.call(this, helper.app.port)

describe "proxy", () ->
  return
  before helper.proxy.start
  after helper.proxy.end
  appBehavior.call(this, helper.proxy.port)
