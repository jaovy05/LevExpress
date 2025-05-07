require('dotenv').config();
const { Sequelize } = require('sequelize');

// Pegando variáveis do ambiente
const { USUARIO, HOST, DATABASE, PASSWORD, PORT } = process.env;

// Criando a instância do Sequelize
const sequelize = new Sequelize({
    database: process.env.DATABASE,
    username: process.env.USUARIO,
    password: String(process.env.PASSWORD), // Força conversão para string
    host: process.env.HOST,
    port: process.env.PORT,
    dialect: 'postgres',
    dialectOptions: {
      ssl: false
    }
  });

// Testando a conexão
sequelize.authenticate()
    .then(() => console.log('Conexão com o banco de dados bem-sucedida!'))
    .catch(err => console.error('Erro ao conectar ao banco de dados:', err));

module.exports = sequelize;
