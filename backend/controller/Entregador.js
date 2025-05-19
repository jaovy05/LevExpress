require('dotenv').config();
const { Sequelize } = require('sequelize');
const sequelize = require('../database');
const Entregador = require('../models/Entregador');
const Login = require('../models/Login');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');


exports.create = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const { nome, cnh, email, senha } = req.body;
    if (!nome || !cnh || !email || !senha) {
      return res.status(400).json({ error: 'nome, cnh, email e senha são obrigatórios' });
    }

    //cria entregador
    const novoEntregador = await Entregador.create(
      { nome, cnh },
      { transaction: t }
    );

    //cria login vinculado
    const senhaHash = await bcrypt.hash(senha, 10);
    await Login.create(
      {
        id_entregador: novoEntregador.id,
        email: email.trim().toLowerCase(),
        senha: senhaHash,
        status: true
      },
      { transaction: t }
    );

    //gera JWT
    const token = jwt.sign(
      { id_entregador: novoEntregador.id, email },
      process.env.JWT_SECRET,
      { expiresIn: '8h' }
    );

    await t.commit();

    //retorna entregador e token
    return res.status(201).json({
      token,
      entregador: {
        id: novoEntregador.id,
        nome: novoEntregador.nome,
        cnh: novoEntregador.cnh
      }
    });

  } catch (error) {
    await t.rollback();
    console.error('Erro ao criar entregador + login:', error);
    return res.status(500).json({ error: 'Erro ao criar entregador com login' });
  }
};


// Listar todos os entregadores
exports.findAll = async (req, res) => {
    try {
        const entregadores = await Entregador.findAll();
        
        res.json({
            success: true,
            message: entregadores.length > 0 
                ? 'Entregadores encontrados' 
                : 'Nenhum entregador cadastrado',
            data: entregadores
        });
        
    } catch (error) {
        console.error('Erro ao buscar entregadores:', error);
        res.status(500).json({ 
            success: false,
            message: 'Erro ao buscar entregadores',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// Buscar um entregador por ID
exports.findOne = async (req, res) => {
    try {
        const { id } = req.params;
        const entregador = await Entregador.findByPk(id);
    
        if (!entregador) {
            return res.status(404).json({ 
                success: false,
                message: 'Entregador não encontrado',
                searchedId: id
            });
        }
        
        res.json({
            success: true,
            message: 'Entregador encontrado',
            data: entregador
        });
        
    } catch (error) {
        console.error('Erro ao buscar entregador:', error);
        res.status(500).json({ 
            success: false,
            message: 'Erro ao buscar entregador',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// Atualizar um entregador
exports.update = async (req, res) => {
    try {
        const { id } = req.params;
        const { cnh, nome } = req.body;
        
        const entregador = await Entregador.findByPk(id);
        
        if (!entregador) {
            return res.status(404).json({ 
                success: false,
                message: 'Entregador não encontrado',
                searchedId: id
            });
        }
        
        // Validações
        if (cnh && cnh.length !== 11) {
            return res.status(400).json({ 
                success: false,
                message: 'CNH deve ter exatamente 11 caracteres',
                invalidField: 'cnh',
                expectedLength: 11
            });
        }
        
        await entregador.update({ cnh, nome });
        
        res.json({
            success: true,
            message: 'Entregador atualizado com sucesso',
            data: entregador
        });
        
    } catch (error) {
        console.error('Erro ao atualizar entregador:', error);
        res.status(500).json({ 
            success: false,
            message: 'Erro ao atualizar entregador',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// Deletar um entregador
exports.delete = async (req, res) => {
    try {
        const { id } = req.params;
        const entregador = await Entregador.findByPk(id);
        
        if (!entregador) {
            return res.status(404).json({ 
                success: false,
                message: 'Entregador não encontrado',
                searchedId: id
            });
        }
        
        await entregador.destroy();
        
        res.status(200).json({ 
            success: true,
            message: 'Entregador deletado com sucesso',
            deletedId: id,
        });
        
    } catch (error) {
        console.error('Erro ao deletar entregador:', error);
        res.status(500).json({ 
            success: false,
            message: 'Erro ao deletar entregador',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};