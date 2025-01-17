-- Sequência para UTILIZADORES
CREATE SEQUENCE seq_utilizadores_id_utilizador START WITH 1 INCREMENT BY 1;
ALTER TABLE UTILIZADORES ALTER COLUMN ID_UTILIZADOR SET DEFAULT NEXTVAL('seq_utilizadores_id_utilizador');

-- Sequência para EMPRESAS
CREATE SEQUENCE seq_empresas_id_empresa START WITH 1 INCREMENT BY 1;
ALTER TABLE EMPRESAS ALTER COLUMN ID_EMPRESA SET DEFAULT NEXTVAL('seq_empresas_id_empresa');

-- Sequência para EVENTOS
CREATE SEQUENCE seq_eventos_id_evento START WITH 1 INCREMENT BY 1;
ALTER TABLE EVENTOS ALTER COLUMN ID_EVENTO SET DEFAULT NEXTVAL('seq_eventos_id_evento');

-- Sequência para DESPESAS
CREATE SEQUENCE seq_despesas_id_despesa START WITH 1 INCREMENT BY 1;
ALTER TABLE DESPESAS ALTER COLUMN ID_DESPESA SET DEFAULT NEXTVAL('seq_despesas_id_despesa');

-- Sequência para INSCRICOES
CREATE SEQUENCE seq_inscricoes_id_inscricao START WITH 1 INCREMENT BY 1;
ALTER TABLE INSCRICOES ALTER COLUMN ID_INSCRICAO SET DEFAULT NEXTVAL('seq_inscricoes_id_inscricao');

-- Sequência para PAGAMENTOS
CREATE SEQUENCE seq_pagamentos_id_pagamento START WITH 1 INCREMENT BY 1;
ALTER TABLE PAGAMENTOS ALTER COLUMN ID_PAGAMENTO SET DEFAULT NEXTVAL('seq_pagamentos_id_pagamento');



-- Alterar o proprietário das sequências para bd2admin

-- Sequência para UTILIZADORES
ALTER SEQUENCE seq_utilizadores_id_utilizador OWNER TO bd2admin;

-- Sequência para EMPRESAS
ALTER SEQUENCE seq_empresas_id_empresa OWNER TO bd2admin;

-- Sequência para EVENTOS
ALTER SEQUENCE seq_eventos_id_evento OWNER TO bd2admin;

-- Sequência para DESPESAS
ALTER SEQUENCE seq_despesas_id_despesa OWNER TO bd2admin;

-- Sequência para INSCRICOES
ALTER SEQUENCE seq_inscricoes_id_inscricao OWNER TO bd2admin;

-- Sequência para PAGAMENTOS
ALTER SEQUENCE seq_pagamentos_id_pagamento OWNER TO bd2admin;

