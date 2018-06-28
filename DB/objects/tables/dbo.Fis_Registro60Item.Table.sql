USE [a0000748__2014-03-30]
GO
/****** Object:  Table [dbo].[Fis_Registro60Item]    Script Date: 04/16/2014 10:08:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Fis_Registro60Item](
	[DataEmissao] [datetime] NOT NULL,
	[NumeroSerie] [dbo].[TNumeroSerie] NOT NULL,
	[ModeloDocumentoFiscal] [char](2) NULL,
	[NumeroOrdem] [int] NOT NULL,
	[NumeroItem] [int] NOT NULL,
	[CodigoProdutoServico] [char](14) NULL,
	[ValorUnitario] [dbo].[TValorNull] NULL,
	[BaseCalculoICMS] [dbo].[TValorNull] NULL,
	[SituacaoTributaria] [char](4) NULL,
	[ValorICMS] [dbo].[TValorNull] NULL,
	[Qtde] [decimal](38, 4) NULL,
	[ReplLastChange] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO