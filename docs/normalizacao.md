# Normalização do modelo

O DER inicial tinha 7 tabelas (`cliente`, `plano`, `contrato`, `fatura`, `pagamento`, `chamado_suporte` e `tecnico`). Após a auditoria em três rodadas, o modelo final tem 9 tabelas.

| | DER inicial | DER final (3FN) |
|---|---|---|
| Diagrama | [der_inicial.png](der_inicial.png) | [der_final_3fn.png](der_final_3fn.png) |
| Tabelas | 7 | 9 (novas: `endereco` e `cidade`) |

## 1FN: atomicidade
**Problema:** `cliente.endereco_instalacao` (VARCHAR(200)) guardava logradouro, número, complemento, bairro, cidade e CEP em um único valor. Isso impede buscar por cidade ou bairro sem decompor o texto.

**Correção:** o campo saiu de `cliente` e passou a existir como a tabela `endereco`, com uma coluna para cada informação.

## 2FN: dependência parcial
**Análise:** a 2FN só se aplica a tabelas com chave primária composta. Todas as tabelas do modelo usam chave simples (`id_...`), portanto não há dependência parcial e nenhuma tabela foi criada por causa desta regra.

**Decisão de projeto relacionada:** `contrato` tem chave própria (`id_contrato`) em vez de uma chave composta por cliente e plano, porque o mesmo cliente pode contratar o mesmo plano mais de uma vez (por exemplo, em endereços diferentes).

**Ajuste de modelagem (não é 2FN):** o endereço de instalação pertence ao contrato, e não ao cliente. Por isso `contrato` recebeu a chave estrangeira `id_endereco`.

## 3FN: dependência transitiva
**Problema:** em `endereco`, a UF dependia da cidade (`id_endereco -> cidade -> uf`), repetindo cidade e UF em cada endereço e gerando anomalias de inserção, atualização e exclusão.

**Correção:** criação da tabela `cidade` (`id_cidade`, `nome`, `uf`). `endereco` passou a guardar apenas a chave estrangeira `id_cidade`.

## Redundâncias mantidas de propósito
- `fatura.valor` e `fatura.data_vencimento` poderiam ser calculados a partir do plano e do contrato, mas são mantidos como histórico: se o preço do plano mudar, as faturas já emitidas não podem mudar.
- O CEP é mantido como atributo do endereço, sem tabela própria. Na prática o CEP determina logradouro e bairro em muitas cidades, mas não de forma uniforme, e decompor mais traria complexidade sem ganho nesta fase.
