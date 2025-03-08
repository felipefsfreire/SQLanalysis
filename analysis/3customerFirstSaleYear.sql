-- Desafio: "Qual foi a primeira compra registrada de cada cliente em 2024?"
-- Requisitos:
-- Para cada cliente, encontre a primeira compra registrada no ano.
-- A consulta deve retornar:
-- customer_id (ID do cliente)
-- customer (nome do cliente)
-- sales_date (data da primeira compra)
-- product (produto comprado)
-- sales_quantity (quantidade comprada)
-- total_price (valor total da compra)
-- Se um cliente tiver mais de uma compra na mesma data, selecione a de menor valor (total_price).
----------------------------------------------------------------------------------------------------

-- Esta CTE identifica a primeira venda para cada cliente.
WITH customerFirstSaleYear AS (
    SELECT
        customer_id,
        customer,
        sales_date,
        product,
        sales_quantity,
        total_price,
        ROW_NUMBER() OVER(PARTITION BY customer ORDER BY total_price) AS rank -- Atribui um número de classificação para cada venda de um cliente, ordenando pelo preço total em ordem crescente.
    FROM
        sales
    ORDER BY
        total_price
)

SELECT
    customer_id,
    customer,
    sales_date,
    product,
    sales_quantity,
    total_price
FROM
    customerFirstSaleYear -- Seleciona os dados da CTE.
WHERE
    rank = 1 -- Filtra os resultados para incluir apenas a primeira venda de cada cliente, com menor preço total.
ORDER BY
    sales_date,
    customer