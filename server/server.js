// command to ssh into the server: ssh -i "LinuxKey.pem" ec2-user@ec2-54-184-67-144.us-west-2.compute.amazonaws.com

const express = require('express');
const mysql = require('mysql');
const path = require('path');
const bodyParser = require('body-parser');
const app = express()
const PORT = 3000;
var id = 0;

const link = mysql.createConnection({
   host: 'localhost',
    user: 'root',
    password: 'Group2CS386!',
    database: 'email',
 });

 link.connect( function(err)
 {
  if (err) console.log(err);
  console.log("connect");
  });

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '/index.html'));
});

app.post('/enterData', (req, res) =>
{
  id++;
  let sendNumbers = req.body.firstNumber;
  let returnNumber = req.body.returnNumber;
  let message = req.body.messageString;

  let command = 'INSERT INTO email (??,??,??,??) VALUES (?,?,?,?)';
  let commandString = mysql.format(command, ["sendNumber", "numberTwo", "message","id",
  sendNumbers, returnNumber, message,id]);

  link.query(commandString, (err, res)=>
  {
    if (err) console.log(err);
    console.log("Data added");
  });

  link.query("select * from email;", (err, rows) =>
  {
   if (err) console.log(err);
   console.log("data: ", rows);
   res.send("testing");
  });

});

app.use(express.static(path.join(__dirname,'webpage')));

app.listen(PORT, () => {
  console.log(`server is running on port ${PORT}`)
});

