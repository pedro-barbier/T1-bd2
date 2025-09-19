---- 1 )
-- a) Apresentar a quantidade de clientes em cada região.
/*
Para come�ar essa pesquisa, utilizamos 'select' para inicialmente selecionarmos
apenas as regi�es dos estados e a contagem total de clientes distintos.
Ent�o utilizamos diversos 'left join's para juntar os dado de estado at� os
dados de clientes.
Neste caso preferi utilizar do 'left join' do que usar 'join' pois em casos
de existir estados sem clientes, eles seriam apresentados na pesquisa.
Por fim agrupamos os dados pelas regi�es e ordenamos os dados
a partir da quantidade de clientes, do menor para o maior, e pelo select
apresentamos apenas as regi�es e o respectivo n de clientes de cada uma.
*/
SELECT e.regiao, COUNT(DISTINCT c.cod_cliente) AS clientes
FROM estado e
LEFT JOIN cidade ci ON ci.uf = e.uf
LEFT JOIN endereco en ON en.cod_cidade = ci.cod_cidade
LEFT JOIN cliente c ON c.cod_cliente = en.cod_cliente
GROUP BY e.regiao ORDER BY clientes;

-- b) Listar o nome dos 10 produtos mais vendidos por quantidade em ordem decrescente.
/*
Para encontrar os 10 produtos mais vendidos por quantidade, utilizei a tabela ITEM_PEDIDO, que contém os detalhes das vendas, 
como o código do produto (cod_produto) e a quantidade vendida (quantidade). Primeiro, juntei essa tabela com a tabela PRODUTO 
para obter o nome de cada produto associado ao cod_produto. Em seguida, somei as quantidades vendidas de cada produto usando a função SUM, 
agrupei os resultados por código e nome do produto, ordenei do maior para o menor total vendido e limitei a lista aos 10 primeiros produtos.
*/
SELECT p.nome, SUM(ip.quantidade) AS total_vendido
FROM PRODUTO p
JOIN ITEM_PEDIDO ip ON p.cod_produto = ip.cod_produto
GROUP BY p.cod_produto, p.nome
ORDER BY total_vendido DESC
FETCH FIRST 10 ROWS ONLY;

-- c) Apresentar os 5 pedidos com valor mais alto e indicar o nome do funcionário que atendeu o pedido.
/*
Para iniciar esta pesquisa, utilizamos 'select' para selecionar o n�mero do pedido,
o nome do funcion�rio respons�vel e o valor total do pedido.
O valor total � calculado somando o produto da quantidade de cada item pelo seu pre�o.
Em seguida, utilizamos 'join's para relacionar as tabelas necess�rias:
- pedido com funcionario para identificar quem efetuou o pedido;
- pedido com item_pedido para obter os itens de cada pedido;
- item_pedido com produto para acessar o pre�o de cada produto.
Depois agrupamos os dados pelo n�mero do pedido e pelo nome do funcion�rio para calcular 
corretamente o valor total de cada pedido individualmente.
Por fim, ordenamos os resultados do maior para o menor valor total
e utilizamos 'FETCH FIRST 5 ROWS ONLY' para apresentar apenas os cinco pedidos de maior valor.
*/
SELECT p.num_pedido AS pedido,
    f.nome AS funcionario, 
    SUM(ip.quantidade * pr.preco) AS valor_total
FROM pedido p
JOIN funcionario f ON p.matricula = f.matricula
JOIN item_pedido ip ON p.num_pedido = ip.num_pedido
JOIN produto pr ON ip.cod_produto = pr.cod_produto
GROUP BY p.num_pedido, f.nome ORDER BY valor_total DESC
FETCH FIRST 5 ROWS ONLY;

-- d) Listar as categorias que não possuem categoria pai e a quantidade de produtos associados a cada uma.
/*
Para listar todas as categorias sem categoria pai e a quantidade de produtos associados, usei a tabela CATEGORIA (com cod_categoria, nome e cod_categoria_pai) 
e filtrei com WHERE c.cod_categoria_pai IS NULL para selecionar apenas categorias sem pai. Juntei com a tabela PRODUTO (que contém cod_produto e cod_categoria) 
usando LEFT JOIN para contar produto por categoria, incluindo aquelas sem produtos (contagem 0), com COUNT(p.cod_produto). Agrupei por cod_categoria e nome, 
ordenei alfabeticamente pelo nome da categoria (ORDER BY c.nome) e projetei a consulta para funcionar com qualquer dado do esquema, 
já que não tenho os dados completos de CATEGORIA ou PRODUTO.
*/
SELECT c.nome, COUNT(p.cod_produto) AS quantidade_produtos
FROM CATEGORIA c
LEFT JOIN PRODUTO p ON c.cod_categoria = p.cod_categoria
WHERE c.cod_categoria_pai IS NULL
GROUP BY c.cod_categoria, c.nome
ORDER BY c.nome;

