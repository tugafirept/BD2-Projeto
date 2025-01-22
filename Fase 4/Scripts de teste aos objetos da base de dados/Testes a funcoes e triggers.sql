-- Teste: Inserção de Utilizador
DO $$ 
DECLARE
    v_id_utilizador INTEGER;
BEGIN
    -- Inserir um utilizador com email único
    INSERT INTO UTILIZADORES (ID_UTILIZADOR, NOME, EMAIL, PASSWORD, DATA_NASCIMENTO, DATA_REGISTO) 
    VALUES (NEXTVAL('seq_utilizadores_id_utilizador'), 'Test User', 'user@example.com', MD5('password'), '1990-01-01', NOW());

    -- Obter o ID do utilizador criado
    SELECT MAX(ID_UTILIZADOR) INTO v_id_utilizador FROM UTILIZADORES;

    -- Teste da Trigger de Email Único (inserção com email já existente)
    BEGIN
        INSERT INTO UTILIZADORES (ID_UTILIZADOR, NOME, EMAIL, PASSWORD, DATA_NASCIMENTO, DATA_REGISTO) 
        VALUES (NEXTVAL('seq_utilizadores_id_utilizador'), 'Test User 2', 'user@example.com', MD5('password'), '1992-01-01', NOW());
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Erro esperado de email duplicado: %', SQLERRM;
    END;
END $$;

-- Teste: Inserção de Evento
DO $$ 
DECLARE
    v_id_empresa INTEGER;
    v_id_evento INTEGER;
BEGIN
    -- Criar uma empresa e associar ao evento
    INSERT INTO EMPRESAS (ID_EMPRESA, NOME, EMAIL, PASSWORD, LOCAL, TELEFONE, DATA_REGISTO) 
    VALUES (NEXTVAL('seq_empresas_id_empresa'), 'Empresa Teste', 'empresa@exemplo.com', MD5('password'), 'Lisboa', '123456789', NOW());

    -- Obter o ID da empresa criada
    SELECT MAX(ID_EMPRESA) INTO v_id_empresa FROM EMPRESAS;

    -- Criar evento associado à empresa
    CALL public.insert_evento(
        v_id_empresa, 
        7, -- Usai ID de utilizador 7 para fins de teste
        'Evento Teste', 
        (NOW() + INTERVAL '1 day')::TIMESTAMP, 
        'Lisboa', 
        '987654321', 
        'Descrição do evento de teste', 
        50.00, 
        500.00
    );

    -- Obter o ID do evento criado
    SELECT MAX(ID_EVENTO) INTO v_id_evento FROM EVENTOS;

    -- Validar trigger de criação de despesas do palestrante
    RAISE NOTICE 'Evento criado com ID %', v_id_evento;
END $$;

-- Teste: Exclusão de Utilizador com Cascata
DO $$ 
DECLARE
    v_id_utilizador INTEGER;
BEGIN
    -- Criar utilizador e associar a ele um palestrante
    INSERT INTO UTILIZADORES (ID_UTILIZADOR, NOME, EMAIL, PASSWORD, DATA_NASCIMENTO, DATA_REGISTO) 
    VALUES (NEXTVAL('seq_utilizadores_id_utilizador'), 'Test User Cascade', 'cascade@example.com', MD5('password'), '1991-01-01', NOW());

    -- Obter o ID do utilizador criado
    SELECT MAX(ID_UTILIZADOR) INTO v_id_utilizador FROM UTILIZADORES;

    -- Criar um palestrante
    CALL public.insert_palestrante(v_id_utilizador, 100.00);

    -- Excluir o utilizador (deve disparar a trigger de exclusão em cascata)
    DELETE FROM UTILIZADORES WHERE ID_UTILIZADOR = v_id_utilizador;

    -- Verificar se o utilizador foi excluído e se os dados relacionados foram removidos
    RAISE NOTICE 'Utilizador excluído com ID %', v_id_utilizador;
END $$;

-- Teste: Exclusão de Evento com Cascata
DO $$ 
DECLARE
    v_id_evento INTEGER;
BEGIN
    -- Criar um evento para testar exclusão em cascata
    INSERT INTO EVENTOS (ID_EVENTO, ID_EMPRESA, ID_UTILIZADOR, NOME, DATA, LOCAL, TELEFONE, DESCRICAO, PRECOINSCRICAO, PRECOTOTALEVENTO, DATA_CRIACAO)
    VALUES (NEXTVAL('seq_eventos_id_evento'), 5, 7, 'Evento Teste Exclusao', NOW() + INTERVAL '1 day', 'Lisboa', '987654321', 'Evento para teste de exclusão', 50.00, 500.00, NOW());

    -- Obter o ID do evento
    SELECT MAX(ID_EVENTO) INTO v_id_evento FROM EVENTOS;

    -- Excluir o evento (deve disparar a trigger de exclusão de evento com cascata)
    DELETE FROM EVENTOS WHERE ID_EVENTO = v_id_evento;

    -- Verificar se o evento foi excluído
    RAISE NOTICE 'Evento excluído com ID %', v_id_evento;
END $$;

-- Teste: Exclusão de Empresa com Cascata
DO $$ 
DECLARE
    v_id_empresa INTEGER;
BEGIN
    -- Criar empresa
    INSERT INTO EMPRESAS (ID_EMPRESA, NOME, EMAIL, PASSWORD, LOCAL, TELEFONE, DATA_REGISTO) 
    VALUES (NEXTVAL('seq_empresas_id_empresa'), 'Empresa Teste Cascata', 'empresa2@exemplo.com', MD5('password'), 'Porto', '123456789', NOW());

    -- Obter o ID da empresa
    SELECT MAX(ID_EMPRESA) INTO v_id_empresa FROM EMPRESAS;

    -- Excluir a empresa (deve disparar a trigger de exclusão de empresa com cascata)
    DELETE FROM EMPRESAS WHERE ID_EMPRESA = v_id_empresa;

    -- Verificar se a empresa foi excluída
    RAISE NOTICE 'Empresa excluída com ID %', v_id_empresa;
END $$;

-- Teste: Login
DO $$ 
DECLARE
    v_email VARCHAR := 'invalido@exemplo.com';
    v_senha VARCHAR := 'senhaerrada';
BEGIN
    RAISE NOTICE 'Resultado do Login: %', login(v_email, v_senha);
END $$;
