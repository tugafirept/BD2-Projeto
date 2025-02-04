--PROCEDIMENTO DE CRIAR EVENTO

CREATE OR REPLACE PROCEDURE public.insert_evento(
    IN p_id_empresa INTEGER,
    IN p_id_utilizador INTEGER,
    IN p_nome VARCHAR,
    IN p_data TIMESTAMP,
    IN p_local VARCHAR,
    IN p_telefone VARCHAR,
    IN p_descricao VARCHAR,
    IN p_preco_inscricao DECIMAL,
    IN p_preco_total_evento DECIMAL
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Inserir um novo registro na tabela EVENTOS usando a sequência para gerar o ID_EVENTO
    INSERT INTO EVENTOS (
        ID_EVENTO,
        ID_EMPRESA,
        ID_UTILIZADOR,
        NOME,
        DATA,
        LOCAL,
        TELEFONE,
        DESCRICAO,
        PRECOINSCRICAO,
        PRECOTOTALEVENTO,
        DATA_CRIACAO
    )
    VALUES (
        NEXTVAL('seq_eventos_id_evento'),
        p_id_empresa,
        p_id_utilizador,
        p_nome,
        p_data,
        p_local,
        p_telefone,
        p_descricao,
        p_preco_inscricao,
        p_preco_total_evento,
        NOW() -- Define a data de criação como a data e hora atuais
    );
END;
$BODY$;


--PROCEDIMENTO DE CRIAR PAGAMENTO

CREATE OR REPLACE PROCEDURE public.insert_pagamento(
    IN p_id_inscricao INTEGER,
    IN p_id_evento INTEGER,
    IN p_total DECIMAL,
    IN p_data TIMESTAMP
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Inserir um novo registro na tabela PAGAMENTOS usando a sequência para gerar o ID_PAGAMENTO
    INSERT INTO PAGAMENTOS (
        ID_PAGAMENTO,
        ID_INSCRICAO,
        ID_EVENTO,
        TOTAL,
        DATA
    )
    VALUES (
        NEXTVAL('seq_pagamentos_id_pagamento'), 
        p_id_inscricao,
        p_id_evento,
        p_total,
        p_data
    );
END;
$BODY$;


--PROCEDIMENTO DE CRIAR INSCRICAO

CREATE OR REPLACE PROCEDURE public.insert_inscricao(
	IN p_id_evento integer,
	IN p_id_utilizador integer)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Inserir um novo registro na tabela INSCRICOES usando a sequência para gerar o ID_INSCRICAO
    INSERT INTO INSCRICOES (
        ID_INSCRICAO,
        ID_EVENTO,
        ID_UTILIZADOR,
        DATA_INSCRICAO
    )
    VALUES (
        NEXTVAL('seq_inscricoes_id_inscricao'),
        p_id_evento,
        p_id_utilizador,
        now()
    );

END;
$BODY$;


--PROCEDIMENTO DE CRIAR DESPESA

CREATE OR REPLACE PROCEDURE public.insert_despesa(
    IN p_id_evento INTEGER,
    IN p_id_utilizador INTEGER,
    IN p_total DECIMAL,
    IN p_data TIMESTAMP
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Inserir um novo registro na tabela DESPESAS usando a sequência para gerar o ID_DESPESA
    INSERT INTO DESPESAS (
        ID_DESPESA,
        ID_EVENTO,
        ID_UTILIZADOR,
        TOTAL,
        DATA
    )
    VALUES (
        NEXTVAL('seq_despesas_id_despesa'), 
        p_id_evento,
        p_id_utilizador,
        p_total,
        p_data
    );
END;
$BODY$;


--PROCEDIMENTO PARA CRIAR EMPRESA

CREATE OR REPLACE PROCEDURE public.insert_empresa(
    IN p_nome VARCHAR,
    IN p_email VARCHAR,
    IN p_password VARCHAR,
    IN p_local VARCHAR DEFAULT NULL,
    IN p_telefone VARCHAR DEFAULT NULL
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Inserir um novo registro na tabela EMPRESAS
    INSERT INTO EMPRESAS (
        ID_EMPRESA,
        NOME,
        EMAIL,
        PASSWORD,
        LOCAL,
        TELEFONE,
        DATA_REGISTO
    )
    VALUES (
        NEXTVAL('seq_empresas_id_empresa'),
        p_nome,
        p_email,
        MD5(p_password),
        p_local,
        p_telefone,
        NOW() 
    );
END;
$BODY$;


--PROCEDIMENTO PARA CRIAR UTILIZADORES

CREATE OR REPLACE PROCEDURE public.insert_utilizador(
    IN p_nome VARCHAR,
    IN p_email VARCHAR,
    IN p_password VARCHAR,
    IN p_data_nascimento TIMESTAMP DEFAULT NULL
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Inserir um novo registro na tabela UTILIZADORES
    INSERT INTO UTILIZADORES (
        ID_UTILIZADOR,
        NOME,
        EMAIL,
        PASSWORD,
        DATA_NASCIMENTO
    )
    VALUES (
        NEXTVAL('seq_utilizadores_id_utilizador'),
        p_nome,
        p_email,
        MD5(p_password),
        p_data_nascimento
    );
END;
$BODY$;


--PROCEDIMENTO PARA CRIAR PALESTRANTES

CREATE OR REPLACE PROCEDURE public.insert_palestrante(
    IN p_id_utilizador INTEGER,
    IN p_custo_palestrante DECIMAL DEFAULT NULL
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Inserir um novo registro na tabela PALESTRANTES
    INSERT INTO PALESTRANTES (
        ID_UTILIZADOR,
        DATAFICOUPALESTRANTE,
        CUSTOPALESTRANTE
    )
    VALUES (
        p_id_utilizador,
        NOW(),  -- Define a data atual
        COALESCE(p_custo_palestrante, 0)           -- Define custo 0 se não fornecido
    );
END;
$BODY$;


--PROCEDIMENTO PARA CRIAR ADMINISTRADORES

CREATE OR REPLACE PROCEDURE public.insert_administrador(
    IN p_id_utilizador INTEGER,
    IN p_data_admin TIMESTAMP DEFAULT NULL
)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Inserir um novo registro na tabela ADMINISTRADORES
    INSERT INTO ADMINISTRADORES (
        ID_UTILIZADOR,
        DATAADMIN
    )
    VALUES (
        p_id_utilizador,
        COALESCE(p_data_admin, NOW()) -- Define a data atual se nenhuma for fornecida
    );
END;
$BODY$;


-- Alterar o proprietário do procedimento INSERT EVENTO
ALTER PROCEDURE public.insert_evento(
    INTEGER, INTEGER, VARCHAR, TIMESTAMP, VARCHAR, VARCHAR, VARCHAR, DECIMAL, DECIMAL
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento INSERT PAGAMENTO
ALTER PROCEDURE public.insert_pagamento(
    INTEGER, INTEGER, DECIMAL, TIMESTAMP
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento INSERT INSCRICAO
ALTER PROCEDURE public.insert_inscricao(
    INTEGER, INTEGER
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento INSERT DESPESA
ALTER PROCEDURE public.insert_despesa(
    INTEGER, INTEGER, DECIMAL, TIMESTAMP
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento INSERT EMPRESA
ALTER PROCEDURE public.insert_empresa(
    VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento INSERT UTILIZADOR
ALTER PROCEDURE public.insert_utilizador(
    VARCHAR, VARCHAR, VARCHAR, TIMESTAMP
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento INSERT PALESTRANTE
ALTER PROCEDURE public.insert_palestrante(
    INTEGER, DECIMAL
) OWNER TO bd2admin;

-- Alterar o proprietário do procedimento INSERT ADMINISTRADOR
ALTER PROCEDURE public.insert_administrador(
    INTEGER, TIMESTAMP
) OWNER TO bd2admin;








