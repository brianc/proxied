http = require "http"
should = require "should"

should.be=
  statusCode: (code) ->
    it "should have status code #{code}", () ->
      @res.statusCode.should.eql code
  contentType: (type) ->
    it "should have content-type #{type}", () ->
      @res.headers['content-type'].should.eql type
  html: () ->
    should.be.contentType "text/html; charset=utf-8"
  javascript: () ->
    should.be.contentType "application/javascript"
  json: () ->
    should.be.contentType "application/json; charset=utf-8"
  css: () ->
    should.be.contentType "text/css; charset=UTF-8"

should.have = should.be

helper =
  port: 3001

request = (options, cb) ->
  options.port or= helper.port
  options.method or= "GET"

  req = http.request options, (res) ->
    res.body = ""
    res.on "data", (data) -> res.body += data.toString('utf8')
    res.on "end", () -> cb(null, res)
  req.on "error", cb
  req.write options.body if options.body?
  req.end()

  req

makeBody = (boundary, txt) ->
  body = """
  --#{boundary}\r
  Content-Disposition: form-data; name=\"file\"; filename=\"test.txt\"\r
  Content-Type: text/plain\r
\r
  #{txt.split('\n').join('\r\n')}\r
  --#{boundary}--\r\n\r\n"""

upload = (config, cb) ->

  boundary = helper.boundary()
  contentTypeHeader = "multipart/form-data; boundary=#{boundary}"
  body = helper.makeBody boundary, config.body
  headers =
    "content-type": contentTypeHeader
    "content-length": body.length

  options =
    method: "POST"
    path: config.path
    headers: headers
    body: body

  helper.request options, (err, res) ->
    if err
      console.error "UPLOAD ERROR"
    cb(err, res)


get = (path, options) ->
  options or= {}

  describe "GET #{path}", () ->
    self = this
    before (done) ->
      options.path = path
      helper.request options, (err, result) =>
        return done(err) if err?
        @res = result
        done()

    options.expect.call(this) if options.expect?

helper.boundary = () -> "----WebKitFormBoundary1234567890ABCDEF"
helper.upload = upload
helper.makeBody = makeBody
helper.request = request
helper.startServer = startServer
helper.stopServer = stopServer
helper.get = get

module.exports = helper
