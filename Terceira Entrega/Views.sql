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
SELECT EV.Id_Evento, EV.Id_empresa, EV.Nome AS EventoNome, EM.Nome AS EmpresaNome, EV.Data, EV.Local, EV.PrecoInscricao
FROM Eventos EV
    JOIN Empresas EM
        ON EV.Id_Empresa = EM.Id_Empresa
ORDER BY EV.Id_Evento ASC; 


-- VIEW DETALHES EVENTOS
CREATE OR REPLACE VIEW view_eventos_detalhes AS
SELECT EV.*, U.Nome as NomeUtilizador
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


CREATE OR REPLACE VIEW public.view_eventos_inscritos
 AS
 SELECT ev.id_evento,
    ev.nome AS eventonome,
    em.nome AS empresanome,
    ev.data,
    ev.local,
    ev.precoinscricao,
    u.id_utilizador,
    i.id_inscricao

   FROM eventos ev
     JOIN empresas em ON ev.id_empresa = em.id_empresa
     JOIN inscricoes i ON i.id_evento = ev.id_evento
	 JOIN utilizadores u ON u.id_utilizador = i.id_utilizador
	 GROUP BY 
    ev.id_evento, ev.nome, em.nome, ev.data, ev.local, ev.precoinscricao, u.id_utilizador
  ORDER BY ev.id_evento;


CREATE OR REPLACE VIEW view_eventos_inscritos_palestrantes AS
SELECT EV.Id_Evento, EV.Nome AS EventoNome, EM.Nome AS EmpresaNome, EV.Data, EV.Local, EV.PrecoInscricao, P.id_utilizador
FROM Eventos EV
    JOIN Empresas EM
        ON EV.Id_Empresa = EM.Id_Empresa
    JOIN PALESTRANTES P
        ON P.id_utilizador = EV.id_utilizador
ORDER BY EV.Id_Evento ASC;

-- Alterar o proprietário das views para bd2admin

-- VIEW USERS
ALTER VIEW view_utilizadores OWNER TO bd2admin;

-- VIEW PALESTRANTES
ALTER VIEW view_palestrantes OWNER TO bd2admin;

-- VIEW EMPRESAS
ALTER VIEW view_empresas OWNER TO bd2admin;

-- VIEW EVENTOS
ALTER VIEW view_eventos OWNER TO bd2admin;

-- VIEW DETALHES EVENTOS
ALTER VIEW view_eventos_detalhes OWNER TO bd2admin;

-- VIEW PAGAMENTOS
ALTER VIEW view_pagamentos OWNER TO bd2admin;

-- VIEW DESPESAS
ALTER VIEW view_despesas OWNER TO bd2admin;

ALTER VIEW view_eventos_inscritos OWNER TO bd2admin;

ALTER VIEW view_eventos_inscritos_palestrantes OWNER TO bd2admin;