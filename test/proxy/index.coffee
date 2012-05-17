proxied = require "#{__dirname}/../../lib"
helper = require "#{__dirname}/../helper"

module.exports = (stream) ->
  proxied stream, (context) ->
    if context.headers['test-host'] == 'awesome-test-app.com'
      return context.connect(helper.app.port)
    else
      res = context.createResponse()
      res.writeHead 404, 'content-type': 'text/html; charset=utf-8'
      res.end "not found"
