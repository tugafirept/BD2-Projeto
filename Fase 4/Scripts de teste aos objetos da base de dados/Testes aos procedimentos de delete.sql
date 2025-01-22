-- Configurar o ambiente de teste
-- Inserir dados para testar os procedimentos

-- Criar utilizadores
INSERT INTO UTILIZADORES (ID_UTILIZADOR, NOME, EMAIL, PASSWORD, DATA_NASCIMENTO, DATA_REGISTO) VALUES
(100, 'Teste User', 'teste.user@example.com', 'password', '1990-01-01', CURRENT_TIMESTAMP);

-- Criar palestrantes
INSERT INTO PALESTRANTES (ID_UTILIZADOR, DATAFICOUPALESTRANTE, CUSTOPALESTRANTE) VALUES
(100, CURRENT_TIMESTAMP, 150.00);

-- Criar empresas
INSERT INTO EMPRESAS (ID_EMPRESA, NOME, EMAIL, PASSWORD, LOCAL, TELEFONE, DATA_REGISTO) VALUES
(200, 'Teste Empresa', 'empresa@example.com', 'password', 'Lisboa', '123456789', CURRENT_TIMESTAMP);

-- Criar eventos
INSERT INTO EVENTOS (ID_EVENTO, ID_EMPRESA, ID_UTILIZADOR, NOME, DATA, LOCAL, TELEFONE, DESCRICAO, PRECOINSCRICAO, PRECOTOTALEVENTO, DATA_CRIACAO) VALUES
(300, 200, 100, 'Teste Evento', CURRENT_TIMESTAMP, 'Lisboa', '123456789', 'Descrição teste', 100.00, 1000.00, CURRENT_TIMESTAMP);

-- Criar inscrições
INSERT INTO INSCRICOES (ID_INSCRICAO, ID_EVENTO, ID_UTILIZADOR, DATA_INSCRICAO) VALUES
(400, 300, 100, CURRENT_TIMESTAMP);

-- Validar os procedimentos

-- Teste: Remover uma inscrição
CALL proc_delete_inscricao(400);
-- Verificar se a inscrição foi excluída
SELECT * FROM INSCRICOES WHERE ID_INSCRICAO = 400;

-- Teste: Remover um evento
CALL proc_delete_evento(300);
-- Verificar se o evento foi excluído
SELECT * FROM EVENTOS WHERE ID_EVENTO = 300;

-- Teste: Remover uma empresa
CALL proc_delete_empresa(200);
-- Verificar se a empresa foi excluída
SELECT * FROM EMPRESAS WHERE ID_EMPRESA = 200;

-- Teste: Remover um palestrante
CALL proc_delete_palestrante(100);
-- Verificar se o palestrante foi excluído
SELECT * FROM PALESTRANTES WHERE ID_UTILIZADOR = 100;

-- Teste: Remover um utilizador
CALL proc_delete_utilizador(100);
-- Verificar se o utilizador foi excluído
SELECT * FROM UTILIZADORES WHERE ID_UTILIZADOR = 100;
