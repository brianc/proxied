var parsley = require('parsley');

module.exports = function(stream) {
  parsley(stream, function(req) {
    req.on("headers", function(headers) {
      console.log("got headers %j", headers);
    });
  });
}
