-------------------------------------------------------
-- 1. NOVOS CADASTROS (Fase de Preparação)
-------------------------------------------------------

-- Inserindo novos funcionários
INSERT INTO funcionario (nome, ativo) VALUES 
('Carlos Souza', true),
('Fernanda Lima', true);

-- Inserindo novo combustível (Gasolina Podium)
-- Obs: Definimos estoque inicial de 5000 litros
INSERT INTO combustivel (nome, estoque_l) VALUES 
('Gasolina Podium', 5000.000);


-------------------------------------------------------
-- 2. GERADOR DE VENDAS EM MASSA (A Mágica)
-------------------------------------------------------

-- Passo A: Gerar 100 Vendas (Cabeçalhos) com datas aleatórias nos últimos 30 dias
-- Nota: Inicializamos o total com 0, pois vamos calcular depois.
INSERT INTO venda (data_hora, funcionario_id, total)
SELECT 
    NOW() - (random() * (INTERVAL '30 days')) AS data_hora, -- Data aleatória
    floor(random() * 5 + 1)::int AS funcionario_id,        -- Funcionario aleatório (1 a 5)
    0.00 AS total                                           -- Placeholder
FROM generate_series(1, 100); 


-- Passo B: Gerar Itens para essas vendas (O recheio)
-- Vamos inserir 1 item para cada uma das vendas criadas recentemente
INSERT INTO venda_item (venda_id, combustivel_id, quantidade_l, preco_unitario)
SELECT 
    v.venda_id,
    floor(random() * 4 + 1)::int AS combustivel_id, -- Combustível aleatório (1 a 4)
    (random() * 50 + 5)::numeric(12,3) AS quantidade_l, -- Litros entre 5 e 55
    
    CASE 
        WHEN floor(random() * 4 + 1)::int = 1 THEN 5.890 -- Gasolina Comum
        WHEN floor(random() * 4 + 1)::int = 2 THEN 3.990 -- Etanol
        WHEN floor(random() * 4 + 1)::int = 3 THEN 6.150 -- Diesel S10
        ELSE 7.590                                       -- Podium
    END AS preco_unitario
FROM venda v
WHERE v.total = 0; -- Pega apenas as vendas novas que acabamos de criar


-------------------------------------------------------
-- 3. AJUSTE DE CONSISTÊNCIA
-------------------------------------------------------

-- Atualiza o valor TOTAL na tabela 'venda' somando os itens que acabamos de criar.
-- Sem isso, seus relatórios de faturamento dariam zero.
UPDATE venda v
SET total = sub.soma_itens
FROM (
    SELECT venda_id, SUM(quantidade_l * preco_unitario) as soma_itens
    FROM venda_item
    GROUP BY venda_id
) sub
WHERE v.venda_id = sub.venda_id
AND v.total = 0;

-------------------------------------------------------
-- FIM DO SCRIPT
-------------------------------------------------------