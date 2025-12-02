-------------------------------------------------------------------------
-- SEÇÃO 1: LIMPEZA E CRIAÇÃO DA ESTRUTURA (DDL)
-------------------------------------------------------------------------

-- Remove tabelas antigas (na ordem inversa das dependências para evitar erros)
DROP VIEW IF EXISTS vw_auditoria_precos_suspeitos;
DROP VIEW IF EXISTS vw_relatorio_horarios_pico;
DROP VIEW IF EXISTS vw_relatorio_combustivel_popular;
DROP VIEW IF EXISTS vw_relatorio_faturamento_diario;
DROP VIEW IF EXISTS vw_relatorio_ranking_funcionarios;
DROP VIEW IF EXISTS resumo_venda_combustivel;
DROP TABLE IF EXISTS venda_item;
DROP TABLE IF EXISTS venda;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS combustivel;

-- 1. Tabela Combustível (Produtos)
CREATE TABLE combustivel (
  combustivel_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  estoque_l NUMERIC(12,3) NOT NULL DEFAULT 0, -- 3 casas decimais para litros
  CONSTRAINT combustivel_nome_uniq UNIQUE (nome)
);

-- 2. Tabela Funcionário
CREATE TABLE funcionario (
  funcionario_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  ativo BOOLEAN NOT NULL DEFAULT true
);

-- 3. Tabela Venda (Cabeçalho da nota)
CREATE TABLE venda (
  venda_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  data_hora TIMESTAMPTZ NOT NULL DEFAULT now(),
  funcionario_id INT REFERENCES funcionario(funcionario_id) ON DELETE SET NULL,
  total NUMERIC(12,2) NOT NULL CHECK (total >= 0) -- Validação de valor positivo
);

-- 4. Tabela Itens da Venda (Detalhes do cupom)
CREATE TABLE venda_item (
  venda_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  venda_id INT NOT NULL REFERENCES venda(venda_id) ON DELETE CASCADE,
  combustivel_id INT NOT NULL REFERENCES combustivel(combustivel_id),
  quantidade_l NUMERIC(12,3) NOT NULL CHECK (quantidade_l >= 0),
  preco_unitario NUMERIC(12,4) NOT NULL CHECK (preco_unitario >= 0)
);

-- Índices para otimizar relatórios
CREATE INDEX idx_venda_data_hora ON venda (data_hora);
CREATE INDEX idx_venda_item_combustivel ON venda_item (combustivel_id);


-------------------------------------------------------------------------
-- SEÇÃO 2: CARGA DE DADOS INICIAIS (DML)
-------------------------------------------------------------------------

-- 1. Cadastrando Combustíveis
INSERT INTO combustivel (nome, estoque_l) VALUES
  ('Gasolina', 1200.5),
  ('Etanol',  800.25),
  ('Diesel S10', 1500.0);

-- 2. Cadastrando Funcionários
INSERT INTO funcionario (nome, ativo) VALUES
  ('Ana Silva', true),
  ('José Maria', true),
  ('Estagiário Roberto', true); -- Funcionário sem vendas para testes

-- 3. Inserindo Histórico de Vendas
INSERT INTO venda (data_hora, funcionario_id, total) VALUES
  ('2025-11-01 09:15:00-03', 1, 210.04),
  ('2025-11-01 10:05:00-03', 2, 150.12),
  ('2025-11-01 11:00:00-03', 1,  50.15),
  ('2025-11-01 11:30:00-03', 1,  80.28),
  ('2025-11-01 11:32:00-03', 2, 110.16),
  ('2025-11-01 12:32:00-03', 2, 217.50);

-- 4. Inserindo os Itens das Vendas acima
INSERT INTO venda_item (venda_id, combustivel_id, quantidade_l, preco_unitario) VALUES
  (1, 1, 35.6, 5.9), -- Venda 1: Gasolina
  (2, 2, 41.7, 3.6), -- Venda 2: Etanol
  (3, 1,  8.5, 5.9), -- Venda 3: Gasolina
  (4, 2, 22.3, 3.6), -- Venda 4: Etanol
  (5, 2, 30.6, 3.6), -- Venda 5: Etanol
  (6, 3, 37.5, 5.8); -- Venda 6: Diesel


-------------------------------------------------------------------------
-- SEÇÃO 3: CRIAÇÃO DE RELATÓRIOS AUTOMÁTICOS (VIEWS)
-------------------------------------------------------------------------

-- Relatório 1: Ranking de Vendas por Funcionário
CREATE OR REPLACE VIEW vw_relatorio_ranking_funcionarios AS
SELECT 
    f.nome AS frentista,
    COUNT(v.venda_id) AS qtd_atendimentos,
    SUM(v.total) AS total_vendido,
    ROUND(AVG(v.total), 2) AS ticket_medio
FROM funcionario f
JOIN venda v ON f.funcionario_id = v.funcionario_id
GROUP BY f.nome
ORDER BY total_vendido DESC;

-- Relatório 2: Faturamento Diário
CREATE OR REPLACE VIEW vw_relatorio_faturamento_diario AS
SELECT 
    TO_CHAR(data_hora, 'DD/MM/YYYY') AS data_venda,
    COUNT(venda_id) AS qtd_vendas,
    SUM(total) AS faturamento_dia
FROM venda
GROUP BY TO_CHAR(data_hora, 'DD/MM/YYYY')
ORDER BY data_venda DESC;

-- Relatório 3: Resumo detalhado por Combustível
CREATE OR REPLACE VIEW vw_relatorio_combustivel_popular AS
SELECT 
    c.combustivel_id,
    c.nome,
    SUM(vi.quantidade_l) AS litros_vendidos,
    SUM(vi.quantidade_l * vi.preco_unitario) AS total_faturamento,
    ROUND(SUM(vi.quantidade_l * vi.preco_unitario) / NULLIF(SUM(vi.quantidade_l),0), 2) AS preco_medio_praticado
FROM combustivel c
JOIN venda_item vi ON vi.combustivel_id = c.combustivel_id
GROUP BY c.combustivel_id, c.nome
ORDER BY total_faturamento DESC;

-- Relatório 4: Horários de Pico
CREATE OR REPLACE VIEW vw_relatorio_horarios_pico AS
SELECT 
    EXTRACT(HOUR FROM data_hora) AS hora_do_dia,
    COUNT(venda_id) AS volume_vendas
FROM venda
GROUP BY extract(HOUR FROM data_hora)
ORDER BY volume_vendas DESC;

-- Relatório 5: Auditoria (Preços baixos/suspeitos)
CREATE OR REPLACE VIEW vw_auditoria_precos_suspeitos AS
SELECT 
    v.venda_id,
    v.data_hora,
    c.nome AS combustivel,
    vi.preco_unitario,
    vi.quantidade_l,
    f.nome AS quem_vendeu
FROM venda_item vi
JOIN venda v ON v.venda_id = vi.venda_id
JOIN combustivel c ON c.combustivel_id = vi.combustivel_id
JOIN funcionario f ON f.funcionario_id = v.funcionario_id
WHERE vi.preco_unitario < 4.00 
ORDER BY vi.preco_unitario ASC;