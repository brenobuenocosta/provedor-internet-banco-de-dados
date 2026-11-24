# Roteiro para levar o projeto à nuvem

Ideias de evolução do projeto, em ordem sugerida. Cada etapa reaproveita o que já existe no repositório.

## 1. Banco gerenciado na nuvem
Executar os mesmos scripts de `sql/` em um MySQL gerenciado (por exemplo, Amazon RDS for MySQL). Os scripts não precisam mudar: basta conectar ao endpoint do banco.

Cuidados:
- Restringir o acesso pelo Security Group ao seu IP, nunca a qualquer origem.
- Não guardar senha no repositório. Usar um gerenciador de segredos (AWS Secrets Manager ou GitHub Secrets).
- Conferir na documentação da AWS o que está no nível gratuito atual e desligar ou apagar a instância ao terminar, para evitar custos.

## 2. Infraestrutura como código
Criar uma pasta `infra/` e descrever o banco (instância, rede, Security Group) com Terraform ou CloudFormation, em vez de criar tudo pelo console. Assim o ambiente pode ser recriado e destruído com um comando.

## 3. Automação (CI/CD)
- O workflow `.github/workflows/test-sql.yml` já valida os scripts a cada push.
- Evolução: aplicar as alterações de esquema no banco da nuvem com uma ferramenta de migração (Flyway ou Liquibase), em vez de rodar arquivos manualmente.

## 4. Segurança e operação
- Criar um usuário de aplicação com privilégios mínimos (`GRANT` apenas do necessário), em vez de usar o `root`.
- Habilitar backups automáticos e testar uma restauração.
- Habilitar criptografia em repouso e conexão com TLS.

## 5. Comparar com NoSQL
Modelar o mesmo domínio no DynamoDB, partindo dos padrões de acesso (por exemplo, "faturas em aberto de um cliente") em vez das entidades. É um bom exercício para entender o que muda ao abrir mão da normalização.

## 6. Camada de aplicação
Criar uma API simples (por exemplo, em Python ou Node.js) que consulte o banco, e implantá-la em um serviço gerenciado, completando o fluxo aplicação, banco e nuvem.
