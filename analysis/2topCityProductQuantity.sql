-- Desafio: Quais foram os 3 produtos mais vendidos (em quantidade) para cada cidade?"
-- Requisitos:
-- Para cada cidade, encontre os três produtos com maior quantidade total vendida.
-- A consulta deve retornar:
-- city (cidade)
-- product (produto)
-- total_quantity (quantidade total vendida do produto na cidade)
-- Se houver empate na quantidade vendida, desempate pelo produto em ordem alfabética.
---------------------------------------------------------------------------------------
WITH topCityProductQuantity AS (
SELECT
    city,
    product,
    SUM(sales_quantity) total_quantity,
    ROW_NUMBER() OVER(PARTITION BY city ORDER BY SUM(sales_quantity) DESC) AS rank
FROM
    sales
GROUP BY
    city,
    product
)

SELECT
    city,
    product,
    total_quantity
FROM
    topCityProductQuantity
WHERE
    rank BETWEEN 1 AND 3
ORDER BY
    city,
    rank