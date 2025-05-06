const { Client } = require('pg');
const fs = require('fs');

// Configuração do banco de dados
const client = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'postgres',
    password: 'postgres',
    port: 5432,
});

// Função para rodar arquivos SQL sem `async/await`
function executarSQL(filePath) {
    client.connect(function(err) {
        if (err) {
            console.error('Erro ao conectar ao banco de dados:', err);
            return;
        }
        console.log('Conectado ao banco de dados.');

        const sql = fs.readFileSync(filePath, 'utf-8');

        client.query(sql, function(err) {
            if (err) {
                console.error(`Erro ao executar ${filePath}:`, err);
            } else {
                console.log(`Arquivo ${filePath} executado com sucesso.`);
            }
            client.end();
        });
    });
}

// Pega argumentos do terminal (exemplo: `node atualizador 01 12`)
const inicio = parseInt(process.argv[2]);
const fim = parseInt(process.argv[3]);

if (!inicio || !fim) {
    console.log('Uso correto: node atualizador <inicio> <fim>');
    process.exit(1);
}

for (let i = inicio; i <= fim; i++) {
    const filePath = `${String(i).padStart(2, '0')}.sql`;
    executarSQL(filePath);
}
