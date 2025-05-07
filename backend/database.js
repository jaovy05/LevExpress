require('dotenv').config();
const { Sequelize } = require('sequelize');

// Pegando variáveis do ambiente
const { USUARIO, HOST, DATABASE, PASSWORD, PORT } = process.env;

// Criando a instância do Sequelize
const sequelize = new Sequelize(DATABASE, USUARIO, PASSWORD, {
    host: HOST,
    dialect: 'postgres',
    port: PORT,
    logging: console.log, // Opcional: mostra queries no console
});

// Testando a conexão
sequelize.authenticate()
    .then(() => console.log('Conexão com o banco de dados bem-sucedida!'))
    .catch(err => console.error('Erro ao conectar ao banco de dados:', err));

module.exports = sequelize;
