const express = require('express');
const router  = express.Router();
const login   = require('../controller/Login');

// Endpoints para criação e autenticação
router.post('/register', login.create);  // cria as credenciais
router.post('/',          login.login);   // autentica (gera JWT)
router.put('/login/:id',       login.update);  // atualiza credenciais
router.get('/login/:id',       login.findOne); // busca dados de login

module.exports = router;

