// command to ssh into the server: ssh -i "LinuxKey.pem" ec2-user@ec2-54-184-67-144.us-west-2.compute.amazonaws.com
const express = require('express');
const mysql = require('mysql');
const path = require('path');
const bodyParser = require('body-parser');
const app = express()
const PORT = 3000;
var id = -1;

const link = mysql.createPool({
    connectionLimit: 5,
    host: 'localhost',
    user: 'root',
    password: 'Group2CS386!',
    database: 'email',
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

  link.getConnection( (err, connection) =>
  {
   if (err) console.log(err);
   console.log("connect");

  let command = 'INSERT INTO email (??,??,??,??) VALUES (?,?,?,?)';
  let commandString = mysql.format(command, ["sendNumber", "numberTwo", "message","id",
  sendNumbers, returnNumber, message,id]);

  connection.query(commandString, (err, res)=>
  {
    if (err) console.log(err);
    console.log("Data added");
  });

  connection.query("select * from email;", (err, rows) =>
  {
   if (err) console.log(err);
   console.log("data: ", rows);
   connection.release();
  });
  console.log("Connection released");
  });
});

app.use(express.static(path.join(__dirname,'webpage')));

app.listen(PORT, () => {
  console.log(`server is running on port ${PORT}`)
});
