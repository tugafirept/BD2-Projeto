-- TRIGGER DATA REGISTO
CREATE OR REPLACE FUNCTION set_data_registo()
RETURNS TRIGGER AS $$
BEGIN
    NEW.DATA_REGISTO := date_trunc('second', CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_data_registo
BEFORE INSERT ON UTILIZADORES
FOR EACH ROW
EXECUTE FUNCTION set_data_registo();




-- TRIGGER VALIDAR EMAIL
CREATE OR REPLACE FUNCTION validar_email_unico()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM UTILIZADORES WHERE EMAIL = NEW.EMAIL) THEN
        RAISE EXCEPTION 'Email já existe!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_validar_email_unico
BEFORE INSERT ON UTILIZADORES
FOR EACH ROW
EXECUTE FUNCTION validar_email_unico();




-- FUNCTION EXCLUSÃO USER
CREATE OR REPLACE FUNCTION excluir_utilizador_cascata()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM ADMINISTRADORES WHERE ID_UTILIZADOR = OLD.ID_UTILIZADOR;
    
    -- Substituir o palestrante
    UPDATE EVENTOS
    SET ID_UTILIZADOR = 0
    WHERE ID_UTILIZADOR = OLD.ID_UTILIZADOR;

    DELETE FROM PALESTRANTES WHERE ID_UTILIZADOR = OLD.ID_UTILIZADOR;

    DELETE FROM INSCRICOES WHERE ID_UTILIZADOR = OLD.ID_UTILIZADOR;
    DELETE FROM PAGAMENTOS WHERE ID_INSCRICAO IN (SELECT ID_INSCRICAO FROM INSCRICOES WHERE ID_UTILIZADOR = OLD.ID_UTILIZADOR);
    DELETE FROM DESPESAS WHERE ID_UTILIZADOR = OLD.ID_UTILIZADOR;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER EXCLUSÃO USER
CREATE OR REPLACE TRIGGER trigger_excluir_utilizador_cascata
BEFORE DELETE ON UTILIZADORES
FOR EACH ROW
EXECUTE FUNCTION excluir_utilizador_cascata();




-- FUNCTION EXCLUSÃO EVENTOS
CREATE OR REPLACE FUNCTION excluir_evento_cascata()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM DESPESAS WHERE ID_EVENTO = OLD.ID_EVENTO;
	DELETE FROM PAGAMENTOS WHERE ID_EVENTO = OLD.ID_EVENTO;
    DELETE FROM INSCRICOES WHERE ID_EVENTO = OLD.ID_EVENTO;
        
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER EXCLUSÃO EVENTOS
CREATE OR REPLACE TRIGGER trigger_excluir_evento_cascata
BEFORE DELETE ON EVENTOS
FOR EACH ROW
EXECUTE FUNCTION excluir_evento_cascata();




-- FUNCTION EXCLUIR EMPRESAS
CREATE OR REPLACE FUNCTION excluir_empresa_cascata()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM EVENTOS WHERE ID_EMPRESA = OLD.ID_EMPRESA;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER EXCLUIR EMPRESAS
CREATE OR REPLACE TRIGGER trigger_excluir_empresa_cascata
BEFORE DELETE ON EMPRESAS
FOR EACH ROW
EXECUTE FUNCTION excluir_empresa_cascata();



CREATE OR REPLACE FUNCTION excluir_inscricao()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM PAGAMENTOS WHERE ID_INSCRICAO = OLD.ID_INSCRICAO;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_excluir_inscricao
BEFORE DELETE ON INSCRICOES
FOR EACH ROW
EXECUTE FUNCTION excluir_inscricao();




CREATE OR REPLACE FUNCTION create_depesa_palestrante()
RETURNS TRIGGER AS $$
DECLARE
    valor_palestrante DECIMAL;
BEGIN
    SELECT custopalestrante INTO valor_palestrante FROM PALESTRANTES WHERE ID_UTILIZADOR = NEW.ID_UTILIZADOR;

    INSERT INTO DESPESAS
    VALUES(nextval('seq_despesas_id_despesa'), NEW.ID_EVENTO, NEW.ID_UTILIZADOR, valor_palestrante, NEW.DATA_CRIACAO);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_create_despesa_palestrante
AFTER INSERT ON EVENTOS
FOR EACH ROW
EXECUTE FUNCTION create_depesa_palestrante();



