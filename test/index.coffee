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

  helper.get "/json",
    port: port,
    headers:
      "test-host": 'awesome-test-app.com'
    expect: () ->
      should.have.statusCode 200
      should.be.json()
      it "has parsable json body", () ->
        result = JSON.parse(@res.body)
        result.works.should.be.true

  describe "POST /json", () ->
    before (done) ->
      body = '{"message": "I am the very model of?" }'
      options =
        method: 'POST'
        port: port
        path: '/json'
        headers:
          "test-host": 'awesome-test-app.com'
          "content-type": "application/json"
          "content-length": body.length
        body: body

      helper.request options, (err, res) =>
        @res = res
        done err

    should.have.statusCode 200
    should.be.json()
    it "responds with proper json", () ->
      result = JSON.parse @res.body
      result.response.should.eql('I am the very model of? yes')


  describe "HEAD /test-headers", () ->
    before (done) ->
      options =
        method: 'HEAD'
        port: port
        path: '/'
        headers: "test-host": "awesome-test-app.com"

      helper.request options, (err, res) =>
        @res = res
        done err

    should.have.statusCode 200
    should.be.html()
    should.have.body ""

describe "app", () ->
  port = helper.app.port
  appBehavior.call(this, port)

describe "proxy", () ->
  before helper.proxy.start
  after helper.proxy.stop
  appBehavior.call(this, helper.proxy.port)
  helper.get "/fail",
    port: helper.proxy.port
    expect: () ->
      should.have.statusCode 404
      should.be.html()
      should.have.body "not found"
