INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (108, 'Disable Freight and Other Cost', 'False', 'Boolean', 'If this option will be TRUE, system will disable freight and other cost field on receiving', 'False', 0, 4)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (108, 1, 'Disable Freight and Other Cost', 'If this option will be TRUE, system will disable freight and other cost field on receiving.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (108, 2, 'Desativar frete e outros custos', 'Se esta op��o for TRUE, o sistema ir� desabilitar o frete e outras custos do recebimento.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (108, 3, 'Desactivar el flete y otros gastos', 'Si esta opci�n se TRUE, desactivar el sistema de transporte de mercanc�as y otros gastos sobre en la recepci�n.')
GO

INSERT INTO Param (IDParam, SrvParameter, SrvValue, SrvType, [Description], DefaultValue, Desativado, IDMenu)
VALUES (109, 'Remove Backordered Items After Import', 'False', 'Boolean', 'If this option will be TRUE, system remove any backordered items after import PO', 'False', 0, 4)
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (109, 1, 'Remove Backordered Items After Import', 'If this option will be TRUE, system remove any backordered items after import PO.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (109, 2, 'Remover itens restantes ap�s importar OC', 'Se esta op��o for TRUE, o sistema ir� remover itens restantes ap�s importar OC em compras.')
GO

INSERT INTO ParamLanguage (IDParam, IDLanguage, SrvParameter, [Description])
VALUES (109, 3, 'Eliminar items despu�s de importaci�n', 'Si esta opci�n se TRUE, el sistema se eliminar�n los temas pendientes de importaci�n despu�s de PO.')
GO
