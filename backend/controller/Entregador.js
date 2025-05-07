// controllers/entregador.js
const Entregador = require('../models/Entregador');

// Criar um novo entregador
exports.create = async (req, res) => {
    try {
        const { cnh, nome } = req.body;
        
        // Validação simples
        if (!cnh || !nome) {
            return res.status(400).json({ 
                success: false,
                message: 'CNH e nome são obrigatórios',
                requiredFields: ['cnh', 'nome']
            });
        }
        
        if (cnh.length !== 11) {
            return res.status(400).json({ 
                success: false,
                message: 'CNH deve ter exatamente 11 caracteres',
                invalidField: 'cnh',
                expectedLength: 11
            });
        }
        
        const novoEntregador = await Entregador.create({ cnh, nome });
        
        res.status(201).json({
            success: true,
            message: 'Entregador criado com sucesso',
            data: novoEntregador
        });
        
    } catch (error) {
        console.error('Erro ao criar entregador:', error);
        res.status(500).json({ 
            success: false,
            message: 'Erro ao criar entregador',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined,
            details: process.env.NODE_ENV === 'development' ? { sql: error.sql } : undefined
        });
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
            count: entregadores.length,
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