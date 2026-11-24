-- ============================================================
-- Script de povoamento (INSERT) - Provedor de Internet
-- Ordem hierárquica: tabelas pai primeiro, tabelas filhas depois,
-- para respeitar as chaves estrangeiras (integridade referencial).
-- Os ids são informados de forma explícita para que as chaves
-- estrangeiras apontem, sem ambiguidade, para os registros certos.
-- ============================================================

USE provedor_db;

-- ------------------------------------------------------------
-- 1) CIDADE (independente)
-- ------------------------------------------------------------
INSERT INTO cidade (id_cidade, nome, uf) VALUES
  (1, 'Campinas',       'SP'),
  (2, 'Santos',         'SP'),
  (3, 'Curitiba',       'PR'),
  (4, 'Belo Horizonte', 'MG');

-- ------------------------------------------------------------
-- 2) CLIENTE (independente). CPF único; telefone e e-mail opcionais.
-- ------------------------------------------------------------
INSERT INTO cliente (id_cliente, cpf, nome, telefone, email) VALUES
  (1, '11122233344', 'Ana Beatriz Souza',    '(19) 99111-2233', 'ana.souza@email.com'),
  (2, '22233344455', 'Carlos Eduardo Lima',  '(19) 99222-3344', 'carlos.lima@email.com'),
  (3, '33344455566', 'Mariana Ribeiro',      '(13) 99333-4455', 'mariana.ribeiro@email.com'),
  (4, '44455566677', 'Rafael Almeida',       '(41) 99444-5566', NULL),
  (5, '55566677788', 'Juliana Ferreira',     '(31) 99555-6677', 'juliana.ferreira@email.com'),
  (6, '66677788899', 'Pedro Henrique Costa', NULL,              'pedro.costa@email.com');

-- ------------------------------------------------------------
-- 3) PLANO (independente)
-- ------------------------------------------------------------
INSERT INTO plano (id_plano, nome, velocidade_mbps, valor_mensal) VALUES
  (1, 'Fibra 100',  100,   79.90),
  (2, 'Fibra 300',  300,   99.90),
  (3, 'Fibra 500',  500,  129.90),
  (4, 'Fibra 1000', 1000, 199.90);

-- ------------------------------------------------------------
-- 4) TECNICO (independente)
-- ------------------------------------------------------------
INSERT INTO tecnico (id_tecnico, nome, telefone) VALUES
  (1, 'Lucas Martins',  '(19) 98111-0001'),
  (2, 'Fernanda Rocha', '(13) 98222-0002'),
  (3, 'Thiago Nunes',   '(41) 98333-0003');

-- ------------------------------------------------------------
-- 5) ENDERECO (depende de CIDADE)
-- ------------------------------------------------------------
INSERT INTO endereco (id_endereco, id_cidade, logradouro, numero, complemento, bairro, cep) VALUES
  (1, 1, 'Rua das Palmeiras',    '120',  NULL,       'Jardim Primavera', '13010100'),
  (2, 1, 'Avenida Brasil',       '2050', 'Apto 304', 'Centro',           '13015200'),
  (3, 2, 'Rua Bahia',            '85',   NULL,       'Gonzaga',          '11055100'),
  (4, 3, 'Rua XV de Novembro',   '430',  'Sala 2',   'Centro',           '80020310'),
  (5, 4, 'Avenida Afonso Pena',  '1500', 'Bloco B',  'Funcionários',     '30130003'),
  (6, 1, 'Rua dos Ipês',         '77',   NULL,       'Taquaral',         '13076000'),
  (7, 2, 'Rua Pernambuco',       '310',  NULL,       'Boqueirão',        '11055200');

-- ------------------------------------------------------------
-- 6) CONTRATO (depende de CLIENTE, PLANO e ENDERECO)
-- Observação: a cliente 1 possui dois contratos, em endereços diferentes.
-- ------------------------------------------------------------
INSERT INTO contrato (id_contrato, id_cliente, id_plano, id_endereco, data_inicio, dia_vencimento, status) VALUES
  (1, 1, 2, 1, '2025-03-10', 10, 'ativo'),
  (2, 1, 1, 2, '2025-09-15', 15, 'ativo'),
  (3, 2, 3, 6, '2025-06-20', 25, 'ativo'),
  (4, 3, 2, 3, '2025-11-05',  5, 'ativo'),
  (5, 4, 4, 4, '2026-01-12', 12, 'suspenso'),
  (6, 5, 1, 5, '2024-08-01',  1, 'cancelado'),
  (7, 6, 3, 7, '2026-04-18', 18, 'ativo');

