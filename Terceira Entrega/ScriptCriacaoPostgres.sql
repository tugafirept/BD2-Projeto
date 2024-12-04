/*==============================================================*/
/* DBMS name:      PostgreSQL 14.x                              */
/* Created on:     13/11/2024 11:55:59                          */
/*==============================================================*/


alter table ADMINISTRADORES
   drop constraint PK_ADMINISTRADORES;

drop table ADMINISTRADORES;

drop index AVALICAOES_EVENTOS_FK;

drop index DESPESAS_PALESTRANTES_FK;

drop index EVENTOS_DESPESAS_FK;

alter table DESPESAS
   drop constraint PK_DESPESAS;

drop table DESPESAS;

alter table EMPRESAS
   drop constraint PK_EMPRESAS;

drop table EMPRESAS;

drop index PALESTRANTES_EVENTOS_FK;

drop index EMPRESAS_EVENTOS_FK;

alter table EVENTOS
   drop constraint PK_EVENTOS;

drop table EVENTOS;

drop index UTILIZADORES_INSCRICOES_FK;

drop index INSCRICOES_EVENTOS_FK;

alter table INSCRICOES
   drop constraint PK_INSCRICOES;

drop table INSCRICOES;

drop index INSCRICOES_PAGAMENTOS_FK;

drop index EVENTOS_PAGAMENTOS_FK;

alter table PAGAMENTOS
   drop constraint PK_PAGAMENTOS;

drop table PAGAMENTOS;

alter table PALESTRANTES
   drop constraint PK_PALESTRANTES;

drop table PALESTRANTES;

alter table UTILIZADORES
   drop constraint PK_UTILIZADORES;

drop table UTILIZADORES;

/*==============================================================*/
/* Table: UTILIZADORES                                          */
/*==============================================================*/
create table UTILIZADORES (
   ID_UTILIZADOR        integer              not null,
   NOME                 varchar(100),
   EMAIL                varchar(150)         not null,
   PASSWORD             varchar(100)         not null,
   DATA_NASCIMENTO      timestamp,
   DATA_REGISTO         timestamp
);

alter table UTILIZADORES
   add constraint PK_UTILIZADORES primary key (ID_UTILIZADOR);

/*==============================================================*/
/* Table: PALESTRANTES                                          */
/*==============================================================*/
create table PALESTRANTES (
   ID_UTILIZADOR        integer              not null,
   DATAFICOUPALESTRANTE timestamp,
   CUSTOPALESTRANTE     decimal
);

alter table PALESTRANTES
   add constraint PK_PALESTRANTES primary key (ID_UTILIZADOR);


/*==============================================================*/
/* Table: ADMINISTRADORES                                       */
/*==============================================================*/
create table ADMINISTRADORES (
   ID_UTILIZADOR        integer              not null,
   DATAADMIN            timestamp
);

alter table ADMINISTRADORES
   add constraint PK_ADMINISTRADORES primary key (ID_UTILIZADOR);

/*==============================================================*/
/* Table: EMPRESAS                                              */
/*==============================================================*/
create table EMPRESAS (
   ID_EMPRESA           integer              not null,
   NOME                 varchar(100)         not null,
   EMAIL                varchar(150)         not null,
   PASSWORD             varchar(100)         not null,
   LOCAL                varchar(200),
   TELEFONE             varchar(25),
   DATA_REGISTO         timestamp
);

alter table EMPRESAS
   add constraint PK_EMPRESAS primary key (ID_EMPRESA);

/*==============================================================*/
/* Table: EVENTOS                                               */
/*==============================================================*/
create table EVENTOS (
   ID_EVENTO            integer              not null,
   ID_EMPRESA           integer,
   ID_UTILIZADOR        integer,
   NOME                 varchar(100)         not null,
   DATA                 timestamp            not null,
   LOCAL                varchar(200)         not null,
   TELEFONE             varchar(25),
   DESCRICAO            varchar(300),
   PRECOINSCRICAO       decimal              not null,
   PRECOTOTALEVENTO     decimal,
   DATA_CRIACAO         timestamp
);

alter table EVENTOS
   add constraint PK_EVENTOS primary key (ID_EVENTO);

/*==============================================================*/
/* Table: DESPESAS                                              */
/*==============================================================*/
create table DESPESAS (
   ID_DESPESA           integer              not null,
   ID_EVENTO            integer,
   ID_UTILIZADOR        integer,
   TOTAL                decimal              not null,
   DATA                 timestamp
);

alter table DESPESAS
   add constraint PK_DESPESAS primary key (ID_DESPESA);

/*==============================================================*/
/* Index: EVENTOS_DESPESAS_FK                                   */
/*==============================================================*/
create  index EVENTOS_DESPESAS_FK on DESPESAS (
ID_EVENTO
);

/*==============================================================*/
/* Index: DESPESAS_PALESTRANTES_FK                              */
/*==============================================================*/
create  index DESPESAS_PALESTRANTES_FK on DESPESAS (
ID_UTILIZADOR
);


