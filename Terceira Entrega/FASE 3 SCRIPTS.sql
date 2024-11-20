-- VIEW USERS
CREATE VIEW view_utilizadores AS
SELECT Id_utilizador, Nome, Email, Data_Nascimento, Data_Registo
FROM Utilizadores
ORDER BY Id_utilizador;


-- VIEW PALESTRANTES
CREATE VIEW view_palestrantes AS
SELECT P.Id_utilizador, U.Nome, U.Email, U.Data_Nascimento, U.Data_Registo, P.CustoPalestrante, P.DataFicouPalestrante
FROM Palestrantes P
    JOIN Utilizadores U
        ON P.Id_utilizador = U.Id_utilizador
ORDER BY P.Id_utilizador;


-- VIEW ADMINS
CREATE VIEW view_administradores AS
SELECT A.Id_utilizador, U.Nome, U.Email, U.Data_Nascimento, U.Data_Registo, A.DataAdmin
FROM Administradores A
    JOIN Utilizadores U
        ON A.Id_utilizador = U.Id_utilizador
ORDER BY A.Id_utilizador;


-- VIEW EMPRESAS
CREATE VIEW view_empresas AS
SELECT Id_Empresa, Nome, Email, Local, Telefone, Data_Registo
FROM Empresas
ORDER BY Id_Empresa ASC;


-- VIEW EVENTOS
CREATE VIEW view_eventos AS
SELECT EV.Id_Evento, EV.Nome AS EventoNome, EM.Nome AS EmpresaNome, EV.Data, EV.Local, EV.PrecoInscricao
FROM Eventos EV
    JOIN Empresas EM
        ON EV.Id_Empresa = EM.Id_Empresa
ORDER BY EV.Id_Evento ASC; 


-- VIEW DETALHES EVENTOS
CREATE VIEW view_eventos_detalhes AS
SELECT EV.*, U.Nome
FROM Eventos EV
    JOIN Utilizadores U
        ON EV.Id_utilizador = U.Id_utilizador
ORDER BY EV.Id_Evento ASC;


-- VIEW PAGAMENTOS
CREATE VIEW view_pagamentos AS
SELECT P.*, U.Nome
FROM Pagamentos P
    JOIN Inscricoes I
        ON P.Id_Inscricao = I.Id_Inscricao
    JOIN Utilizadores U
        ON I.Id_utilizador = U.Id_utilizador
ORDER BY P.Id_Pagamento ASC;


-- VIEW DESPESAS
CREATE VIEW view_despesas AS
SELECT D.*, U.Nome
FROM Despesas D
    JOIN Utilizadores U
        ON D.Id_utilizador = U.Id_utilizador
ORDER BY D.Id_Despesa ASC;



/*
-- PROCEDURE VIEW DESPESAS
CREATE PROCEDURE proc_despesas(idEvento INT, idUtilizador INT)
LANGUAGE PLPGSQL
AS $$
BEGIN
RETURN QUERY
    
END
$$;
*/


-- FUNCTION DATA REGISTO 
CREATE OR REPLACE FUNCTION set_data_registo()
RETURNS TRIGGER AS $$
BEGIN
    NEW.DATA_REGISTO := date_trunc('second', CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- TRIGGER DATA REGISTO
CREATE TRIGGER trigger_set_data_registo
BEFORE INSERT ON UTILIZADORES
FOR EACH ROW
EXECUTE FUNCTION set_data_registo();
