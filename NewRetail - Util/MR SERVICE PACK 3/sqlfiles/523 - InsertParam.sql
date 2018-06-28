INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado)
VALUES (88, 'Use Catalog', 'False', 'Boolean', 'Enter TRUE to Search in Catalog when the product is not found', 'False', 0)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (88, 1, 'Use Catalog', 'Enter TRUE to Search in Catalog when the product is not found')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (88, 2, 'Utilizar Cat�logo', 'Entrar TRUE para procurar no Cat�logo quando o produto n�o for encontrado')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (88, 3, 'Utilizar el Cat�logo', 'Entrar TRUE para buscar en el cat�logo cuando el modelo no fue encontrado')
GO
