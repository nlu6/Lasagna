
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
    user: 'email',
    password: 'G2CS386!',
    database: 'email',
 });

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '/web/index.html'));
});

app.get('/removeData', (req, res) =>
{
  if( id > -1 )
    {
     removeData( id );
     id--;
     res.send("data removed");
    }
  else
     {
      console.log("no data in database");
      res.send("no data");
     }
});

app.post('/enterData', (req, res) =>
{
  id++;
  let sendNumbers = req.body.firstNumber;
  let returnMail = req.body.textBackEmail;
  let message = req.body.messageString;

  storeData( sendNumbers, message, returnMail)

  let spawn = require("child_process").spawn;
  let pythonScript = spawn('python3', ["main_module.py", sendNumbers, message, returnMail]);
  pythonScript.stdout.on('data', function(data) {
  console.log(data.toString());});
  res.send("data has been added");
});

app.use(express.static(path.join(__dirname,'webpage')));

app.listen(PORT, () => {
  console.log(`server is running on port ${PORT}`)
});

function removeData( identification )
   {
    let command= "delete from email where id =".concat(" ", JSON.stringify(identification));
    link.getConnection( (error, connection ) =>
    {
     if(error) throw(error);
     console.log("connected");

     connection.query(command, (err, res) =>
     {
      if( error ) throw(error);
      console.log("data removed");
     });
     connection.release();
    });
   }

function storeData( targetNumbers, message, returnNumber )
   {
    link.getConnection( (err, connection) =>
    {
     if (err) console.log(err);
     console.log("connect");
  
    let command = 'INSERT INTO email (??,??,??,??) VALUES (?,?,?,?)';
    let commandString = mysql.format(command, ["targetNumbers", "returnNumber", "message","id",
    targetNumbers, returnNumber, message,id]);
  
    connection.query(commandString, (err, rows)=>
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
    }); 
   }
