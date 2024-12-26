-- Configurar ambiente de teste
-- Criar registos iniciais necessários para testar os procedimentos de insert

-- Criar um utilizador para usar nos testes de inscrição, palestrante, administrador, etc.
INSERT INTO UTILIZADORES (ID_UTILIZADOR, NOME, EMAIL, PASSWORD, DATA_NASCIMENTO, DATA_REGISTO) 
VALUES (NEXTVAL('seq_utilizadores_id_utilizador'), 'User Test', 'user@example.com', MD5('password'), '1990-01-01', NOW());

-- Criar uma empresa para associar aos eventos
INSERT INTO EMPRESAS (ID_EMPRESA, NOME, EMAIL, PASSWORD, LOCAL, TELEFONE, DATA_REGISTO)
VALUES (NEXTVAL('seq_empresas_id_empresa'), 'Empresa Teste', 'empresa@example.com', MD5('password'), 'Lisboa', '123456789', NOW());

DO $$ 
DECLARE
    v_id_empresa INTEGER;
    v_id_utilizador INTEGER;
    v_id_evento INTEGER;
    v_id_inscricao INTEGER;
    v_id_pagamento INTEGER;
    v_id_despesa INTEGER;
    v_id_empresa_nova INTEGER;
    v_id_utilizador_novo INTEGER;
BEGIN
    -- Obter IDs para usar nos testes
    SELECT MAX(ID_EMPRESA) INTO v_id_empresa FROM EMPRESAS;
    SELECT MAX(ID_UTILIZADOR) INTO v_id_utilizador FROM UTILIZADORES;
    
    -- Teste: Inserir Palestrante
    RAISE NOTICE 'ID do Utilizador para Palestrante: %', v_id_utilizador;
    CALL public.insert_palestrante(
        v_id_utilizador::INTEGER, 
        200.00::DECIMAL
    );

    -- Validar inserção do palestrante
    RAISE NOTICE 'Palestrante inserido com ID %', v_id_utilizador;

    -- Teste: Inserir Evento
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

    -- Validar inserção do evento
    SELECT MAX(ID_EVENTO) INTO v_id_evento FROM EVENTOS;
    RAISE NOTICE 'Evento inserido com ID %', v_id_evento;

    -- Teste: Inserir Inscrição
    CALL public.insert_inscricao(
        v_id_evento::INTEGER, 
        v_id_utilizador::INTEGER
    );

    -- Validar inserção da inscrição e obter ID gerado
    SELECT MAX(ID_INSCRICAO) INTO v_id_inscricao FROM INSCRICOES;
    RAISE NOTICE 'Inscrição inserida com ID %', v_id_inscricao;

    -- Teste: Inserir Pagamento
    CALL public.insert_pagamento(
        v_id_inscricao::INTEGER, 
        v_id_evento::INTEGER,
        50.00::DECIMAL, 
        NOW()::TIMESTAMP
    );

    -- Validar inserção do pagamento e obter ID gerado
    SELECT MAX(ID_PAGAMENTO) INTO v_id_pagamento FROM PAGAMENTOS;
    RAISE NOTICE 'Pagamento inserido com ID %', v_id_pagamento;

    -- Teste: Inserir Despesa
    CALL public.insert_despesa(
        v_id_evento::INTEGER, 
        v_id_utilizador::INTEGER, 
        100.00::DECIMAL, 
        NOW()::TIMESTAMP
    );

    -- Validar inserção da despesa e obter ID gerado
    SELECT MAX(ID_DESPESA) INTO v_id_despesa FROM DESPESAS;
    RAISE NOTICE 'Despesa inserida com ID %', v_id_despesa;

    -- Teste: Inserir Empresa
    CALL public.insert_empresa(
        'Nova Empresa Teste'::VARCHAR, 
        'novaempresa@example.com'::VARCHAR, 
        'password123'::VARCHAR, 
        'Porto'::VARCHAR, 
        '123456789'::VARCHAR
    );

    -- Validar inserção da empresa e obter ID gerado
    SELECT MAX(ID_EMPRESA) INTO v_id_empresa_nova FROM EMPRESAS;
    RAISE NOTICE 'Nova empresa inserida com ID %', v_id_empresa_nova;

    -- Teste: Inserir Utilizador
    CALL public.insert_utilizador(
        'Novo Utilizador Teste'::VARCHAR, 
        'novoutilizador@example.com'::VARCHAR, 
        'password123'::VARCHAR, 
        '2000-01-01'::TIMESTAMP
    );

    -- Validar inserção do utilizador e obter ID gerado
    SELECT MAX(ID_UTILIZADOR) INTO v_id_utilizador_novo FROM UTILIZADORES;
    RAISE NOTICE 'Novo utilizador inserido com ID %', v_id_utilizador_novo;

    -- Teste: Inserir Administrador
    CALL public.insert_administrador(
        v_id_utilizador::INTEGER, 
        NOW()::TIMESTAMP
    );

    -- Validar inserção do administrador (não retorna um ID, mas pode ser feito se necessário)
    RAISE NOTICE 'Administrador inserido para o utilizador com ID %', v_id_utilizador;
END $$;
