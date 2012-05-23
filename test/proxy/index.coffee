proxied = require "#{__dirname}/../../lib"
helper = require "#{__dirname}/../helper"

lastError = null
listener = (stream) ->
  proxied stream, (err, context) ->
    if err?
      lastError = err
      return stream.end()
    module.exports.lastError = null
    if context.headers['test-host'] == 'awesome-test-app.com'
      return context.connect(helper.app.port)
    else
      res = context.createResponse()
      res.writeHead 404, 'content-type': 'text/html; charset=utf-8'
      res.end "not found"
module.exports.listener = listener
module.exports.getLastError = () ->
  e = lastError
  lastError = null
  e
