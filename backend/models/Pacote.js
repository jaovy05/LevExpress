const { DataTypes } = require('sequelize');
const sequelize = require('../database');

const Pacote = sequelize.define('Pacote', {
  id_pacote: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  nr_pacote: {
    type: DataTypes.INTEGER,
    allowNull: false,
    unique: true
  },
  empresa_origem: {
    type: DataTypes.STRING(100),
    allowNull: false
  },
  endereco_entrega: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  data_entrega: {
    type: DataTypes.DATE,
    allowNull: false
  },
  data_cadastro: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'pacote',
  timestamps: false
});

module.exports = Pacote;
