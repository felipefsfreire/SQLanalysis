-- Desafio: Crie uma consulta SQL que responda à seguinte pergunta:
-- "Qual foi a categoria com a maior receita total em cada mês de 2024?"
-- Requisitos:
-- Calcule a receita total (SUM(total_price)) para cada categoria, agrupando por mês.
-- Para cada mês, selecione apenas a categoria com a maior receita.
-- A consulta deve retornar os seguintes campos:
-- month (mês da venda)
-- category (categoria do produto)
-- total_revenue (receita total da categoria no mês)
-- Dica: Você pode usar strftime('%m', sales_date) para extrair o mês da coluna sales_date, se estiver usando SQLite. Em outros bancos de dados, EXTRACT(MONTH FROM sales_date) pode ser uma alternativa.
---------------------------------------------------------------------------------

-- Criando uma tabela temporária
WITH MonthlyRevenue AS (
    SELECT
        STRFTIME('%m', sales_date) AS month,  -- Extrai o mês da data de venda (formato MM)
        category,  
        SUM(total_price) AS total_revenue,  -- Soma total das vendas para cada categoria dentro do mês        
        -- ROW_NUMBER() atribui um número sequencial a cada linha dentro de cada mês
        -- OVER() define a janela, particionando os dados por mês e ordenando pelo total de vendas (desc)
        -- Assim, a maior receita de cada mês recebe rank = 1
        ROW_NUMBER() OVER (
            PARTITION BY STRFTIME('%m', sales_date)  -- Particiona os dados por mês
            ORDER BY SUM(total_price) DESC  -- Ordena as categorias dentro de cada mês pela maior receita
        ) AS rank  
    FROM 
        sales
    GROUP BY 
        month,  -- Agrupamos os dados por mês
        category  -- Agrupamos também por categoria para calcular a receita total por categoria
)

SELECT 
    month,
    category,
    total_revenue
FROM MonthlyRevenue
WHERE rank = 1  -- Mantém apenas a categoria com maior receita para cada mês
ORDER BY month

