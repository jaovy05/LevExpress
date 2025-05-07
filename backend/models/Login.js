// models/Login.js
const { DataTypes } = require('sequelize');
const sequelize = require('../database');
const Entregador = require('./Entregador');

const Login = sequelize.define('Login', {
    id_entregador: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        references: {
            model: Entregador,
            key: 'id'
        }
    },
    email: {
        type: DataTypes.STRING(255),
        allowNull: false,
        unique: true,
        validate: {
            isEmail: true
        }
    },
    senha: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    status: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: true
    }
}, {
    tableName: 'login',
    timestamps: false
});

// Definindo a associação
Entregador.hasOne(Login, { foreignKey: 'id_entregador' });
Login.belongsTo(Entregador, { foreignKey: 'id_entregador' });

module.exports = Login;