CREATE TABLE IF NOT EXISTS pacote (
    id_pacote SERIAL PRIMARY KEY,
    nr_pacote INTEGER NOT NULL UNIQUE,
    empresa_origem VARCHAR(100) NOT NULL,
    endereco_entrega VARCHAR(255) NOT NULL,
    data_entrega TIMESTAMP NOT NULL,
    data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
	