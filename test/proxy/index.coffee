proxied = require "#{__dirname}/../../lib"

module.exports = (stream) ->
  proxied stream, (req) ->
    return
