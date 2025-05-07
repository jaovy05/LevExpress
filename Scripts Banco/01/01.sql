create database lev_express 

CREATE TABLE IF NOT EXISTS entregador (
    id SERIAL PRIMARY KEY,
    cnh CHAR(11) NOT NULL UNIQUE,
    nome VARCHAR(255) NOT NULL
);