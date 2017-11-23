/**
 * Created by andriikosiak on 24.05.16.
 */

var serveIndex = require('serve-index');
var express = require('express');
var serveStatic = require('serve-static');
var app = express();
var contentDisposition = require('content-disposition');

var servePath = process.env.servePath || (__dirname + '/'); 
  
function setCustomCacheControl(res, path) {
	if (serveStatic.mime.lookup(path) === 'text/html') {
		// Custom Cache-Control for HTML files
		res.setHeader('Cache-Control', 'public, max-age=0')
	} else {
		//Force download of all files
		res.setHeader('Content-Disposition', contentDisposition(path));
	}
	console.log('GET '+path);
}

app.use(serveStatic(servePath, {
	//maxAge: '1d',
	setHeaders: setCustomCacheControl
}), serveIndex(servePath, {'icons': true, 'view': 'details'}));
app.listen(3000);

console.log("servePath: "+servePath);