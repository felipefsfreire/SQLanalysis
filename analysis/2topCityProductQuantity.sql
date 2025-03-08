-- Desafio: Quais foram os 3 produtos mais vendidos (em quantidade) para cada cidade?"
-- Requisitos:
-- Para cada cidade, encontre os três produtos com maior quantidade total vendida.
-- A consulta deve retornar:
-- city (cidade)
-- product (produto)
-- total_quantity (quantidade total vendida do produto na cidade)
-- Se houver empate na quantidade vendida, desempate pelo produto em ordem alfabética.
---------------------------------------------------------------------------------------

-- Esta (CTE)calcula a quantidade total de vendas por cidade e produto criando uma tabela temporária
WITH topCityProductQuantity AS (
    SELECT
        city,
        product,
        SUM(sales_quantity) AS total_quantity, -- Calcula a soma da quantidade de vendas para cada combinação de cidade e produto, e a nomeia como 'total_quantity'.
        ROW_NUMBER() OVER(PARTITION BY city ORDER BY SUM(sales_quantity) DESC) AS rank -- Atribui um número de classificação para cada produto dentro de cada cidade, ordenando pela quantidade total de vendas em ordem decrescente.
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
    topCityProductQuantity -- Seleciona os dados da CTE.
WHERE
    rank BETWEEN 1 AND 3 -- Filtra os resultados para incluir apenas os produtos com rank 1, 2 ou 3 (os três produtos mais vendidos) em cada cidade.
ORDER BY
    city,
    rank