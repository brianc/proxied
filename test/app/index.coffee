express = require "express"

app = express()
app.use(express.bodyParser())

app.use (req, res, next) ->
  next()

app.get "/", (req, res) ->
  res.send "okay"

app.get "/huge", (req, res) ->
  expectedBody = "hi!"
  body = expectedBody += expectedBody for n in [0..10]
  res.writeHead 200
    "content-type": "text/plain"
    "content-length": body.length
  for n in [0..10]
    setTimeout () ->
      expectedBody += expectedBody
      res.write expectedBody
    , n*5
  setTimeout () ->
    res.end()
  , 100

app.get "/json", (req, res) ->
  res.json(works: true)

app.post "/json", (req, res) ->
  res.json(response: req.body.message + ' yes')

module.exports = app
