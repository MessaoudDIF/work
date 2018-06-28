INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (90, 'Min length for to remove barcode digit', '0', 'Integer', 'Enter the minimal length for verify before to remove the bracode digits', '0', 0, 5)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (90, 1, 'Min length for to remove barcode digit', 'Enter the minimal length for verify before to remove the bracode digits')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (90, 2, 'Tamanho M�n p/ remover Digito C�d Barra', 'Entre com o tamanho m�nimo a verificar antes de remover os D�gitos do C�digo de barras')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (90, 3, 'La long m�n antes quita d�g del barcode', 'Incorporar la longitud m�nima para verifican antes para quitar los d�gitos del bracode')
GO
