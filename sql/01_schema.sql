-- ============================================================
-- Sistema de Gestão para Provedor de Internet (NetVeloz)
-- Script de criação do banco e das tabelas (MySQL / InnoDB)
-- Execute este script ANTES do script de povoamento.
-- ============================================================

CREATE DATABASE IF NOT EXISTS provedor_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE provedor_db;

-- Tabelas independentes (sem chave estrangeira)
CREATE TABLE cidade (
  id_cidade INT AUTO_INCREMENT PRIMARY KEY,
  nome      VARCHAR(80) NOT NULL,
  uf        CHAR(2)     NOT NULL
) ENGINE=InnoDB;

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  cpf        CHAR(11)     NOT NULL UNIQUE,
  nome       VARCHAR(100) NOT NULL,
  telefone   VARCHAR(15),
  email      VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE plano (
  id_plano        INT AUTO_INCREMENT PRIMARY KEY,
  nome            VARCHAR(50)   NOT NULL,
  velocidade_mbps INT           NOT NULL,
  valor_mensal    DECIMAL(8,2)  NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tecnico (
  id_tecnico INT AUTO_INCREMENT PRIMARY KEY,
  nome       VARCHAR(100) NOT NULL,
  telefone   VARCHAR(15)
) ENGINE=InnoDB;

-- Tabelas dependentes
CREATE TABLE endereco (
  id_endereco INT AUTO_INCREMENT PRIMARY KEY,
  id_cidade   INT          NOT NULL,
  logradouro  VARCHAR(100) NOT NULL,
  numero      VARCHAR(10),
  complemento VARCHAR(50),
  bairro      VARCHAR(60),
  cep         CHAR(8),
  CONSTRAINT fk_endereco_cidade
    FOREIGN KEY (id_cidade) REFERENCES cidade (id_cidade)
) ENGINE=InnoDB;

CREATE TABLE contrato (
  id_contrato    INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente     INT         NOT NULL,
  id_plano       INT         NOT NULL,
  id_endereco    INT         NOT NULL,
  data_inicio    DATE        NOT NULL,
  dia_vencimento INT         NOT NULL,
  status         VARCHAR(15) NOT NULL,
  CONSTRAINT fk_contrato_cliente  FOREIGN KEY (id_cliente)  REFERENCES cliente  (id_cliente),
  CONSTRAINT fk_contrato_plano    FOREIGN KEY (id_plano)    REFERENCES plano    (id_plano),
  CONSTRAINT fk_contrato_endereco FOREIGN KEY (id_endereco) REFERENCES endereco (id_endereco)
) ENGINE=InnoDB;

CREATE TABLE fatura (
  id_fatura       INT AUTO_INCREMENT PRIMARY KEY,
  id_contrato     INT          NOT NULL,
  mes_referencia  DATE         NOT NULL,
  valor           DECIMAL(8,2) NOT NULL,
  data_vencimento DATE         NOT NULL,
  status          VARCHAR(15)  NOT NULL,
  CONSTRAINT fk_fatura_contrato FOREIGN KEY (id_contrato) REFERENCES contrato (id_contrato)
) ENGINE=InnoDB;

CREATE TABLE pagamento (
  id_pagamento    INT AUTO_INCREMENT PRIMARY KEY,
  id_fatura       INT          NOT NULL,
  data_pagamento  DATE         NOT NULL,
  valor_pago      DECIMAL(8,2) NOT NULL,
  forma_pagamento VARCHAR(20)  NOT NULL,
  CONSTRAINT fk_pagamento_fatura FOREIGN KEY (id_fatura) REFERENCES fatura (id_fatura)
) ENGINE=InnoDB;

CREATE TABLE chamado_suporte (
  id_chamado         INT AUTO_INCREMENT PRIMARY KEY,
  id_contrato        INT         NOT NULL,
  id_tecnico         INT         NOT NULL,
  descricao_problema TEXT        NOT NULL,
  data_abertura      DATE        NOT NULL,
  status             VARCHAR(15) NOT NULL,
  diagnostico        TEXT,
  solucao            TEXT,
  data_conclusao     DATE,
  CONSTRAINT fk_chamado_contrato FOREIGN KEY (id_contrato) REFERENCES contrato (id_contrato),
  CONSTRAINT fk_chamado_tecnico  FOREIGN KEY (id_tecnico)  REFERENCES tecnico  (id_tecnico)
) ENGINE=InnoDB;
