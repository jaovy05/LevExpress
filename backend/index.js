const express = require('express');
const app = express();
const port = 5000;
const passport = require('passport');
const cors = require('cors');
const db = require('./database.js');
const loginRoutes = require('./routes/login.js');
const entregadorRoutes = require('./routes/entregador');

app.use(express.json());

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
  });
  
app.use('/login', loginRoutes);
app.use('/entregadores', entregadorRoutes);
