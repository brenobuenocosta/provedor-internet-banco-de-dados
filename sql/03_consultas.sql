-- ============================================================
-- Consultas exploratórias (SELECT) - Provedor de Internet
-- Cada consulta usa JOIN e as cláusulas WHERE, ORDER BY e LIMIT.
-- ============================================================

USE provedor_db;

-- ------------------------------------------------------------
-- Consulta 1: contratos ativos, com cliente, plano e cidade de instalação.
-- Objetivo: listar a carteira ativa dos planos mais caros para os mais baratos.
-- JOIN encadeado: contrato -> cliente, plano, endereco -> cidade.
-- ------------------------------------------------------------
SELECT c.id_contrato,
       cl.nome        AS cliente,
       p.nome         AS plano,
       p.valor_mensal,
       ci.nome        AS cidade
FROM contrato c
INNER JOIN cliente  cl ON cl.id_cliente  = c.id_cliente
INNER JOIN plano    p  ON p.id_plano     = c.id_plano
INNER JOIN endereco e  ON e.id_endereco  = c.id_endereco
INNER JOIN cidade   ci ON ci.id_cidade   = e.id_cidade
WHERE c.status = 'ativo'
ORDER BY p.valor_mensal DESC, cl.nome ASC
LIMIT 5;

-- ------------------------------------------------------------
-- Consulta 2: faturas em atraso, com o cliente responsável.
-- Objetivo: apoiar a cobrança, listando primeiro as mais antigas.
-- ------------------------------------------------------------
SELECT f.id_fatura,
       cl.nome AS cliente,
       cl.telefone,
       f.valor,
       f.data_vencimento
FROM fatura f
INNER JOIN contrato c  ON c.id_contrato = f.id_contrato
INNER JOIN cliente  cl ON cl.id_cliente = c.id_cliente
WHERE f.status = 'em atraso'
ORDER BY f.data_vencimento ASC
LIMIT 10;

-- ------------------------------------------------------------
-- Consulta 3: total pago por cliente a partir de outubro de 2026.
-- Objetivo: identificar os clientes que mais pagaram no período.
-- Usa GROUP BY com SUM e junta quatro tabelas (cliente até pagamento).
-- ------------------------------------------------------------
SELECT cl.nome       AS cliente,
       COUNT(*)      AS qtd_pagamentos,
       SUM(pg.valor_pago) AS total_pago
FROM cliente cl
INNER JOIN contrato  c  ON c.id_cliente  = cl.id_cliente
INNER JOIN fatura    f  ON f.id_contrato = c.id_contrato
INNER JOIN pagamento pg ON pg.id_fatura  = f.id_fatura
WHERE pg.data_pagamento >= '2026-10-01'
GROUP BY cl.id_cliente, cl.nome
ORDER BY total_pago DESC
LIMIT 3;

-- ------------------------------------------------------------
-- Consulta 4: chamados ainda não encerrados, com técnico e cliente.
-- Objetivo: acompanhar a fila de suporte, do chamado mais antigo ao mais novo.
-- ------------------------------------------------------------
SELECT ch.id_chamado,
       cl.nome AS cliente,
       t.nome  AS tecnico,
       ch.descricao_problema,
       ch.data_abertura,
       ch.status
FROM chamado_suporte ch
INNER JOIN contrato c  ON c.id_contrato = ch.id_contrato
INNER JOIN cliente  cl ON cl.id_cliente = c.id_cliente
INNER JOIN tecnico  t  ON t.id_tecnico  = ch.id_tecnico
WHERE ch.status IN ('aberto', 'em andamento')
ORDER BY ch.data_abertura ASC
LIMIT 10;

-- ------------------------------------------------------------
-- Consulta 5: quantidade de contratos ativos por plano.
-- Objetivo: saber a popularidade de cada plano. O LEFT JOIN mantém
-- planos sem nenhum contrato ativo, que aparecem com contagem zero.
-- ------------------------------------------------------------
SELECT p.nome AS plano,
       p.velocidade_mbps,
       COUNT(c.id_contrato) AS contratos_ativos
FROM plano p
LEFT JOIN contrato c ON c.id_plano = p.id_plano AND c.status = 'ativo'
GROUP BY p.id_plano, p.nome, p.velocidade_mbps
ORDER BY contratos_ativos DESC, p.velocidade_mbps ASC
LIMIT 4;
