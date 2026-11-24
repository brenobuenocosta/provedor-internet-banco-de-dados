-- ============================================================
-- Exclusões (DELETE) - Provedor de Internet
-- Regra de integridade referencial: um registro "pai" só pode ser
-- apagado depois que os registros "filhos" que o referenciam forem
-- tratados. Por isso a ordem dos comandos abaixo é importante
-- (do mais dependente para o menos dependente).
-- ============================================================

USE provedor_db;

-- ------------------------------------------------------------
-- DELETE 1: remove o chamado 5, já encerrado e antigo.
-- CHAMADO_SUPORTE não é referenciada por nenhuma outra tabela,
-- portanto a exclusão é permitida.
-- ------------------------------------------------------------
DELETE FROM chamado_suporte
WHERE id_chamado = 5
  AND status = 'encerrado';

-- ------------------------------------------------------------
-- DELETE 2: remove o técnico 3 (Thiago Nunes), desligado da empresa.
-- Só é possível porque o DELETE 1 apagou o único chamado dele.
-- Se este comando fosse executado ANTES do DELETE 1, o MySQL recusaria
-- (erro 1451, violação de chave estrangeira).
-- ------------------------------------------------------------
DELETE FROM tecnico
WHERE id_tecnico = 3;

-- ------------------------------------------------------------
-- DELETE 3: remove o contrato 6, cancelado e sem faturas nem chamados.
-- O filtro por status evita apagar, por engano, um contrato ativo.
-- ------------------------------------------------------------
DELETE FROM contrato
WHERE id_contrato = 6
  AND status = 'cancelado';

-- ------------------------------------------------------------
-- DELETE 4: remove a cliente 5 (Juliana), que ficou sem nenhum contrato
-- depois do DELETE 3. Antes disso, o banco impediria a exclusão.
-- ------------------------------------------------------------
DELETE FROM cliente
WHERE id_cliente = 5;

-- ------------------------------------------------------------
-- Exemplo de exclusão que o banco IMPEDE (mantido como comentário):
-- DELETE FROM cliente WHERE id_cliente = 1;
-- A cliente 1 possui contratos. O MySQL retorna o erro 1451
-- ("Cannot delete or update a parent row: a foreign key constraint fails"),
-- protegendo o histórico contra registros órfãos.
-- ------------------------------------------------------------
