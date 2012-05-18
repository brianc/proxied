var net = require('net');
var http = require('http');

var parsley = require('parsley');

module.exports = function(upStream, callback) {
  var bufferedChunks = [];
  upStream.on('data', bufferedChunks.push.bind(bufferedChunks));
  var context = {};
  parsley(upStream, function(req) {
    //we have received headers, pause until we're ready to pipe
    upStream.pause();

    context.headers = headers;
    //connect to downStream server
    context.connect = function(port, host) {
      var downStream = new net.Socket();
      downStream.connect(port, host);
      downStream.on('connect', function() {
        for(var i = 0, chunk; chunk = bufferedChunks[i++];) {
          downStream.write(chunk);
        }
        upStream.pipe(downStream);
        downStream.pipe(upStream);
        upStream.resume();
      });
    };

    context.createResponse = function() {
      var response = new http.ServerResponse(req);
      response.assignSocket(upStream);
      response.on('finish', function() {
        response.detachSocket(upStream);
        upStream.destroySoon();
      });
      return response;
    };

    callback(context);

  });
});
};