/*==============================================================*/
/* Index: EMPRESAS_EVENTOS_FK                                   */
/*==============================================================*/
create  index EMPRESAS_EVENTOS_FK on EVENTOS (
ID_EMPRESA
);

/*==============================================================*/
/* Index: PALESTRANTES_EVENTOS_FK                               */
/*==============================================================*/
create  index PALESTRANTES_EVENTOS_FK on EVENTOS (
ID_UTILIZADOR
);

/*==============================================================*/
/* Table: INSCRICOES                                            */
/*==============================================================*/
create table INSCRICOES (
   ID_INSCRICAO         integer              not null,
   ID_EVENTO            integer,
   ID_UTILIZADOR        integer,
   DATA_INSCRICAO       timestamp
);

alter table INSCRICOES
   add constraint PK_INSCRICOES primary key (ID_INSCRICAO);

/*==============================================================*/
/* Index: INSCRICOES_EVENTOS_FK                                 */
/*==============================================================*/
create  index INSCRICOES_EVENTOS_FK on INSCRICOES (
ID_EVENTO
);

/*==============================================================*/
/* Index: UTILIZADORES_INSCRICOES_FK                            */
/*==============================================================*/
create  index UTILIZADORES_INSCRICOES_FK on INSCRICOES (
ID_UTILIZADOR
);

/*==============================================================*/
/* Table: PAGAMENTOS                                            */
/*==============================================================*/
create table PAGAMENTOS (
   ID_PAGAMENTO         integer              not null,
   ID_INSCRICAO         integer,
   ID_EVENTO            integer,
   TOTAL                decimal              not null,
   DATA                 timestamp
);

alter table PAGAMENTOS
   add constraint PK_PAGAMENTOS primary key (ID_PAGAMENTO);

/*==============================================================*/
/* Index: EVENTOS_PAGAMENTOS_FK                                 */
/*==============================================================*/
create  index EVENTOS_PAGAMENTOS_FK on PAGAMENTOS (
ID_EVENTO
);

/*==============================================================*/
/* Index: INSCRICOES_PAGAMENTOS_FK                              */
/*==============================================================*/
create  index INSCRICOES_PAGAMENTOS_FK on PAGAMENTOS (
ID_INSCRICAO
);


/*==============================================================*/
/* CONSTRAINTS: FOREIGN_KEYS                                    */
/*==============================================================*/
-- PALESTRANTES
ALTER TABLE PALESTRANTES
ADD CONSTRAINT FK_PALESTRANTES_UTILIZADORES FOREIGN KEY (id_utilizador)
REFERENCES UTILIZADORES (id_utilizador);

-- ADMINISTRADORES
ALTER TABLE ADMINISTRADORES
ADD CONSTRAINT FK_ADMINISTRADORES_UTILIZADORES FOREIGN KEY (ID_UTILIZADOR)
REFERENCES UTILIZADORES (ID_UTILIZADOR);

-- EVENTOS
ALTER TABLE EVENTOS
ADD CONSTRAINT FK_EVENTOS_PALESTRANTES FOREIGN KEY (ID_UTILIZADOR)
REFERENCES PALESTRANTES (ID_UTILIZADOR);

ALTER TABLE EVENTOS
ADD CONSTRAINT FK_EVENTOS_EMPRESAS FOREIGN KEY (ID_EMPRESA)
REFERENCES EMPRESAS (ID_EMPRESA);

-- DESPESAS
ALTER TABLE DESPESAS
ADD CONSTRAINT FK_DESPESAS_PALESTRANTES FOREIGN KEY (ID_UTILIZADOR)
REFERENCES PALESTRANTES (ID_UTILIZADOR);

ALTER TABLE DESPESAS
ADD CONSTRAINT FK_DESPESAS_EVENTOS FOREIGN KEY (ID_EVENTO)
REFERENCES EVENTOS (ID_EVENTO);

-- INSCRICOES
ALTER TABLE INSCRICOES
ADD CONSTRAINT FK_INSCRICOES_UTILIZADORES FOREIGN KEY (ID_UTILIZADOR)
REFERENCES UTILIZADORES (ID_UTILIZADOR);

ALTER TABLE INSCRICOES
ADD CONSTRAINT FK_INSCRICOES_EVENTOS FOREIGN KEY (ID_EVENTO)
REFERENCES EVENTOS (ID_EVENTO);

-- PAGAMENTOS
ALTER TABLE PAGAMENTOS
ADD CONSTRAINT FK_PAGAMENTOS_EVENTOS FOREIGN KEY (ID_EVENTO)
REFERENCES EVENTOS (ID_EVENTO);

ALTER TABLE PAGAMENTOS
ADD CONSTRAINT FK_PAGAMENTOS_INSCRICOES FOREIGN KEY (ID_INSCRICAO)
REFERENCES INSCRICOES (ID_INSCRICAO);