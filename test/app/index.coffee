express = require "express"

app = express()

app.get "/", (req, res) ->
  res.send "okay"

module.exports = app
