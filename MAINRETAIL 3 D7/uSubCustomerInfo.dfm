inherited SubCustomerInfo: TSubCustomerInfo
  Left = 482
  Top = 228
  Width = 542
  Height = 118
  Caption = 'SubCustomerInfo'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPessoa: TPanel [0]
    Left = 0
    Top = 0
    Width = 531
    Height = 59
    BevelOuter = bvNone
    Color = cl3DLight
    TabOrder = 0
    DesignSize = (
      531
      59)
    object lbCPhone: TLabel
      Left = 269
      Top = 4
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = 'Phone :'
    end
    object lbCEmail: TLabel
      Left = 275
      Top = 39
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Email :'
    end
    object lbCEmployID: TLabel
      Left = 240
      Top = 22
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'Employee ID :'
    end
    object EditCustomer: TEdit
      Left = 10
      Top = 4
      Width = 228
      Height = 15
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object edtAddress: TEdit
      Left = 10
      Top = 22
      Width = 228
      Height = 15
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object edtComplement: TEdit
      Left = 10
      Top = 39
      Width = 228
      Height = 15
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object edtPhone: TEdit
      Left = 308
      Top = 4
      Width = 91
      Height = 15
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object edtEmpID: TEdit
      Left = 308
      Top = 22
      Width = 91
      Height = 15
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object edtEmail: TEdit
      Left = 308
      Top = 39
      Width = 196
      Height = 15
      TabStop = False
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
    end
    object btDetCliente: TcxButton
      Left = 416
      Top = 5
      Width = 110
      Height = 22
      Anchors = [akTop, akRight]
      Caption = '&Customer Details'
      TabOrder = 6
      OnClick = btDetClienteClick
      DropDownMenu = popupDetails
      Kind = cxbkDropDownButton
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = True
      UseSystemPaint = False
    end
  end
  object pnlCustomerResumed: TPanel [1]
    Left = 0
    Top = -2
    Width = 190
    Height = 55
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object memCustomer: TMemo
      Left = 0
      Top = 0
      Width = 190
      Height = 55
      TabStop = False
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object quCustomer: TADOQuery [2]
    Connection = DM.ADODBConnect
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'IDPessoa'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end>
    SQL.Strings = (
      'SELECT '
      #9'P.IDPessoa, '
      #9'P.PessoaFirstName, '
      #9'P.PessoaLastName,'
      #9'P.Endereco +'
      
        #9'(CASE IsNull(P.ComplementoNum, '#39#39') WHEN '#39#39' THEN '#39#39' ELSE '#39' N'#186' '#39' ' +
        '+ CAST(P.ComplementoNum as varchar) END) +'
      
        #9'(CASE IsNull(P.Complemento, '#39#39') WHEN '#39#39' THEN '#39#39' ELSE '#39', '#39' + P.C' +
        'omplemento END) as Endereco, '
      #9'P.Cidade,'
      #9'P.Bairro,'
      #9'P.CEP,'
      #9'P.Telefone,'
      #9'P.Cellular,'
      #9'P.PhoneAreaCode,'
      #9'P.CellAreaCode,'
      #9'P.Email,'
      #9'P.Nascimento,'
      #9'P.CPF,'
      #9'P.CartTrabalho,'
      #9'P.InscEstadual,'
      #9'P.InscMunicipal,'
      #9'P.NomeJuridico,'
      #9'P.Juridico,'
      #9'P.Pessoa,'
      #9'P.IDUser,'
      #9'PA.CodPais,'
      #9'PA.Pais,'
      #9'E.IDEstado,'
      #9'E.Estado,'
      #9'SU.ComissionID,'
      
        #9'(SELECT COUNT(PA.IDPessoaAddress) FROM Mnt_PessoaAddress PA WHE' +
        'RE PA.IDPessoa = P.IDPessoa) as HasAddress'
      'FROM '
      #9'Pessoa P (NOLOCK)'
      #9'LEFT JOIN Pais PA (NOLOCK) ON (P.IDPais = PA.IDPais)'
      #9'LEFT JOIN Estado E (NOLOCK) ON (E.IDEstado = P.IDEstado)'
      #9'LEFT JOIN SystemUser SU (NOLOCK) ON (P.IDUser = SU.IDUser)'
      'WHERE '
      #9'( P.IDPessoa = :IDPessoa )'
      ' ')
    Left = 157
    Top = 11
    object quCustomerIDPessoa: TIntegerField
      FieldName = 'IDPessoa'
    end
    object quCustomerPessoaFirstName: TStringField
      FieldName = 'PessoaFirstName'
      Origin = 'RETAIL.Pessoa.PessoaFirstName'
      Size = 30
    end
    object quCustomerPessoaLastName: TStringField
      FieldName = 'PessoaLastName'
      Origin = 'RETAIL.Pessoa.PessoaLastName'
      Size = 30
    end
    object quCustomerEndereco: TStringField
      FieldName = 'Endereco'
      Size = 80
    end
    object quCustomerCidade: TStringField
      FieldName = 'Cidade'
      Size = 40
    end
    object quCustomerBairro: TStringField
      FieldName = 'Bairro'
      Size = 50
    end
    object quCustomerCEP: TStringField
      FieldName = 'CEP'
      FixedChar = True
      Size = 12
    end
    object quCustomerTelefone: TStringField
      FieldName = 'Telefone'
      Size = 40
    end
    object quCustomerCellular: TStringField
      FieldName = 'Cellular'
      FixedChar = True
      Size = 18
    end
    object quCustomerEmail: TStringField
      FieldName = 'Email'
      Size = 50
    end
    object quCustomerNascimento: TDateTimeField
      FieldName = 'Nascimento'
    end
    object quCustomerCPF: TStringField
      FieldName = 'CPF'
      Size = 30
    end
    object quCustomerCartTrabalho: TStringField
      FieldName = 'CartTrabalho'
      Size = 30
    end
    object quCustomerInscEstadual: TStringField
      FieldName = 'InscEstadual'
      Size = 30
    end
    object quCustomerInscMunicipal: TStringField
      FieldName = 'InscMunicipal'
      Size = 30
    end
    object quCustomerNomeJuridico: TStringField
      FieldName = 'NomeJuridico'
      Size = 50
    end
    object quCustomerCodPais: TStringField
      FieldName = 'CodPais'
      Size = 3
    end
    object quCustomerPais: TStringField
      FieldName = 'Pais'
      Size = 50
    end
    object quCustomerIDEstado: TStringField
      FieldName = 'IDEstado'
      FixedChar = True
      Size = 3
    end
    object quCustomerEstado: TStringField
      FieldName = 'Estado'
      Size = 50
    end
    object quCustomerJuridico: TBooleanField
      FieldName = 'Juridico'
    end
    object quCustomerPessoa: TStringField
      FieldName = 'Pessoa'
      Size = 50
    end
    object quCustomerPhoneAreaCode: TStringField
      FieldName = 'PhoneAreaCode'
      Size = 5
    end
    object quCustomerCellAreaCode: TStringField
      FieldName = 'CellAreaCode'
      Size = 5
    end
    object quCustomerIDUser: TIntegerField
      FieldName = 'IDUser'
    end
    object quCustomerComissionID: TIntegerField
      FieldName = 'ComissionID'
    end
    object quCustomerHasAddress: TIntegerField
      FieldName = 'HasAddress'
      ReadOnly = True
    end
  end
  inherited siLang: TsiLangRT
    StorageFile = 'MR_SubCustomerInfo.sil'
  end
  object popupDetails: TPopupMenu
    Left = 92
    Top = 8
    object btnChangeCustomer: TMenuItem
      Caption = 'Change Customer'
      OnClick = btnChangeCustomerClick
    end
  end
end