const express = require('express');
const router = express.Router();
const Pacote = require('../controllers/Pacote');

router.post('/', Pacote.create);
router.get('/',  Pacote.findAll);

module.exports = router;
