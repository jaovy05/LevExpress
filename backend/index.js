
const express = require('express');
const app = express();
const port = 5000;
const passport = require('passport');
const cors = require('cors');
const db = require('./database.js');
const login = require('./controller/Login.js');

app.use(express.json());

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
  });
  
app.post('/login', login.create);
app.get('/login', login.login);
app.put('/login/:id', login.update);
