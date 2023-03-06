// command to ssh into the server: ssh -i "LinuxKey.pem" ec2-user@ec2-54-184-67-144.us-west-2.compute.amazonaws.com
require('dotenv').config()
const express = require('express');
const mysql = require('mysql');
const path = require('path');
const bodyParser = require('body-parser');
const app = express()
const PORT = 3000;
const cors = require('cors')

const link = mysql.createConnection({
   host: 'localhost',
    user: 'root',
    password: 'Group2CS386!',
    database: 'email',
 });

app.use(cors())
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '/index.html'));
});

app.post('/enterData', (req, res) =>
{
  link.connect( function(err)
  {
   if (err) console.log(err);
   console.log("connect");
   });

  let command = 'INSERT INTO email (??,??,??) VALUES (?,?,?)';
  let commandString = mysql.format(command, ["numberOne", "numberTwo", "message",
  req.body.firstNumber, req.body.returnNumber, req.body.messageString]);

  link.query(commandString, (err, res)=>
  {
    if (err) console.log(err);
    console.log("Data added");
  });

  link.query("SELECT * FROM email;", (err, rows) =>
  {
   if (err) console.log(err);
   console.log('data: \n', rows);
   res.send("testing");
  });
  link.end();
});

app.get('/log', (req,res) => {
res.sendFile(path.join(__dirname, 'nohup.out'));
});


/**
 * Receives the message to be sent
 * and the recipients' numbers
 */
app.post('/sendMessage', bodyParser.json(), async (req, res) => {
  const message = req.body.message;
  const recipients = req.body.numbers;

  const accountSid = process.env.TWILIO_ACCOUNT_SID;
  const authToken = process.env.TWILIO_AUTH_TOKEN;
  const phoneNumber = process.env.TWILIO_PHONE_NUMBER;
  const client = require('twilio')(accountSid, authToken);

  try {
    const response = await client.messages
          .create({body: message, from: phoneNumber, to: recipients})
    const success = await response.sid
    res.json({success})
  } catch (error) {
    console.error(error.message);
    res.json({success: false})
  }
})

app.use(express.static(path.join(__dirname,'webpage')));

app.listen(PORT, () => {
  console.log(`server is running on port ${PORT}`)
})
