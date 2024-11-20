/********************************************/
/*                VIEWS                     */
/********************************************/

-- VIEW USERS
CREATE OR REPLACE VIEW view_utilizadores AS
SELECT Id_utilizador, Nome, Email, Data_Nascimento, Data_Registo
FROM Utilizadores
ORDER BY Id_utilizador;


-- VIEW PALESTRANTES
CREATE OR REPLACE VIEW view_palestrantes AS
SELECT P.Id_utilizador, U.Nome, U.Email, U.Data_Nascimento, U.Data_Registo, P.CustoPalestrante, P.DataFicouPalestrante
FROM Palestrantes P
    JOIN Utilizadores U
        ON P.Id_utilizador = U.Id_utilizador
ORDER BY P.Id_utilizador;


-- VIEW EMPRESAS
CREATE OR REPLACE VIEW view_empresas AS
SELECT Id_Empresa, Nome, Email, Local, Telefone, Data_Registo
FROM Empresas
ORDER BY Id_Empresa ASC;


-- VIEW EVENTOS
CREATE OR REPLACE VIEW view_eventos AS
SELECT EV.Id_Evento, EV.Nome AS EventoNome, EM.Nome AS EmpresaNome, EV.Data, EV.Local, EV.PrecoInscricao
FROM Eventos EV
    JOIN Empresas EM
        ON EV.Id_Empresa = EM.Id_Empresa
ORDER BY EV.Id_Evento ASC; 


-- VIEW DETALHES EVENTOS
CREATE OR REPLACE VIEW view_eventos_detalhes AS
SELECT EV.*, U.Nome
FROM Eventos EV
    JOIN Utilizadores U
        ON EV.Id_utilizador = U.Id_utilizador
ORDER BY EV.Id_Evento ASC;


-- VIEW PAGAMENTOS
CREATE OR REPLACE VIEW view_pagamentos AS
SELECT P.*, U.Nome
FROM Pagamentos P
    JOIN Inscricoes I
        ON P.Id_Inscricao = I.Id_Inscricao
    JOIN Utilizadores U
        ON I.Id_utilizador = U.Id_utilizador
ORDER BY P.Id_Pagamento ASC;


-- VIEW DESPESAS
CREATE OR REPLACE VIEW view_despesas AS
SELECT D.*, U.Nome
FROM Despesas D
    JOIN Utilizadores U
        ON D.Id_utilizador = U.Id_utilizador
ORDER BY D.Id_Despesa ASC;



/********************************************/
/*              PROCEDURES                  */
/********************************************/

--       UPDATES       --
-- PROCEDURE UPDATE UTILIZADOR
CREATE OR REPLACE PROCEDURE proc_update_utilizador(
    idUtilizador INT, 
    nomeUtilizador VARCHAR(100), 
    emailUtilizador VARCHAR(150),
    dataNascimentoUtilizador TIMESTAMP
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    UPDATE Utilizadores
    SET Nome = nomeUtilizador,
        Email = emailUtilizador,
        Data_Nascimento = dataNascimentoUtilizador
    WHERE Id_utilizador = idUtilizador;
END
$$;


-- PROCEDURE UPDATE PALESTRANTE
CREATE OR REPLACE PROCEDURE proc_update_palestrante(
    idUtilizador INT,
    nomeUtilizador VARCHAR(100), 
    emailUtilizador VARCHAR(150), 
    dataNascimentoUtilizador TIMESTAMP,
    custoPalestrante DECIMAL
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    CALL proc_update_utilizador(idUtilizador, nomeUtilizador, emailUtilizador, dataNascimentoUtilizador);

    UPDATE Palestrantes
    SET CustoPalestrante = custoPalestrante
    WHERE Id_utilizador = idUtilizador;
END
$$;


-- PROCEDURE UPDATE EMPRESAS
CREATE OR REPLACE PROCEDURE proc_update_empresas(
    idEmpresa INT,
    nomeEmpresa VARCHAR(100),
    emailEmpresa VARCHAR(150),
    passwordEmpresa VARCHAR(100),
    localEmpresa VARCHAR(200),
    telefoneEmpresa VARCHAR(25)
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    UPDATE Empresas
    SET Nome = nomeEmpresa,
        Email = emailEmpresa,
        Password = passwordEmpresa,
        Local = localEmpresa,
        Telefone = telefoneEmpresa
    WHERE Id_Empresa = idEmpresa;
END
$$;


-- PROCEDURE UPDATE EVENTOS
CREATE OR REPLACE PROCEDURE proc_update_eventos(
    idEvento INT,
    nomeEvento VARCHAR(100),
    dataEvento TIMESTAMP,
    localEvento VARCHAR(200),
    telefoneEvento VARCHAR(25),
    descricaoEvento VARCHAR(300),
    precoInscricaoEvento DECIMAL
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    UPDATE Eventos
    SET Nome = nomeEvento,
        Data = dataEvento,
        Local = localEvento,
        Telefone = telefoneEvento,
        Descricao = descricaoEvento,
        PrecoInscricao = precoInscricaoEvento
    WHERE Id_Evento = idEvento;
END
$$;


--       DELETES       --
-- PROCEDURE DELETE UTILIZADOR
CREATE OR REPLACE PROCEDURE proc_delete_utilizador(
    idUtilizador INT
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    DELETE FROM Utilizadores
    WHERE Id_utilizador = idUtilizador;
END
$$;


-- PROCEDURE DELETE PALESTRANTE
-- CANCELAR ESCOLHA DE SER PALESTRANTE
CREATE OR REPLACE PROCEDURE proc_delete_palestrante(
    idUtilizador INT
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    DELETE FROM Palestrantes
    WHERE Id_utilizador = idUtilizador;
END
$$;


-- PROCEDURE DELETE EMPRESA
CREATE OR REPLACE PROCEDURE proc_delete_empresa(
    idEmpresa INT
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    DELETE FROM Empresas
    WHERE Id_Empresa = idEmpresa;
END
$$;


-- PROCEDURE DELETE EVENTO
CREATE OR REPLACE PROCEDURE proc_delete_evento(
    idEvento INT
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    DELETE FROM Eventos
    WHERE Id_Evento = idEvento
END
$$;


-- PROCEDURE DELETE INSCRICAO
CREATE OR REPLACE PROCEDURE proc_delete_inscricao(
    idInscricao INT
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    DELETE FROM Inscricoes
    WHERE Id_Inscricao = idInscricao
END
$$;