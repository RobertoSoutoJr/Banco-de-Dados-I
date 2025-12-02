/* =======================================================
   BLOCO DE TESTES DE INTEGRIDADE (DEVEM FALHAR SE RODADOS)
   ======================================================= */
-- Teste de Duplicidade: Tentar inserir Gasolina de novo
-- INSERT INTO combustivel (nome, estoque_l) VALUES ('Gasolina', 500);

-- Teste de Validação: Tentar inserir venda negativa
-- INSERT INTO venda (funcionario_id, total) VALUES (NULL, -50.00);


/* =======================================================
   CONSULTAS OPERACIONAIS
   ======================================================= */

-- 1. Estoque Crítico (Listar combustíveis ordenados pelo estoque)
SELECT combustivel_id, nome, estoque_l 
FROM combustivel 
ORDER BY estoque_l DESC;

-- 2. Filtro de Estoque (Apenas > 1000L)
SELECT combustivel_id, nome, estoque_l 
FROM combustivel 
WHERE estoque_l > 1000 
ORDER BY estoque_l DESC;

-- 3. Detalhamento de Vendas do Dia 01/11/2025
SELECT
  c.nome AS combustivel,
  SUM(vi.quantidade_l) AS total_litros,
  SUM(vi.quantidade_l * vi.preco_unitario) AS total_vendido
FROM combustivel c
JOIN venda_item vi ON vi.combustivel_id = c.combustivel_id
JOIN venda v ON vi.venda_id = v.venda_id
WHERE v.data_hora BETWEEN '2025-11-01 00:00:00-03' AND '2025-11-01 23:59:59-03'
GROUP BY c.nome
ORDER BY total_vendido DESC;

-- 4. Caça-Fantasmas: Achar funcionários que nunca venderam nada (LEFT JOIN)
SELECT f.nome, f.ativo
FROM funcionario f
LEFT JOIN venda v ON v.funcionario_id = f.funcionario_id
WHERE v.venda_id IS NULL;


/* =======================================================
   CONSULTANDO AS VIEWS (RELATÓRIOS PRONTOS)
   ======================================================= */
SELECT * FROM vw_relatorio_ranking_funcionarios;
SELECT * FROM vw_relatorio_faturamento_diario;
SELECT * FROM vw_auditoria_precos_suspeitos;