-- ------------------------------------------------------------
-- 7) FATURA (depende de CONTRATO)
-- O valor é gravado na fatura para preservar o histórico, mesmo que
-- o preço do plano mude depois.
-- ------------------------------------------------------------
INSERT INTO fatura (id_fatura, id_contrato, mes_referencia, valor, data_vencimento, status) VALUES
  (1,  1, '2026-10-01',  99.90, '2026-10-10', 'paga'),
  (2,  1, '2026-11-01',  99.90, '2026-11-10', 'em atraso'),
  (3,  2, '2026-10-01',  79.90, '2026-10-15', 'paga'),
  (4,  2, '2026-11-01',  79.90, '2026-11-15', 'em atraso'),
  (5,  3, '2026-10-01', 129.90, '2026-10-25', 'paga'),
  (6,  3, '2026-11-01', 129.90, '2026-11-25', 'aberta'),
  (7,  4, '2026-11-01',  99.90, '2026-11-05', 'paga'),
  (8,  7, '2026-10-01', 129.90, '2026-10-18', 'paga'),
  (9,  7, '2026-11-01', 129.90, '2026-11-18', 'paga'),
  (10, 5, '2026-10-01', 199.90, '2026-10-12', 'em atraso');

-- ------------------------------------------------------------
-- 8) PAGAMENTO (depende de FATURA)
-- A fatura 5 foi quitada em dois pagamentos parciais (60,00 + 69,90).
-- ------------------------------------------------------------
INSERT INTO pagamento (id_pagamento, id_fatura, data_pagamento, valor_pago, forma_pagamento) VALUES
  (1, 1, '2026-10-09',  99.90, 'PIX'),
  (2, 3, '2026-10-14',  79.90, 'Boleto'),
  (3, 5, '2026-10-20',  60.00, 'PIX'),
  (4, 5, '2026-10-25',  69.90, 'Cartão de crédito'),
  (5, 7, '2026-11-04',  99.90, 'PIX'),
  (6, 8, '2026-10-17', 129.90, 'Boleto'),
  (7, 9, '2026-11-18', 129.90, 'PIX');

-- ------------------------------------------------------------
-- 9) CHAMADO_SUPORTE (depende de CONTRATO e TECNICO)
-- Chamados abertos ainda não têm diagnóstico, solução nem data de
-- conclusão, por isso esses campos recebem NULL.
-- ------------------------------------------------------------
INSERT INTO chamado_suporte
  (id_chamado, id_contrato, id_tecnico, descricao_problema, data_abertura, status, diagnostico, solucao, data_conclusao) VALUES
  (1, 1, 1, 'Internet lenta no período da noite', '2026-09-12', 'encerrado',
      'Interferência no canal do roteador Wi-Fi', 'Troca de canal e atualização do firmware do roteador', '2026-09-13'),
  (2, 2, 1, 'Sem conexão desde ontem', '2026-10-20', 'encerrado',
      'Cabo de fibra danificado no acesso externo', 'Substituição do cabo drop', '2026-10-22'),
  (3, 3, 1, 'Quedas frequentes de conexão', '2026-11-10', 'em andamento',
      'Sinal óptico abaixo do esperado', NULL, NULL),
  (4, 4, 2, 'Roteador não liga', '2026-11-14', 'aberto', NULL, NULL, NULL),
  (5, 5, 3, 'Sinal fraco de Wi-Fi após a instalação', '2026-01-14', 'encerrado',
      'Roteador posicionado longe dos cômodos', 'Reposicionamento e instalação de repetidor', '2026-01-15'),
  (6, 7, 2, 'Dificuldade para acessar o painel do roteador', '2026-11-19', 'aberto', NULL, NULL, NULL);
