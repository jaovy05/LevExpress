const express = require('express');
const router  = express.Router();
const Login = require('../controllers/Login');

// Endpoints para criação e autenticação
router.post('/register', Login.create);  // cria as credenciais
router.post('/',         Login.login);   // autentica (gera JWT)
router.put('/login/:id', Login.update);  // atualiza credenciais
router.get('/login/:id', Login.findOne); // busca dados de login

module.exports = router;

