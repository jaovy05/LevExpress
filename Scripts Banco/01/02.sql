
CREATE TABLE IF NOT EXISTS login (
    id_entregador INTEGER NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    status BOOLEAN NOT NULL DEFAULT true,
    PRIMARY KEY (id_entregador),
    CONSTRAINT fk_entregador
        FOREIGN KEY (id_entregador) 
        REFERENCES entregador(id),
    CONSTRAINT email_unique UNIQUE (email)
);