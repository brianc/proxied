net = require "net"

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
  proxyTestBehavior.call(this)

  it "closes socket", (done) ->
    socket = new net.Socket()
    socket.connect helper.proxy.port
    socket.on "connect", () ->
      socket.write "asdf"
      setTimeout socket.end.bind(socket), 50
    socket.on "end", done
    socket.on "error", done

describe "garbage socket", () ->
  proxyTestBehavior.call(this)

  it "closes socket"
