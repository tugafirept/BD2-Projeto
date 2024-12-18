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
    CP DECIMAL
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    -- Atualiza os dados do utilizador na tabela principal
    CALL proc_update_utilizador(idUtilizador, nomeUtilizador, emailUtilizador, dataNascimentoUtilizador);

    -- Atualiza o custo do palestrante
    UPDATE Palestrantes
    SET custopalestrante = CP 
    WHERE id_utilizador = idUtilizador;
END
$$;


-- PROCEDURE UPDATE EMPRESAS
CREATE OR REPLACE PROCEDURE proc_update_empresas(
    idEmpresa INT,
    nomeEmpresa VARCHAR(100),
    emailEmpresa VARCHAR(150),
    localEmpresa VARCHAR(200),
    telefoneEmpresa VARCHAR(25)
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    UPDATE Empresas
    SET Nome = nomeEmpresa,
        Email = emailEmpresa,
        Local = localEmpresa,
        Telefone = telefoneEmpresa
    WHERE Id_Empresa = idEmpresa;
END
$$;


-- PROCEDURE UPDATE EVENTOS
CREATE OR REPLACE PROCEDURE proc_update_eventos(
    idEvento INT,
    idpalestrante INT,
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
    SET id_utilizador = idpalestrante,
	Nome = nomeEvento,
        Data = dataEvento,
        Local = localEvento,
        Telefone = telefoneEvento,
        Descricao = descricaoEvento,
        PrecoInscricao = precoInscricaoEvento
    WHERE Id_Evento = idEvento;
END
$$;


-- Alterar o proprietário do procedimento UPDATE UTILIZADOR
ALTER PROCEDURE proc_update_utilizador(
    INT, VARCHAR(100), VARCHAR(150), TIMESTAMP
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento UPDATE PALESTRANTE
ALTER PROCEDURE proc_update_palestrante(
    INT, VARCHAR(100), VARCHAR(150), TIMESTAMP, DECIMAL
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento UPDATE EMPRESAS
ALTER PROCEDURE proc_update_empresas(
    INT, VARCHAR(100), VARCHAR(150), VARCHAR(200), VARCHAR(25)
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento UPDATE EVENTOS
ALTER PROCEDURE proc_update_eventos(
    INT, INT, VARCHAR(100), TIMESTAMP, VARCHAR(200), VARCHAR(25), VARCHAR(300), DECIMAL
) OWNER TO bd2admin;
