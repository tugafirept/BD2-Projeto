-- Teste: Atualizar Utilizador
DO $$ 
DECLARE
    v_id_utilizador INTEGER;
BEGIN
    -- Criar um utilizador para testar
    INSERT INTO UTILIZADORES (ID_UTILIZADOR, NOME, EMAIL, PASSWORD, DATA_NASCIMENTO, DATA_REGISTO) 
    VALUES (NEXTVAL('seq_utilizadores_id_utilizador'), 'Utilizador Teste', 'teste@exemplo.com', MD5('password'), '1990-01-01', NOW());

    -- Obter o ID do utilizador criado
    SELECT MAX(ID_UTILIZADOR) INTO v_id_utilizador FROM UTILIZADORES;
    
    -- Teste de atualização do utilizador
    CALL proc_update_utilizador(
        v_id_utilizador::INTEGER,
        'Utilizador Teste Atualizado'::VARCHAR,
        'teste_atualizado@exemplo.com'::VARCHAR,
        '1989-12-31'::TIMESTAMP
    );

    -- Validar atualização
    RAISE NOTICE 'Utilizador atualizado com ID %', v_id_utilizador;
END $$;

-- Teste: Atualizar Palestrante
DO $$ 
DECLARE
    v_id_utilizador INTEGER;
    v_id_palestrante INTEGER;
BEGIN
    -- Criar um utilizador e um palestrante para testar
    INSERT INTO UTILIZADORES (ID_UTILIZADOR, NOME, EMAIL, PASSWORD, DATA_NASCIMENTO, DATA_REGISTO) 
    VALUES (NEXTVAL('seq_utilizadores_id_utilizador'), 'Palestrante Teste', 'palestrante@exemplo.com', MD5('password'), '1985-06-15', NOW());

    -- Obter o ID do utilizador criado
    SELECT MAX(ID_UTILIZADOR) INTO v_id_utilizador FROM UTILIZADORES;

    -- Criar um palestrante associado ao utilizador
    CALL public.insert_palestrante(v_id_utilizador, 100.00);

    -- Obter o ID do palestrante
    SELECT MAX(ID_UTILIZADOR) INTO v_id_palestrante FROM PALESTRANTES;

    -- Teste de atualização do palestrante
    CALL proc_update_palestrante(
        v_id_utilizador::INTEGER, 
        'Palestrante Teste Atualizado'::VARCHAR,
        'palestrante_atualizado@exemplo.com'::VARCHAR,
        '1984-06-15'::TIMESTAMP,
        150.00::DECIMAL
    );

    -- Validar atualização
    RAISE NOTICE 'Palestrante atualizado com ID %', v_id_utilizador;
END $$;

-- Teste: Atualizar Empresa
DO $$ 
DECLARE
    v_id_empresa INTEGER;
BEGIN
    -- Criar uma empresa para testar
    INSERT INTO EMPRESAS (ID_EMPRESA, NOME, EMAIL, PASSWORD, LOCAL, TELEFONE, DATA_REGISTO) 
    VALUES (NEXTVAL('seq_empresas_id_empresa'), 'Empresa Teste', 'empresa@exemplo.com', MD5('password'), 'Lisboa', '123456789', NOW());

    -- Obter o ID da empresa criada
    SELECT MAX(ID_EMPRESA) INTO v_id_empresa FROM EMPRESAS;

    -- Teste de atualização da empresa
    CALL proc_update_empresas(
        v_id_empresa::INTEGER,
        'Empresa Teste Atualizada'::VARCHAR,
        'empresa_atualizada@exemplo.com'::VARCHAR,
        'Porto'::VARCHAR,
        '987654321'::VARCHAR
    );

    -- Validar atualização
    RAISE NOTICE 'Empresa atualizada com ID %', v_id_empresa;
END $$;

-- Teste: Atualizar Evento
DO $$ 
DECLARE
    v_id_empresa INTEGER;
    v_id_utilizador INTEGER;
    v_id_evento INTEGER;
BEGIN
    -- Criar uma empresa e um utilizador para associar ao evento
    INSERT INTO EMPRESAS (ID_EMPRESA, NOME, EMAIL, PASSWORD, LOCAL, TELEFONE, DATA_REGISTO) 
    VALUES (NEXTVAL('seq_empresas_id_empresa'), 'Empresa Teste', 'empresa@exemplo.com', MD5('password'), 'Lisboa', '123456789', NOW());

    INSERT INTO UTILIZADORES (ID_UTILIZADOR, NOME, EMAIL, PASSWORD, DATA_NASCIMENTO, DATA_REGISTO) 
    VALUES (NEXTVAL('seq_utilizadores_id_utilizador'), 'Utilizador Teste', 'teste@exemplo.com', MD5('password'), '1990-01-01', NOW());

    -- Obter os IDs criados
    SELECT MAX(ID_EMPRESA) INTO v_id_empresa FROM EMPRESAS;
    SELECT MAX(ID_UTILIZADOR) INTO v_id_utilizador FROM UTILIZADORES;

    -- Adicionar o utilizador à tabela de palestrantes
    CALL public.insert_palestrante(v_id_utilizador, 100.00);

    -- Criar evento associado ao utilizador e à empresa
    CALL public.insert_evento(
        v_id_empresa::INTEGER, 
        v_id_utilizador::INTEGER,
        'Evento Teste'::VARCHAR, 
        (NOW() + INTERVAL '1 day')::TIMESTAMP, 
        'Lisboa'::VARCHAR, 
        '987654321'::VARCHAR, 
        'Descrição do evento de teste'::VARCHAR, 
        50.00::DECIMAL, 
        500.00::DECIMAL
    );

    -- Obter o ID do evento criado
    SELECT MAX(ID_EVENTO) INTO v_id_evento FROM EVENTOS;

    -- Teste de atualização do evento
    CALL proc_update_eventos(
        v_id_evento::INTEGER,
        v_id_utilizador::INTEGER,
        'Evento Teste Atualizado'::VARCHAR,
        (NOW() + INTERVAL '2 day')::TIMESTAMP, 
        'Porto'::VARCHAR,
        '987654322'::VARCHAR,
        'Descrição do evento atualizado'::VARCHAR,
        100.00::DECIMAL
    );

    -- Validar atualização
    RAISE NOTICE 'Evento atualizado com ID %', v_id_evento;
END $$;
