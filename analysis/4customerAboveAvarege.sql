-- Desafio: "Quais clientes gastaram mais do que a média geral de todos os clientes?"
-- Requisitos:
-- Calcule o gasto total de cada cliente em 2024 (SUM(total_price)).
-- Calcule a média geral de gasto de todos os clientes.
-- Retorne apenas os clientes cujo gasto total foi maior do que essa média.
-- A consulta deve retornar:
-- customer_id (ID do cliente)
-- customer (nome do cliente)
-- total_spent (gasto total do cliente)
-- avg_spent (média geral de gasto de todos os clientes, para referência)
-- Ordene os resultados do maior para o menor total_spent.
---------------------------------------------------------------------------------------------------
WITH customerSpent AS (
    SELECT
        customer_id,
        customer,
        SUM(total_price) AS total_spent
    FROM sales
    WHERE STRFTIME('%Y', sales_date) = '2024'
    GROUP BY
        customer_id,
        customer
),
avgSpent AS (
    SELECT 
        ROUND(AVG(total_spent),2) AS avg_spent 
    FROM customerSpent
)

SELECT
    cs.customer_id,
    cs.customer,
    cs.total_spent,
    a.avg_spent
FROM customerSpent cs
JOIN avgSpent a
    ON cs.total_spent > a.avg_spent
ORDER BY cs.total_spent DESC