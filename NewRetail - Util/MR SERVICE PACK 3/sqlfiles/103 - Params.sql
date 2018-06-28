Insert into Param (IDParam, SrvParameter, SrvValue, SrvType, Description, DefaultValue)
Values (61, 'Max number of days for paying now', '-1', 'Integer', 'Set the max number of days for payments when to validade payment method in sale', '-1')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (61, 1, 'Max number of days for paying now', 'Set the max number of days for payments when to validade payment method in sale. Enter -1 for disable the option.')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (61, 2, 'N�mero m�ximo dias para Pgto a vista', 'Informe o n�mero m�ximo de dias para validar o recebimento a vista. Entre com -1 para desabilitar a op��o')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (61, 3, 'N�mero m�ximo de d�as para pagar ahora', 'Ponga el n�mero m�x de d�as para pagos cuando al m�todo del pago del validade en la venta. Entre -1 para incapacita la opci�n')
GO

Insert into Param (IDParam, SrvParameter, SrvValue, SrvType, Description, DefaultValue)
Values (62, 'Confirm delivery after finish sale', 'False', 'Boolean', 'After make a sale, the Hold you not be close until you confirm the delivery', 'False')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (62, 1, 'Confirm delivery after finish sale', 'After make a sale, the Hold you not be close until you confirm the delivery')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (62, 2, 'Confirmar entrega depois do fim da venda', 'Depois que fechar uma venda, confirma a entrega para fechar o pedido')
GO

Insert into ParamLanguage (IDParam, IDLanguage, SrvParameter, Description)
Values (62, 3, 'Confirme la entrega despu�s de la venta', 'Despu�s que hace una venta, el Asidero usted no es cercano hasta que usted confirme la entrega')
GO
