# LevExpress
Aplicativo mobile para entregadores autônomos 

# Nomenclatura e Padrões do Projeto

## Convenções de Nomenclatura

### Branches
- **Formato**: `nome_da_tarefa_id`
- Exemplo: `cadastro_usuario_123`, `correcao_bug_login_456`

### Variáveis
- **Padrão**: `snake_case`
- Exemplo: 
  ```dart
  bool usuario_logado = true;
  const quantidade_produtos = 10;
  ```

### Banco de Dados
- **Padrão**: `snake_case`
- Exemplo:
  ```sql
  CREATE TABLE usuarios (
      id SERIAL PRIMARY KEY,
      nome_completo VARCHAR(100),
      data_cadastro TIMESTAMP
  );
  ```

## Arquitetura (MVC)
```
📦 projeto
├── 📂 models         # Lógica de negócios e acesso a dados
├── 📂 views          # Interface do usuário
├── 📂 controllers    # Intermediários entre models e views
└── 📂 config         # Configurações do projeto
```

## Padrão de commits
1. fix: a commit of the type fix patches a bug in your codebase.
2. feat: a commit of the type feat introduces a new feature to the codebase.
3. BREAKING CHANGE: a commit that has a footer BREAKING CHANGE:, or appends a ! after the type/scope, introduces a breaking API change. A BREAKING CHANGE can be part of commits of any type.


## Como Contribuir
1. Crie uma branch seguindo o padrão `nome_da_tarefa_id`
2. Respeite as convenções de nomenclatura
3. Mantenha a estrutura MVC
4. Envie Pull Requests com descrição clara
