CREATE TABLE TABPRODUTOS(
	NCHPRODUTO INTEGER IDENTITY(1,1) PRIMARY KEY,
	TDESCRICAO VARCHAR(80),
	TCODIGOBARRAS VARCHAR(30),
	TUNIDADE VARCHAR(10),
	NVALORVENDA FLOAT,
	NQTDESTOQUE FLOAT
);