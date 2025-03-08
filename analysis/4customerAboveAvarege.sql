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

-- Esta CTE calcula o valor total gasto por cada cliente no ano de 2024.
WITH customerSpent AS (
    SELECT
        customer_id,
        customer,
        SUM(total_price) AS total_spent -- Calcula a soma dos preços totais de todas as compras de cada cliente.
    FROM sales
    WHERE STRFTIME('%Y', sales_date) = '2024' -- Filtra as vendas para incluir apenas aquelas que ocorreram no ano de 2024.
    GROUP BY
        customer_id,
        customer
),
-- Esta CTE calcula a média do valor total gasto por todos os clientes em 2024.
avgSpent AS (
    SELECT 
        ROUND(AVG(total_spent),2) AS avg_spent -- Calcula a média dos valores 'total_spent' da CTE 'customerSpent' e a arredonda para duas casas decimais.
    FROM customerSpent -- A CTE 'customerSpent' é a fonte dos dados.
)

SELECT
    cs.customer_id, -- Seleciona o ID do cliente da CTE 'customerSpent'.
    cs.customer, -- Seleciona o nome do cliente da CTE 'customerSpent'.
    cs.total_spent, -- Seleciona o valor total gasto pelo cliente da CTE 'customerSpent'.
    a.avg_spent -- Seleciona a média do valor gasto da CTE 'avgSpent'.
FROM customerSpent cs -- Usa a CTE 'customerSpent' e a apelida de 'cs'.
JOIN avgSpent a -- Junta (JOIN) a CTE 'avgSpent' e a apelida de 'a'.
    ON cs.total_spent > a.avg_spent -- A condição de junção é que o valor total gasto pelo cliente ('cs.total_spent') seja maior que a média do valor gasto ('a.avg_spent').
ORDER BY cs.total_spent DESC;