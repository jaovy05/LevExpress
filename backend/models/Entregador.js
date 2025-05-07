    // models/Entregador.js
const { DataTypes } = require('sequelize');
const sequelize = require('../database'); // Ajuste o caminho conforme necessário

const Entregador = sequelize.define('Entregador', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  cnh: {
    type: DataTypes.CHAR(9),
    allowNull: false,
    unique: true
  },
  nome: {
    type: DataTypes.STRING(255),
    allowNull: false
  }
}, {
  tableName: 'entregador',
  timestamps: false // assumindo que não quer created_at e updated_at
});

module.exports = Entregador;