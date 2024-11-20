-- VIEW USERS
CREATE VIEW view_utilizadores AS
SELECT Id_utilizador, Nome, Email, Data_Nascimento, Data_Registo
FROM Utilizadores
ORDER BY Id_utilizador;


-- VIEW PALESTRANTES
CREATE VIEW view_palestrantes AS
SELECT P.Id_utilizador, U.Nome, U.Email, U.Data_Nascimento, U.Data_Registo, P.CustoPalestrante, P.DataFicouPalestrante
FROM Palestrantes P JOIN Utilizadores U ON P.Id_utilizador = U.Id_utilizador
ORDER BY P.Id_utilizador;


-- VIEW ADMINS
CREATE VIEW view_administradores AS
SELECT A.Id_utilizador, U.Nome, U.Email, U.Data_Nascimento, U.Data_Registo, A.DataAdmin
FROM Administradores A JOIN Utilizadores U ON A.Id_utilizador = U.Id_utilizador
ORDER BY A.Id_utilizador;


-- VIEW EMPRESAS
CREATE VIEW view_empresas AS
SELECT Id_Empresa, Nome, Email, Local, Telefone, Data_Registo
FROM Empresas
ORDER BY Id_Empresa ASC;


-- PROCEDURE VIEW EVENTOS
CREATE PROCEDURE proc_evento(id_emp INT)
LANGUAGE PLPGSQL
AS $$
BEGIN
    SELECT EV.Id_Evento, EM.Nome, EV.Nome, EV.Data, EV.Local, EV.PrecoInscricao
    FROM Eventos EV JOIN Empresas EM ON EM.Id_Empresa = EV.Id_Empresa
    WHERE EM.Id_Empresa = id_emp
    ORDER BY EV.Id_Evento
END
$$;