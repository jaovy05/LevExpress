// controllers/entregador.js
const Entregador = require('../models/Entregador.js');

// Criar um novo entregador
exports.create = async (req, res) => {
    try {
        const { cnh, nome } = req.body;
        
        // Validação simples
        if (!cnh || !nome) {
            return res.status(400).json({ error: 'CNH e nome são obrigatórios' });
        }
        
        if (cnh.length !== 11) {
            return res.status(400).json({ error: 'CNH deve ter exatamente 11 caracteres' });
        }
        
        const novoEntregador = await Entregador.create({ cnh, nome });
        res.status(201).json(novoEntregador);
    } catch (error) {
        console.error('Erro ao criar entregador:', error);
        res.status(500).json({ error: 'Erro ao criar entregador' });
    }
};

// Listar todos os entregadores
exports.findAll = async (req, res) => {
    try {
        const entregadores = await Entregador.findAll();
        res.json(entregadores);
    } catch (error) {
        console.error('Erro ao buscar entregadores:', error);
        res.status(500).json({ error: 'Erro ao buscar entregadores' });
    }
};

// Buscar um entregador por ID
exports.findOne = async (req, res) => {
    try {
        const { id } = req.params;
        const entregador = await Entregador.findByPk(id);
    
        if (!entregador) {
            return res.status(404).json({ error: 'Entregador não encontrado' });
        }
        
        res.json(entregador);
    } catch (error) {
        console.error('Erro ao buscar entregador:', error);
        res.status(500).json({ error: 'Erro ao buscar entregador' });
    }
};

// Atualizar um entregador
exports.update = async (req, res) => {
    try {
        const { id } = req.params;
        const { cnh, nome } = req.body;
        
        const entregador = await Entregador.findByPk(id);
        
        if (!entregador) {
            return res.status(404).json({ error: 'Entregador não encontrado' });
        }
        
        // Validações
        if (cnh && cnh.length !== 11) {
            return res.status(400).json({ error: 'CNH deve ter exatamente 9 caracteres' });
        }
        
        await entregador.update({ cnh, nome });
        res.json(entregador);
    } catch (error) {
        console.error('Erro ao atualizar entregador:', error);
        res.status(500).json({ error: 'Erro ao atualizar entregador' });
    }
};

// Deletar um entregador
exports.delete = async (req, res) => {
    try {
        const { id } = req.params;
        const entregador = await Entregador.findByPk(id);
        
        if (!entregador) {
            return res.status(404).json({ error: 'Entregador não encontrado' });
        }
        
        await entregador.destroy();
        res.status(204).send(); // No content
    } catch (error) {
        console.error('Erro ao deletar entregador:', error);
        res.status(500).json({ error: 'Erro ao deletar entregador' });
    }
};  