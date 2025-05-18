const express = require('express');
const router = express.Router();
const login = require('../controller/Login');

router.post('/login', login.create);
router.get('/login', login.login);
router.put('/login/:id', login.update);

module.exports = router;
