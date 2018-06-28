Insert into Param (IDParam, SrvParameter, SrvValue, SrvType, Description, DefaultValue)
Values (77, 'Remove Barcode Check Digit', '0', 'Integer', 'Remove the barcode digits when scan. 1 = First Digit, 2 = Last Digit, and 3 = First and Last Digit', '0')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (77, 1, 'Remove Barcode Check Digit', 'Remove the barcode digits when scan. 1 = First Digit, 2 = Last Digit, and 3 = First and Last Digit')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (77, 2, 'Remover D�gito do C�d. Barras', 'Retirar os d�gitos do C�d. Barras. 1 = primeiro, 2 = �ltimo, e 3 = primeiro e �ltimo digito')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (77, 3, 'Quite el D�gito de Cod. Barras', 'Quite los d�gitos de barcode cuando escudri�a. 1 = Primero D�gito, 2 = Dura el D�gito, y 3 = Primero y Dura el D�gito')
GO

Insert into Param (IDParam, SrvParameter, SrvValue, SrvType, Description, DefaultValue)
Values (78, 'Search Model after scan Barcode', 'False', 'Boolean', 'Search for model number if the barcode is not found in search', 'False')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (78, 1, 'Search Model after scan Barcode', 'Search for model number if the barcode is not found in search')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (78, 2, 'Remover D�gito do C�d. Barras', 'Procurar modelo se o C�d. Barras n�o for encontrado na procura')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (78, 3, 'Busque el Modelo despu�s del Cod. Barras', 'Busque para el n�mero modelo si el Cod. Barras no se encuentra en la b�squeda')
GO
