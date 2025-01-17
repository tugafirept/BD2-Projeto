--Todas as passwords são "123" mas estão em MD5

-- Inserir dados na tabela UTILIZADORES
INSERT INTO UTILIZADORES (ID_UTILIZADOR, NOME, EMAIL, PASSWORD, DATA_NASCIMENTO, DATA_REGISTO) VALUES
(1, 'João Silva', 'joao.silva@example.com', '202cb962ac59075b964b07152d234b70', '1990-01-15', '2024-01-01'),
(2, 'Maria Costa', 'maria.costa@example.com', '202cb962ac59075b964b07152d234b70', '1985-07-20', '2024-01-02'),
(3, 'Pedro Santos', 'pedro.santos@example.com', '202cb962ac59075b964b07152d234b70', '1995-09-10', '2024-01-03'),
(4, 'Ana Lopes', 'ana.lopes@example.com', '202cb962ac59075b964b07152d234b70', '1998-03-05', '2024-01-04'),
(5, 'Carlos Pereira', 'carlos.pereira@example.com', '202cb962ac59075b964b07152d234b70', '1982-11-25', '2024-01-05');

-- Inserir dados na tabela PALESTRANTES
INSERT INTO PALESTRANTES (ID_UTILIZADOR, DATAFICOUPALESTRANTE, CUSTOPALESTRANTE) VALUES
(3, '2024-01-03', 300.00),
(4, '2024-01-04', 100.00),
(5, '2024-01-05', 250.00);

-- Inserir dados na tabela ADMINISTRADORES
INSERT INTO ADMINISTRADORES (ID_UTILIZADOR, DATAADMIN) VALUES
(1, '2024-01-01'),
(2, '2024-01-02');

-- Inserir dados na tabela EMPRESAS
INSERT INTO EMPRESAS (ID_EMPRESA, NOME, EMAIL, PASSWORD, LOCAL, TELEFONE, DATA_REGISTO) VALUES
(1, 'Empresa A', 'empresa.a@example.com', '202cb962ac59075b964b07152d234b70', 'Lisboa', '123456789', '2024-01-01'),
(2, 'Empresa B', 'empresa.b@example.com', '202cb962ac59075b964b07152d234b70', 'Porto', '987654321', '2024-01-02'),
(3, 'Empresa C', 'empresa.c@example.com', '202cb962ac59075b964b07152d234b70', 'Faro', '567123890', '2024-01-03'),
(4, 'Empresa D', 'empresa.d@example.com', '202cb962ac59075b964b07152d234b70', 'Braga', '890123456', '2024-01-04'),
(5, 'Empresa E', 'empresa.e@example.com', '202cb962ac59075b964b07152d234b70', 'Coimbra', '321789654', '2024-01-05');

-- Inserir dados na tabela EVENTOS
INSERT INTO EVENTOS (ID_EVENTO, ID_EMPRESA, ID_UTILIZADOR, NOME, DATA, LOCAL, TELEFONE, DESCRICAO, PRECOINSCRICAO, PRECOTOTALEVENTO, DATA_CRIACAO) VALUES
(1, 1, 3, 'Evento 1', '2024-02-10', 'Lisboa', '123456789', 'Descrição do Evento 1', 50.00, 500.00, '2024-01-01'),
(2, 2, 4, 'Evento 2', '2024-02-15', 'Porto', '987654321', 'Descrição do Evento 2', 60.00, 600.00, '2024-01-02'),
(3, 3, 3, 'Evento 3', '2024-02-20', 'Faro', '567123890', 'Descrição do Evento 3', 70.00, 700.00, '2024-01-03'),
(4, 4, 4, 'Evento 4', '2024-02-25', 'Braga', '890123456', 'Descrição do Evento 4', 80.00, 800.00, '2024-01-04'),
(5, 5, 5, 'Evento 5', '2024-03-01', 'Coimbra', '321789654', 'Descrição do Evento 5', 90.00, 900.00, '2024-01-05');

-- Inserir dados na tabela DESPESAS
INSERT INTO DESPESAS (ID_DESPESA, ID_EVENTO, ID_UTILIZADOR, TOTAL, DATA) VALUES
(1, 1, 3, 300.00, '2024-02-11'),
(2, 2, 4, 400.00, '2024-02-16'),
(3, 3, 3, 300.00, '2024-02-21'),
(4, 4, 4, 400.00, '2024-02-26'),
(5, 5, 5, 500.00, '2024-03-02');

-- Inserir dados na tabela INSCRICOES
INSERT INTO INSCRICOES (ID_INSCRICAO, ID_EVENTO, ID_UTILIZADOR, DATA_INSCRICAO) VALUES
(1, 1, 1, '2024-01-05'),
(2, 2, 2, '2024-01-06'),
(3, 3, 4, '2024-01-07'),
(4, 4, 3, '2024-01-08'),
(5, 5, 2, '2024-01-09');

-- Inserir dados na tabela PAGAMENTOS
INSERT INTO PAGAMENTOS (ID_PAGAMENTO, ID_INSCRICAO, ID_EVENTO, TOTAL, DATA) VALUES
(1, 1, 1, 50.00, '2024-01-10'),
(2, 2, 2, 60.00, '2024-01-11'),
(3, 3, 4, 70.00, '2024-01-12'),
(4, 4, 3, 80.00, '2024-01-13'),
(5, 5, 2, 90.00, '2024-01-14');
