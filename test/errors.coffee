net = require "net"
http = require "http"

helper = require "#{__dirname}/helper"
should = require "should"

proxyTestBehavior = () ->
  before (done) ->
    helper.app.start () ->
      helper.proxy.start done

  after (done) ->
    helper.app.stop () ->
      helper.proxy.stop done


describe "early request disconnect", () ->
  proxyTestBehavior.call this

  it "terminates cleanly"

describe "unparsable request", () ->
  proxyTestBehavior.call this

  before (done) ->
    @socket = new net.Socket()
    @socket.connect helper.proxy.port
    @socket.on "connect", () =>
      @socket.write "asdf TEST TEST \r\n\r\n\r\n\r\n", "utf8", done

  it "closes socket", (done) ->
    @socket.on "end", done

  it "passes error to callback", () ->
    should.exist helper.proxy.getLastError()
