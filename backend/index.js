
const express = require('express');
const app = express();
const port = 5000;
const passport = require('passport');
const cors = require('cors');
const db = require('./database.js');

app.use(express.json());

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
  });

/* Entregador */
const entregador = require('./controller/entregador.js');
app.post('/entregador', entregador.create);
app.get('/entregador', entregador.findAll);
app.get('/entregador/:id', entregador.findOne);
app.put('/entregador/:id', entregador.update);
app.delete('/entregador/:id', entregador.delete);

/* Login */
const login = require('./controller/Login.js');

app.post('/login', login.create);
app.get('/login', login.login);
app.put('/login/:id', login.update);
