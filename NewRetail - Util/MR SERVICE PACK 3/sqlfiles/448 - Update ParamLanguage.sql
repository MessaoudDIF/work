UPDATE ParamLanguage
SET
	SrvParameter = 'Vender quantidade em negativo',
	[Description] = 'Um produto pode ser vendido mesmo tendo sua quantidade negativa no estoque.'
WHERE IDLanguage = 2 AND IDParam = 2
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Informar quantidade 1 durante a venda',
	[Description] = 'Os �tens ser�o inclu�dos automaticamente com quantidade igual � (=) 1 durante as vendas.'
WHERE IDLanguage = 2 AND IDParam = 3
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Atualizar listagem de venda',
	[Description] = 'Quando os �tens forem inseridos na nota, automaticamente apareceram na listagem de venda.'
WHERE IDLanguage = 2 AND IDParam = 4
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Intervalo de tempo para atualizar itens',
	[Description] = 'Atualizar os itens em um intervalo determinado de tempo.'
WHERE IDLanguage = 2 AND IDParam = 5
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Atualizar listagens de itens no Sistema',
	[Description] = 'Quando os �tens forem inseridos, automaticamente apareceram na listagens do Sistema.'
WHERE IDLanguage = 2 AND IDParam = 6
GO

UPDATE ParamLanguage
SET	SrvParameter = 'N� M�ximo de linhas permitidos na lista',
	[Description] = 'N�mero m�ximo permitido de linhas que podem ser mostrado na lista.'
WHERE IDLanguage = 2 AND IDParam = 7
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Modificar valores na compra',
	[Description] = 'Permitir nas compras a op��o de modificar os pre�os de custo, frete, etc.'
WHERE IDLanguage = 2 AND IDParam = 8
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Fundo de caixa',
	[Description] = 'Total de dinheiro que deve ficar no caixa depois de ser fechado.'
WHERE IDLanguage = 2 AND IDParam = 9
GO

UPDATE ParamLanguage
SET	SrvParameter = 'M�ximo de dinheiro no caixa',
	[Description] = 'Total de m�ximo de dinheiro que pode ficar no caixa.'
WHERE IDLanguage = 2 AND IDParam = 11
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Habilitar n� rand�mico no total caixa',
	[Description] = 'Habilitar gera��o de n�mero rand�mico para ocultar o total do sistema no caixa. (Vendas + Fundo de Caixa)'
WHERE IDLanguage = 2 AND IDParam = 12
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Qtd. M�x. na requisi��o do computador',
	[Description] = 'Qual a quantidade m�xima que o sistema pode requerer automaticamente.'
WHERE IDLanguage = 2 AND IDParam = 13
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Qtd. Min. na requisi��o do computador',
	[Description] = 'Qual a quantidade m�nima que o sistema pode requerer automaticamente.'
WHERE IDLanguage = 2 AND IDParam = 14
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Adicionar qtd pr�-recebida no estoque',
	[Description] = 'Colocar quantidade pr�-recebida como quantidade de estoque para ser vendida.'
WHERE IDLanguage = 2 AND IDParam = 15
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Tempo de dele��o de itens do estoque',
	[Description] = 'Em quantos meses voc� deseja deletar os itens antigos de invent�rio? Coloque 0 para N�O deletar nada.'
WHERE IDLanguage = 2 AND IDParam = 17
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Tempo de dele��o de notas pendentes',
	[Description] = 'Em quantos dias voc� deseja deletar as notas pendentes? Coloque 0 para N�O deletar nada.'
WHERE IDLanguage = 2 AND IDParam = 18
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Tempo de requisi��es do sistema (Meses)',
	[Description] = 'Em quantos meses voc� deseja que sejam feitas as requesi��es do sistema.'
WHERE IDLanguage = 2 AND IDParam = 25
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Valor de requisi��es do sistema (%Venda)',
	[Description] = 'Valor da porcentagem (%) de venda para as requesi��es do sistema.'
WHERE IDLanguage = 2 AND IDParam = 26
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Tempo de Logoff autom�tico (Minutos)',
	[Description] = 'Caso o usu�rio n�o utilize o sistema nos minutos estabelecidos - Fazer Logoff do usu�rio.'
WHERE IDLanguage = 2 AND IDParam = 27
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Valor de OP do servi�o de level A',
	[Description] = 'O valor da OP para modelos de servi�o de level A que est�o marcados com ABC.'
WHERE IDLanguage = 2 AND IDParam = 28
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Valor de OP do servi�o de level B',
	[Description] = 'O valor da OP para modelos de servi�o de level B que est�o marcados com ABC.'
WHERE IDLanguage = 2 AND IDParam = 29
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Valor de OP do servi�o de level C',
	[Description] = 'O valor da OP para modelos de servi�o de level C que est�o marcados com ABC.'
