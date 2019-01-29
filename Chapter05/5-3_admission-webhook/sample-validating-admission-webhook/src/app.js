const https = require('https');
const fs = require("fs");
const path = require("path");
const bodyParser = require('body-parser')
const app = require('express')();
const index = require('./index');

var port = 443;

const options = {
  key: fs.readFileSync(path.resolve(__dirname, "./keys/server-key.pem")),
  cert: fs.readFileSync(path.resolve(__dirname, "./keys/server-cert.pem")),
};

var httpsServer = https.createServer(options, app).listen(port);
app.use(bodyParser.json())

app.use(function (req, res) {
  var post_data = req.body;
  console.log(post_data);
  console.log("Server starts running...");
  index.webhook(req, res);
})
