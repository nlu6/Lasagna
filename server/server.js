// command to ssh into the server: ssh -i "LinuxKey.pem" ec2-user@ec2-54-184-67-144.us-west-2.compute.amazonaws.com
// can be accessed at domain marcocastrita.com this is just temporary for testing
const express = require('express');
const app = express();
const path = require('path');
const port = 3000;

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '/index.html'));
});

app.use(express.static(path.join(__dirname, 'webpage')));

app.listen(port, () => {
  console.log(`server is running`)
})