WHERE IDLanguage = 2 AND IDParam = 30
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Todos podem usar o caixa',
	[Description] = 'Se for TRUE, todos podem usar o caixa. Se for FALSE, somente o usu�rio que abriu o caixa poder� us�-lo.'
WHERE IDLanguage = 2 AND IDParam = 31
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador de Venda R�pida',
	[Description] = 'Mostrar o Tabulador de Venda R�pida quando o usu�rio criar uma nota.'
WHERE IDLanguage = 2 AND IDParam = 32
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador Clientes',
	[Description] = 'Mostrar o Tabulador de Clientes quando o usu�rio criar uma nota.'
WHERE IDLanguage = 2 AND IDParam = 33
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador Guias',
	[Description] = 'Mostrar o Tabulador de Guias quando o usu�rio criar uma nota.'
WHERE IDLanguage = 2 AND IDParam = 34
GO

UPDATE ParamLanguage
SET	SrvParameter = 'B�nus na comiss�o (%)',
	[Description] = 'Percentual de b�nus sobre a comiss�o.'
WHERE IDLanguage = 2 AND IDParam = 35
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostra Tabulador com dados do cliente',
	[Description] = 'Mostrar o Tabulador de dados do cliente na Guia de Venda quando o usu�rio criar uma nota.'
WHERE IDLanguage = 2 AND IDParam = 36
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Carga Hor�ria',
	[Description] = 'N�mero de horas m�ximas trabalhadas por dia de um usu�rio.'
WHERE IDLanguage = 2 AND IDParam = 37
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar valores em itens Pr�-Recebidos',
	[Description] = 'Mostrar os valores dos itens quando fizer pr�-recebimento.'
WHERE IDLanguage = 2 AND IDParam = 38
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar �cones no menu',
	[Description] = 'Mostrar os �cones do programa quando inicializar o sistema.'
WHERE IDLanguage = 2 AND IDParam = 39
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar credi�rio no Hist�rico de Notas',
	[Description] = 'Mostrar informa��o do credi�rio no hist�rico de notas.'
WHERE IDLanguage = 2 AND IDParam = 40
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar credi�rio no Hist�rico de Caixa',
	[Description] = 'Mostrar informa��o do credi�rio no hist�rico de caixa.'
WHERE IDLanguage = 2 AND IDParam = 41
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Imprimir recibo de Dep�sito',
	[Description] = 'Imprimir recibo quando fizer um dep�sito.'
WHERE IDLanguage = 2 AND IDParam = 42
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador de Credi�rio',
	[Description] = 'Mostrar o Tabulador de Credi�rio quando o usu�rio criar uma nota.'
WHERE IDLanguage = 2 AND IDParam = 43
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Exigir n� de s�rie na venda',
	[Description] = 'O usu�rio dever� incluir um n�mero de s�rie antes de vender o produto.'
WHERE IDLanguage = 2 AND IDParam = 44
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Calcular margem sobre o custo',
	[Description] = 'Se for TRUE, calcular a margem sobre o CUSTO. Se for FALSE, calcular a margem sobre o CUSTO M�DIO.'
WHERE IDLanguage = 2 AND IDParam = 45
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Imprimir �tens depois que fechar o caixa',
	[Description] = 'Se for TRUE, imprimi um determinado n�mero de �tens quando fechar o caixa.'
WHERE IDLanguage = 2 AND IDParam = 46
GO

UPDATE ParamLanguage
SET	SrvParameter = 'N� de �tens para imprimir',
	[Description] = 'Quantidade de itens que ser�o impressos (�tens randomicos do invent�rio). Zero n�o imprime nada'
WHERE IDLanguage = 2 AND IDParam = 47
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Vender pr�-datado',
	[Description] = 'Mostrar op��o de vender pre-datado.'
WHERE IDLanguage = 2 AND IDParam = 48
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Exigir entrega antes de fechar a nota',
	[Description] = 'A nota n�o pode ser fechada at� que a entrega seja informada.'
WHERE IDLanguage = 2 AND IDParam = 49
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Exibir e exigir local do pagto. na venda',
	[Description] = 'Mostrar op��o de exibir e exigir o campo local do pagamento quando for receber o dinheiro.'
WHERE IDLanguage = 2 AND IDParam = 50
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Exigir quita��o total do pedido',
	[Description] = 'Mostrar op��o de exibir e exigir o total de pagamento do pedido antes de fechar o mesmo.'
WHERE IDLanguage = 2 AND IDParam = 51
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador Nota - Outros Custos',
	[Description] = 'Exibir o tabulador outros custos na nota.'
WHERE IDLanguage = 2 AND IDParam = 52
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador Nota - Pagamentos',
	[Description] = 'Exibir o tabulador de pagamentos na nota.'
