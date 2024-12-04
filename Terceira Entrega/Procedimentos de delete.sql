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
    WHERE Id_Evento = idEvento;
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
    WHERE Id_Inscricao = idInscricao;
END
$$;