-- e) Listar todos os produtos e seus fornecedores, apresentando apenas os que constam como ativos.
/*
Para iniciar esta pesquisa, utilizamos 'select' para selecionar o c�digo e o nome do produto
e o c�digo e o nome do fornecedor.
Em seguida, utilizamos 'join's para relacionar as tabelas necess�rias:
- produto com produto_fornecedor para identificar quais fornecedores oferecem cada produto;
- produto_fornecedor com fornecedor para obter os dados de cada fornecedor.
Aplicamos um filtro com "WHERE pf.disponibilidade = 'V'" para considerar apenas os produtos que est�o dispon�veis pelos fornecedores.
Por fim, ordenamos os resultados pelo c�digo do produto e pelo nome do fornecedor para apresentar
os dados de forma organizada, agrupando os fornecedores de cada produto em ordem alfab�tica.
*/
SELECT p.cod_produto,
    p.nome AS produto,
    f.cod_fornecedor,
    f.nome AS fornecedor
FROM produto p
JOIN produto_fornecedor pf ON p.cod_produto = pf.cod_produto
JOIN fornecedor f ON pf.cod_fornecedor = f.cod_fornecedor
WHERE pf.disponibilidade = 'V' ORDER BY p.cod_produto, f.nome;

-- f) Apresentar as entregas com os dados de endereço, nome do cliente e ordenados por data de entrega.
/*
Para apresentar as entregas com os dados de endereço, nome do cliente e ordenadas por data de entrega, 
utilizei a tabela ENTREGA como base, juntando com ENDERECO pelo cod_endereco para obter rua, número, 
complemento e CEP, com CIDADE e ESTADO para nome da cidade e estado, e com CLIENTE pelo cod_cliente para o nome do cliente. 
Usei INNER JOIN para associar apenas entregas com endereços válidos, selecionei campos relevantes como número da entrega, 
data, endereço completo, cidade, estado e nome do cliente, e ordenei por data em ordem crescente para listar cronologicamente.
*/
SELECT e.num_entrega,
    e.data AS data_entrega,
    en.rua,
    en.numero,
    en.complemento,
    en.cep, 
    ci.nome AS cidade,
    es.nome AS estado,
    cl.nome AS cliente_nome
FROM ENTREGA e
JOIN ENDERECO en ON e.cod_endereco = en.cod_endereco
JOIN CIDADE ci ON en.cod_cidade = ci.cod_cidade
JOIN ESTADO es ON ci.uf = es.uf
JOIN CLIENTE cl ON en.cod_cliente = cl.cod_cliente
ORDER BY e.data;

---- 2 ) Construa pelo menos mais uma consulta a sua escolha que faça uso de pelo menos 3 tabelas
-- ideia: Quais são os 10 clientes que mais gastaram em pedidos, mostrando também em que estado do Brasil cada um deles está localizado?
/*
Para responder a essa pergunta, vamos utilizar as tabelas CLIENTE, PEDIDO, ITEM_PEDIDO, PRODUTO, ENDERECO, CIDADE e ESTADO.
A consulta irá somar o valor gasto por cada cliente em seus pedidos e agrupar os resultados pelo nome do cliente e pelo estado onde ele está localizado.
Fazemos isso juntando as tabelas necessárias com JOINs, caminhando desde o cliente até o estado através do endereço e cidade, e de cliente até o produto através dos pedidos e itens de pedido.
Após juntarmos todas as tabelas, agrupamos os resultados pelo nome do cliente e pelo nome do estado, ordenamos pela quantia gasta em ordem decrescente e mostramos apenas os 10 clientes que mais gastaram.
Essa pesquisa apresenta clientes/empresas com endere�os/filiais em diferentes estados como clientes separados
*/
SELECT c.nome AS nome_cliente,
    SUM(pr.preco) AS quantia_gasta,
    es.nome AS estado_pertencente
FROM CLIENTE c
JOIN PEDIDO p ON c.cod_cliente = p.cod_cliente
JOIN ITEM_PEDIDO ip ON p.num_pedido = ip.num_pedido
JOIN PRODUTO pr ON ip.cod_produto = pr.cod_produto
JOIN ENDERECO en ON c.cod_cliente = en.cod_cliente
JOIN CIDADE ci ON en.cod_cidade = ci.cod_cidade
JOIN ESTADO es ON ci.uf = es.uf
GROUP BY c.nome, es.nome
ORDER BY quantia_gasta DESC
FETCH FIRST 10 ROWS ONLY;