WHERE IDLanguage = 2 AND IDParam = 53
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador Nota - Ag�ncia',
	[Description] = 'Exibir o tabulador de ag�ncia na nota.'
WHERE IDLanguage = 2 AND IDParam = 54
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador Nota - Entrega',
	[Description] = 'Exibir o tabulador de entrega na nota.'
WHERE IDLanguage = 2 AND IDParam = 55
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador Nota - Data Dep�sito',
	[Description] = 'Exibir o tabualdor de data de dep�sito na nota.'
WHERE IDLanguage = 2 AND IDParam = 56
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Mostrar Tabulador Nota - Desconto',
	[Description] = 'Exibir o tabulador de desconto na nota.'
WHERE IDLanguage = 2 AND IDParam = 57
GO

UPDATE ParamLanguage
SET	SrvParameter = 'N�mero m�ximo de parcelas',
	[Description] = 'Informe o n�mero m�ximo de parcelas para notas pr�-datadas.'
WHERE IDLanguage = 2 AND IDParam = 58
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Habilitar consulta SERASA',
	[Description] = 'Habilitar consulta no SERASA.'
WHERE IDLanguage = 2 AND IDParam = 59
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Nome do banco de dados CEP',
	[Description] = 'Informe o nome do banco de dados de CEP.'
WHERE IDLanguage = 2 AND IDParam = 60
GO

UPDATE ParamLanguage
SET	SrvParameter = 'M�x. de dias para pagamento � vista',
	[Description] = 'Informe o n�mero m�ximo de dias para validar o recebimento � vista. Entre com -1 para desabilitar a op��o.'
WHERE IDLanguage = 2 AND IDParam = 61
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Confirmar entrega depois do fim da venda',
	[Description] = 'Depois de fechar uma venda, confirmar a entrega para fechar o pedido.'
WHERE IDLanguage = 2 AND IDParam = 62
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Tipo da tela de Vendas',
	[Description] = 'Escolhe o tipo da tela de Vendas. 1 = PDV, 2 = Escrit�rio, 3 = Full-POS'
WHERE IDLanguage = 2 AND IDParam = 63
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Isentar impostos do pedido',
	[Description] = 'Sempre isentar impostos no pedido.'
WHERE IDLanguage = 2 AND IDParam = 64
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Habilitar estoque flutuante',
	[Description] = 'Trabalhar com estoque flutuante.'
WHERE IDLanguage = 2 AND IDParam = 65
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Imposto � inclu�do no pre�o de custo',
	[Description] = 'Os impostos s�o inclu�dos no pre�o de custo do produto.'
WHERE IDLanguage = 2 AND IDParam = 66
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Exiba op��es de loja de ANIMAIS',
	[Description] = 'Exiba op��es de loja de ANIMAIS (PetShop).'
WHERE IDLanguage = 2 AND IDParam = 67
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Usar Custo l�quido de reposi��o',
	[Description] = 'Lan�ar o custo de l�quido na reposi��o do pedido.'
WHERE IDLanguage = 2 AND IDParam = 68
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Delimite o tempo da pr�xima entrega',
	[Description] = 'N�o pode marcar a entrega para o dia seguinte depois da hora informada. Entre -1 para desabilitar.'
WHERE IDLanguage = 2 AND IDParam = 69
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Exibir resumo do cadastro de clientes',
	[Description] = 'Exibir informa��o resumida no cadastro de cliente.'
WHERE IDLanguage = 2 AND IDParam = 70
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Marcar entrega depois que receber pagtos',
	[Description] = 'Se o local de pagamento for  "Outros", o sistema n�o permitir� marcar entrega at� receber todos os pagamentos.'
WHERE IDLanguage = 2 AND IDParam = 71
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Calcular Margem de Lucro',
	[Description] = 'Se for TRUE, o sistema n�o incluir� os impostos no c�lculo da margem de lucro.'
WHERE IDLanguage = 2 AND IDParam = 72
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Caminho do Server MRPuppyTracker',
	[Description] = 'Entre com o caminho do software de integra��o MainRetail PuppyTracker.'
WHERE IDLanguage = 2 AND IDParam = 73
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Pedir senha ao abrir sistema',
	[Description] = 'Pedir a senha ao operador antes de abrir o MainRetail.'
WHERE IDLanguage = 2 AND IDParam = 74
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Calcular margem de pre�o nos itens.',
	[Description] = 'Habilitar op��o para calcular margem.'
WHERE IDLanguage = 2 AND IDParam = 75
GO

UPDATE ParamLanguage
SET	SrvParameter = 'Calcula arredondamento no pre�o de venda',
	[Description] = 'Habilitar op��o arredondar o pre�o de venda.'
WHERE IDLanguage = 2 AND IDParam = 76
GO