CREATE OR REPLACE FUNCTION create_inscricao_pagamentos()
RETURNS TRIGGER AS $$
DECLARE
    valor_inscricao DECIMAL;
BEGIN
    SELECT precoinscricao INTO valor_inscricao FROM eventos WHERE id_evento = NEW.id_evento;

    CALL insert_pagamento(NEW.id_inscricao, NEW.id_evento, valor_inscricao, current_timestamp::TIMESTAMP);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_create_inscricao_pagamentos
AFTER INSERT ON INSCRICOES
FOR EACH ROW
EXECUTE FUNCTION create_inscricao_pagamentos();





-- Função de Login com MD5
CREATE OR REPLACE FUNCTION login(
    p_email varchar,
    p_senha varchar
)
RETURNS TABLE(id INT, tipo TEXT) AS $$
DECLARE
    v_id_utilizador INT;
BEGIN
    -- Verifica se é uma empresa
    IF EXISTS (SELECT 1 FROM EMPRESAS WHERE EMAIL = p_email AND PASSWORD = MD5(p_senha)) THEN
		v_id_utilizador := (SELECT id_empresa FROM empresas WHERE EMAIL = p_email AND PASSWORD = MD5(p_senha));
        RETURN QUERY
        SELECT v_id_utilizador, 'empresa';
    -- Verifica se é um administrador
    ELSIF EXISTS (SELECT 1 FROM ADMINISTRADORES WHERE ID_UTILIZADOR = (SELECT ID_UTILIZADOR FROM UTILIZADORES WHERE EMAIL = p_email AND PASSWORD = MD5(p_senha))) THEN
        v_id_utilizador := (SELECT ID_UTILIZADOR FROM UTILIZADORES WHERE EMAIL = p_email AND PASSWORD = MD5(p_senha));
        RETURN QUERY
        SELECT v_id_utilizador, 'administrador';
    -- Verifica se é um palestrante
    ELSIF EXISTS (SELECT 1 FROM PALESTRANTES WHERE ID_UTILIZADOR = (SELECT ID_UTILIZADOR FROM UTILIZADORES WHERE EMAIL = p_email AND PASSWORD = MD5(p_senha))) THEN
        v_id_utilizador := (SELECT ID_UTILIZADOR FROM UTILIZADORES WHERE EMAIL = p_email AND PASSWORD = MD5(p_senha));
        RETURN QUERY
        SELECT v_id_utilizador, 'palestrante';
    -- Caso contrário, verifica se é um utilizador normal
    ELSIF EXISTS (SELECT 1 FROM UTILIZADORES WHERE EMAIL = p_email AND PASSWORD = MD5(p_senha)) THEN
        v_id_utilizador := (SELECT ID_UTILIZADOR FROM UTILIZADORES WHERE EMAIL = p_email AND PASSWORD = MD5(p_senha));
        RETURN QUERY
        SELECT v_id_utilizador, 'utilizador';
    ELSE
        -- Se não encontrar nenhum tipo de utilizador, retorna NULL
        RETURN QUERY SELECT NULL::INT, 'invalido'::TEXT;
    END IF;
END;
$$ LANGUAGE plpgsql;



-- Alterar o proprietário das funções e triggers para bd2admin

-- FUNÇÃO DATA REGISTO
ALTER FUNCTION set_data_registo() OWNER TO bd2admin;

-- FUNÇÃO VALIDAR EMAIL
ALTER FUNCTION validar_email_unico() OWNER TO bd2admin;

-- FUNÇÃO EXCLUSÃO USER
ALTER FUNCTION excluir_utilizador_cascata() OWNER TO bd2admin;

-- FUNÇÃO EXCLUSÃO EVENTOS
ALTER FUNCTION excluir_evento_cascata() OWNER TO bd2admin;

-- FUNÇÃO EXCLUSÃO Empresas
ALTER FUNCTION excluir_empresa_cascata() OWNER TO bd2admin;

-- FUNÇÃO login
ALTER FUNCTION login OWNER TO bd2admin;

ALTER FUNCTION excluir_inscricao() OWNER TO bd2admin;

ALTER FUNCTION create_inscricao_pagamentos() OWNER TO bd2admin;

ALTER FUNCTION create_depesa_palestrante() OWNER TO bd2admin;