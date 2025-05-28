const Pacote = require('../models/Pacote');

exports.create = async (req, res) => {
  try {
    const { nr_pacote, empresa_origem, endereco_entrega, data_entrega } = req.body;
    if (!nr_pacote || !empresa_origem || !endereco_entrega || !data_entrega) {
      return res.status(400).json({ message: 'Todos os campos são obrigatórios.' });
    }

    const pacote = await Pacote.create({
      nr_pacote,
      empresa_origem,
      endereco_entrega,
      data_entrega
    });

    return res.status(201).json({ message: 'Pacote cadastrado com sucesso.', pacote });
  } catch (error) {
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(409).json({ message: 'Número do pacote já cadastrado.' });
    }
    console.error('Erro ao cadastrar pacote:', error);
    return res.status(500).json({ message: 'Erro ao cadastrar pacote.' });
  }
};

exports.findAll = async (req, res) => {
  try {
    const pacotes = await Pacote.findAll({ order: [['data_cadastro', 'DESC']] });
    return res.json({ pacotes });
  } catch (error) {
    console.error('Erro ao listar pacotes:', error);
    return res.status(500).json({ message: 'Erro ao listar pacotes.' });
  }
};
