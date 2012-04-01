/**
 * Static file server
 *   request a file, get a file
 */
 
// Required libraries
var http    = require('http');
var fs      = require('fs');
 
/***************** Simple file server *****************/
 

var index = '';
// Cache website
fs.readFile('./public/index.html', function (err, data) {
    if (err) {
        return console.log(err)
    }
    index = data;
});

var cv = fs.readFileSync('./public/cv.html');
var w404 = fs.readFileSync('./public/404.html');
var w500 = fs.readFileSync('./public/500.html');

// Create the server
var server = http.createServer(function (request, response) {
    // Log the request
    console.log(new Date() + ' [' + request.method + '] ' + request.url);
    // Serve static files
    if (request.method === "GET"){
        if (request.url == '/'){
            response.writeHead(200, { 'Content-Type': 'text.html' });
            response.end(index, 'utf-8');
        } else if (request.url == '/cv') {
            response.writeHead(200, { 'Content-Type': 'text.html' });
            response.end(cv, 'utf-8');
        } else {
            // Write the file
            url = './public' + request.url
            fs.readFile(url, function (err, data) {
                if (err) {
                    response.writeHead(404, { 'Content-Type': 'text/html' });
                    response.end(w404, 'utf-8');
                } else {
                    // Lookup the mimetype of the file
                    var tmp     = url.lastIndexOf(".");
                    var ext     = url.substring((tmp + 1));
                    var mime    = mimes[ext] || 'text/plain';
                    response.writeHead(200, { 'Content-Type': mime });
                    response.end(data, 'utf-8');
                }
            });
        };
    };
});
 
// Listen on port 8080 and IP 127.0.0.1
server.listen(8080, "127.0.0.1");
console.log('Server running at 127.0.0.1:8080');

/********************* MIME TABLE *********************/
var mimes = {
    'css':  'text/css',
    'js':   'text/javascript',
    'htm':  'text/html',
    'html': 'text/html',
    'ico':  'image/vnd.microsoft.icon'
};
