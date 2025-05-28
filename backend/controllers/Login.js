// controllers/loginController.js
require('dotenv').config();
const Login = require('../models/Login');
const Entregador = require('../models/Entregador');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Criar credenciais de login
exports.create = async (req, res) => {
  try {
    const { id_entregador, email, senha, status = true } = req.body;

    // Validações
    if (!id_entregador || !email || !senha) {
      return res.status(400).json({ error: 'id_entregador, email e senha são obrigatórios' });
    }

    // Verificar se o entregador existe
    const entregador = await Entregador.findByPk(id_entregador);
    if (!entregador) {
      return res.status(404).json({ error: 'Entregador não encontrado' });
    }

    // Verificar se email já está cadastrado
    const emailExistente = await Login.findOne({ where: { email } });
    if (emailExistente) {
      return res.status(400).json({ error: 'Email já está em uso' });
    }

    // Criptografar a senha
    const salt = await bcrypt.genSalt(10);
    const senhaHash = await bcrypt.hash(senha, salt);

    const novoLogin = await Login.create({
      id_entregador,
      email,
      senha: senhaHash,
      status
    });

    res.status(201).json({
      id_entregador: novoLogin.id_entregador,
      email: novoLogin.email,
      status: novoLogin.status
    });
  } catch (error) {
    console.error('Erro ao criar login:', error);
    res.status(500).json({ error: 'Erro ao criar login' });
  }
};

// Autenticar usuário
exports.login = async (req, res) => {
  try {
    const { email, senha } = req.body;

    // Verificar se email e senha foram fornecidos
    if (!email || !senha) {
      return res.status(400).json({ error: 'Email e senha são obrigatórios' });
    }

    // Buscar o login pelo email
    const login = await Login.findOne({ 
      where: { email },
      include: [{ model: Entregador }]
    });
      console.log('Login encontrado', login);
    if (!login ) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }

    // Verificar status da conta
    if (!login.status) {
      return res.status(403).json({ error: 'Conta desativada' });
    }

    // Verificar a senha
    const senhaValida = await bcrypt.compare(senha, login.senha);
    console.log('Senha válida?', senhaValida);
    if (!senhaValida) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }
    // Criar token JWT
    const token = jwt.sign(
      { 
        id_entregador: login.id_entregador,
        email: login.email
      },
      process.env.JWT_SECRET,
      { expiresIn: '8h' }
    );

    res.json({
        token,
        entregador: {
            id: login.Entregador.id,
            nome: login.Entregador.nome,
            cnh: login.Entregador.cnh
        }
    });
    } catch (error) {
        console.error('Erro ao autenticar:', error);
        res.status(500).json({ error: 'Erro ao autenticar' });
    }
};

// Atualizar credenciais
exports.update = async (req, res) => {
  try {
    const { id_entregador } = req.params;
    const { email, senha, status } = req.body;

    const login = await Login.findByPk(id_entregador);
    if (!login) {
      return res.status(404).json({ error: 'Login não encontrado' });
    }

    // Atualizar apenas os campos fornecidos
    if (email) {
      // Verificar se novo email já está em uso
      if (email !== login.email) {
        const emailExistente = await Login.findOne({ where: { email } });
        if (emailExistente) {
          return res.status(400).json({ error: 'Email já está em uso' });
        }
      }
      login.email = email;
    }

    if (senha) {
      // Criptografar nova senha
      const salt = await bcrypt.genSalt(10);
      login.senha = await bcrypt.hash(senha, salt);
    }

    if (status !== undefined) {
      login.status = status;
    }

    await login.save();

    res.json({
      id_entregador: login.id_entregador,
      email: login.email,
      status: login.status
    });
  } catch (error) {
    console.error('Erro ao atualizar login:', error);
    res.status(500).json({ error: 'Erro ao atualizar login' });
  }
};

// Buscar credenciais por ID do entregador
exports.findOne = async (req, res) => {
  try {
    const { id_entregador } = req.params;

    const login = await Login.findByPk(id_entregador, {
      attributes: { exclude: ['senha'] }, // Não retornar a senha
      include: [{ model: Entregador }]
    });

    if (!login) {
      return res.status(404).json({ error: 'Login não encontrado' });
    }

    res.json(login);
  } catch (error) {
    console.error('Erro ao buscar login:', error);
    res.status(500).json({ error: 'Erro ao buscar login' });
  }
};

// Middleware para verificar token
exports.verifyToken = async (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).json({ error: 'Acesso negado. Token não fornecido.' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(400).json({ error: 'Token inválido' });
  }
};