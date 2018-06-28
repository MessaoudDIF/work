INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (94, 'Limit layaway edits to month created', 'False', 'Boolean', 'Where true would mean that a layaway could not be edited after the end of the month it was created in', 'False', 0, 1)
GO
 
INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (94, 1, 'Limit layaway edits to month created', 'If TRUE a layaway could not be edited after the end of the month it was created in.')
GO
 
INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (94, 2, 'N�o Editar credi�rio quando virar o m�s', 'Caso TRUE n�o poder� editar o credi�rio quando virar o m�s.')
GO
 
INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (94, 3, 'Layaway del l�mite corrige al mes creado', 'Si TRUE un layaway no podr�a ser corregido despu�s de que el final del mes que fue creado adentro')
GO
