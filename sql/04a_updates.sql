-- ============================================================
-- Atualizações (UPDATE) - Provedor de Internet
-- Todos os comandos usam WHERE com a chave primária, para alterar
-- somente o registro desejado (sem WHERE, a tabela inteira mudaria).
-- ============================================================

USE provedor_db;

-- ------------------------------------------------------------
-- UPDATE 1: atualização cadastral.
-- A cliente Ana (id 1) informou novo telefone e novo e-mail.
-- ------------------------------------------------------------
UPDATE cliente
SET telefone = '(19) 99888-7766',
    email    = 'ana.souza@novoemail.com'
WHERE id_cliente = 1;

-- ------------------------------------------------------------
-- UPDATE 2: reajuste de preço do plano Fibra 300 (id 2) de 99,90 para 109,90.
-- As faturas já emitidas NÃO mudam, pois guardam o valor cobrado na época.
-- ------------------------------------------------------------
UPDATE plano
SET valor_mensal = 109.90
WHERE id_plano = 2;

-- ------------------------------------------------------------
-- UPDATE 3: encerramento de chamado.
-- O técnico concluiu o atendimento do chamado 3: registra diagnóstico final,
-- solução aplicada, data de conclusão e muda o status para 'encerrado'.
-- ------------------------------------------------------------
UPDATE chamado_suporte
SET status         = 'encerrado',
    diagnostico    = 'Conector óptico com sujeira e sinal abaixo do esperado',
    solucao        = 'Limpeza do conector e troca do cordão óptico',
    data_conclusao = '2026-11-21'
WHERE id_chamado = 3
  AND status = 'em andamento';

-- ------------------------------------------------------------
-- UPDATE 4: mudança do dia de vencimento a pedido do cliente.
-- O contrato 4 passa a vencer no dia 20. As próximas faturas usarão a nova data.
-- ------------------------------------------------------------
UPDATE contrato
SET dia_vencimento = 20
WHERE id_contrato = 4;
