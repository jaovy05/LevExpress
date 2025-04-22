require('dotenv').config();

const pgp = require("pg-promise")({});

const { USER, HOST, DATABASE, PASSWORD, PORT } = process.env;

const db = pgp(`postgres://${USER}:${PASSWORD}@${HOST}:${PORT}/${DATABASE}`);

module.exports = db;
