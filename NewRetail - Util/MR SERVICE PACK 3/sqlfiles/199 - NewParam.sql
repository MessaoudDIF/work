Insert into Param (IDParam, SrvParameter, SrvValue, SrvType, Description, DefaultValue)
Values (70, 'Show resumed customer info', 'False', 'Boolean', 'Enter TRUE to display resumed information in the customer file', 'False')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (70, 1, 'Show resumed customer info', 'Enter TRUE to display resumed information in the customer file')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (70, 2, 'Resumir cadastro de clientes', 'Entre TRUE para exibir informa��o resumida no cadastro de cliente')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (70, 3, 'Exposici�n reasumi� de cliente', 'Entre TRUE demostrar informaci�n reasumida en el archivo de cliente')
GO
