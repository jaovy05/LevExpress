
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
  