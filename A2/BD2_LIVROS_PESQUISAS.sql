---- 1 )
-- a) Apresentar a quantidade de clientes em cada regiÃ£o.
/*
Para começar essa pesquisa, utilizamos 'select' para inicialmente selecionarmos
apenas as regiôes dos estados e a contagem total de clientes distintos.
Então utilizamos diversos 'left join's para juntar os dado de estado até os
dados de clientes.
Neste caso preferi utilizar do 'left join' do que usar 'join' pois em casos
de existir estados sem clientes, eles seriam apresentados na pesquisa.
Por fim agrupamos os dados pelas regiões e ordenamos os dados
a partir da quantidade de clientes, do menor para o maior, e pelo select
apresentamos apenas as regiões e o respectivo n de clientes de cada uma.
*/
SELECT e.regiao, COUNT(DISTINCT c.cod_cliente) AS clientes
FROM estado e
LEFT JOIN cidade ci ON ci.uf = e.uf
LEFT JOIN endereco en ON en.cod_cidade = ci.cod_cidade
LEFT JOIN cliente c ON c.cod_cliente = en.cod_cliente
GROUP BY e.regiao ORDER BY clientes;

-- b) Listar o nome dos 10 produtos mais vendidos por quantidade em ordem decrescente.
/*

*/


-- c) Apresentar os 5 pedidos com valor mais alto e indicar o nome do funcionÃ¡rio que atendeu o pedido.
/*
Para iniciar esta pesquisa, utilizamos 'select' para selecionar o número do pedido,
o nome do funcionário responsável e o valor total do pedido.
O valor total é calculado somando o produto da quantidade de cada item pelo seu preço.
Em seguida, utilizamos 'join's para relacionar as tabelas necessárias:
- pedido com funcionario para identificar quem realizou o pedido;
- pedido com item_pedido para obter os itens de cada pedido;
- item_pedido com produto para acessar o preço de cada produto.
Depois agrupamos os dados pelo número do pedido e pelo nome do funcionário para calcular 
corretamente o valor total de cada pedido individualmente.
Por fim, ordenamos os resultados do maior para o menor valor total
e utilizamos 'FETCH FIRST 5 ROWS ONLY' para apresentar apenas os cinco pedidos com maior valor.
*/
SELECT p.num_pedido AS pedido,
       f.nome AS funcionario,
       SUM(ip.quantidade * pr.preco) AS valor_total
FROM pedido p
JOIN funcionario f ON p.matricula = f.matricula
JOIN item_pedido ip ON p.num_pedido = ip.num_pedido
JOIN produto pr ON ip.cod_produto = pr.cod_produto
GROUP BY p.num_pedido, f.nome
ORDER BY valor_total DESC
FETCH FIRST 5 ROWS ONLY;

-- d) Listar as categorias que nÃ£o possuem categoria pai e a quantidade de produtos associados a cada uma.
/*

*/


-- e) Listar todos os produtos e seus fornecedores, apresentando apenas os que constam como ativos.
/*
Para iniciar esta pesquisa, utilizamos 'select' para selecionar o código e o nome do produto
e o código e o nome do fornecedor.
Em seguida, utilizamos 'join's para relacionar as tabelas necessárias:
- produto com produto_fornecedor para identificar quais fornecedores oferecem cada produto;
- produto_fornecedor com fornecedor para obter os dados de cada fornecedor.
Aplicamos um filtro com "WHERE pf.disponibilidade = 'V'" para considerar apenas os produtos que estão disponíveis pelos fornecedores.
Por fim, ordenamos os resultados pelo código do produto e pelo nome do fornecedor para apresentar
os dados de forma organizada, agrupando os fornecedores de cada produto em ordem alfabética.
*/
SELECT p.cod_produto,
       p.nome AS produto,
       f.cod_fornecedor,
       f.nome AS fornecedor
FROM produto p
JOIN produto_fornecedor pf ON p.cod_produto = pf.cod_produto
JOIN fornecedor f ON pf.cod_fornecedor = f.cod_fornecedor
WHERE pf.disponibilidade = 'V'
ORDER BY p.cod_produto, f.nome;

-- f) Apresentar as entregas com os dados de endereÃ§o, nome do cliente e ordenados por data de entrega.
/*

*/


---- 2 )
-- ideias: Quais são os 10 clientes que mais gastaram em pedidos, mostrando também em que região do Brasil cada um deles está localizado?