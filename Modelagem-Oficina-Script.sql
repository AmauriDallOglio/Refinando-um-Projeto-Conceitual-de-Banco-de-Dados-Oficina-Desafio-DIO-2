/*
Descrição do Desafio
Para este cenário você irá utilizar seu esquema conceitual, criado no desafio do módulo de modelagem de BD com modelo ER, para criar o esquema lógico para o contexto de uma oficina. Neste desafio, você definirá todas as etapas. Desde o esquema até a implementação do banco de dados. Sendo assim, neste projeto você será o protagonista. Tenha os mesmos cuidados, apontados no desafio anterior, ao modelar o esquema utilizando o modelo relacional.

Após a criação do esquema lógico, realize a criação do Script SQL para criação do esquema do banco de dados. Posteriormente, realize a persistência de dados para realização de testes. Especifique ainda queries mais complexas do que apresentadas durante a explicação do desafio. Sendo assim, crie queries SQL com as cláusulas abaixo:

Recuperações simples com SELECT Statement;
Filtros com WHERE Statement;
Crie expressões para gerar atributos derivados;
Defina ordenações dos dados com ORDER BY;
Condições de filtros aos grupos – HAVING Statement;
Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados;
Diretrizes
Não há um mínimo de queries a serem realizadas;
Os tópicos supracitados devem estar presentes nas queries;
Elabore perguntas que podem ser respondidas pelas consultas
As cláusulas podem estar presentes em mais de uma query
O projeto deverá ser adicionado a um repositório do Github para futura avaliação do desafio de projeto. Adicione ao Readme a descrição do projeto lógico para fornecer o contexto sobre seu esquema lógico apresentado.

*/



-- Criação da database
-- create database oficina;
use oficina;

show tables;

-- -------------------------------------------------
-- Criando tabela cliente
-- -------------------------------------------------
create table Cliente(
	Id int auto_increment primary key,
    Nome varchar(45) not null,
    CPF char(11) not null,
    Email char(45),
    Telefone varchar(11),
    constraint unique_cpf_cliente unique (CPF)
);
alter table Cliente auto_increment=1;

insert into Cliente (Nome, CPF, Email, Telefone) 
values ('Amauri 1','00011122201','email1@gmail.com', '47999331111'),
	   ('Amauri 2','00011122202','email2@gmail.com', '47999331112'),
	   ('Amauri 3','00011122203','email3@gmail.com', '47999331113');
 
-- desc Cliente
-- select * from Cliente

-- -------------------------------------------------
-- Criando tabela veiculo
-- -------------------------------------------------
create table Veiculo(
	Id int auto_increment primary key,
	IdCliente int, 
	Placa char(12) not null,
	Marca char(45),
	Modelo char(45),
	Ano smallint(4),
	Cor char(45),
    constraint unique_placa_Veiculo unique (Placa),
    constraint fk_Veiculo_Cliente foreign key (IdCliente) references Cliente(Id)
);
alter table Veiculo auto_increment=1;

-- desc Veiculo
-- select * from Veiculo

insert into Veiculo (IdCliente, Placa, Marca, Modelo, Ano, Cor) 
values (1, 'aaa1111','Marca 1','Modelo 1', '2001', 'Cor 1'),
	   (2, 'bbb2222','Marca 2','Modelo 2', '2002', 'Cor 2'),
	   (3, 'ccc3333','Marca 3','Modelo 3', '2003', 'Cor 3');
 

-- -------------------------------------------------
-- Criando tabela equipe
-- -------------------------------------------------
create table Equipe(
	Id int auto_increment primary key,
	Nome char(45) not null
);
alter table Equipe auto_increment=1;

-- desc Equipe
-- select * from Equipe

insert into Equipe (Nome) 
values ('Equipe 1'),
	   ('Equipe 2'),
	   ('Equipe 3');

-- -------------------------------------------------
-- Criando tabela OrdemDeServico
-- -------------------------------------------------
-- drop table OrdemDeServico
create table OrdemDeServico(
	Id int auto_increment primary key,
    IdVeiculo int,
    IdEquipe int,
    DataAbertura datetime,
    DataEntrega datetime,
    Valor float,
	Situacao enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    constraint fk_OrdemDeServico_Veiculo foreign key (IdVeiculo) references Veiculo(Id),
    constraint fk_OrdemDeServico_Equipe foreign key (IdEquipe) references Equipe(Id)
);
alter table OrdemDeServico auto_increment=1;

-- desc OrdemDeServico
-- select * from OrdemDeServico

insert into OrdemDeServico (IdVeiculo, IdEquipe, DataAbertura, DataEntrega, Valor, Situacao) 
values (1, 1, '20230603', '20230603', 100.00, 'Em processamento' ),
	   (2, 2, '20230603', '20230604', 200.00, 'Em processamento' ),
	   (3, 3, '20230603', '20230605', 300.00, 'Em processamento' );


-- -------------------------------------------------
-- Criando tabela Mecanico
-- -------------------------------------------------
create table Mecanico(
	Id int auto_increment primary key,
	Codigo varchar(45) not null,
	Nome varchar(45) not null,
    Especialidade varchar(45) not null,
    constraint unique_Codigo_Mecanico unique (Codigo)
);
alter table Mecanico auto_increment=1;

-- desc Mecanico
-- select * from Mecanico

insert into Mecanico (Codigo, Nome, Especialidade) 
values ('Codigo 1', 'Mecanico 1', 'Especialidade 1' ),
	   ('Codigo 2', 'Mecanico 2', 'Especialidade 2' ),
	   ('Codigo 3', 'Mecanico 23', 'Especialidade 3' );


-- -------------------------------------------------
-- Criando tabela EquipePossuiMecanico N*M
-- -------------------------------------------------
create table EquipePossuiMecanico(
	Id int auto_increment primary key,
    IdEquipe int,
    IdMecanico int,
	Situacao enum('Ativo', 'Inativo') default 'Ativo',
    constraint fk_EquipePossuiMecanico_Mecanico foreign key (IdMecanico) references Mecanico(Id),
    constraint fk_EquipePossuiMecanico_Equipe foreign key (IdEquipe) references Equipe(Id)
);
alter table EquipePossuiMecanico auto_increment=1;

-- desc EquipePossuiMecanico
-- select * from EquipePossuiMecanico

insert into EquipePossuiMecanico (IdEquipe, IdMecanico, Situacao) 
values (1, 1, 'Ativo' ),
	   (1, 2, 'Inativo' ),
	   (1, 3, 'Inativo' );

insert into EquipePossuiMecanico (IdEquipe, IdMecanico, Situacao) 
values (2, 2, 'Ativo' ),
	   (2, 1, 'Inativo' ),
	   (2, 3, 'Inativo' );
       
insert into EquipePossuiMecanico (IdEquipe, IdMecanico, Situacao) 
values (3, 1, 'Ativo' ),
	   (3, 2, 'Ativo' ),
	   (3, 3, 'Ativo' );
 

-- -------------------------------------------------
-- Criando tabela Peca 
-- -------------------------------------------------
-- drop table Peca
 create table Peca(
	Id int auto_increment primary key,
    Descricao varchar(45) not null,
    Valor float not null,
	Situacao enum('Ativo', 'Inativo') default 'Ativo'
);
alter table Peca auto_increment=1;

-- desc Peca
-- select * from Peca

insert into Peca (Descricao, Valor, Situacao) 
values ('Peça 1', 1.99, 'Ativo' ),
	   ('Peça 2', 2.99, 'Ativo' ),
	   ('Peça 3', 3.99, 'Ativo' ),
       ('Peça 4', 4.99, 'Inativo' ),   
	   ('Peça 5', 5.99, 'Inativo' ),
	   ('Peça 6', 6.99, 'Inativo' );
       

-- -------------------------------------------------
-- Criando tabela OrdemServicoPossuiPeca N:M 
-- ----------------------------------------------
create table OrdemServicoPossuiPeca(
	Id int auto_increment primary key,
    IdOrdemServico int,
    IdPeca int,
	Situacao enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    constraint fk_OrdemServicoPossuiPecaOrdemServico foreign key (IdOrdemServico) references OrdemDeServico(Id),
    constraint fk_OrdemServicoPossuiPecaPeca foreign key (IdPeca) references Peca(Id)
);
alter table OrdemServicoPossuiPeca auto_increment=1;

-- desc OrdemServicoPossuiPeca
-- select * from OrdemServicoPossuiPeca
-- select * from Peca
-- select * from OrdemDeServico

insert into OrdemServicoPossuiPeca (IdOrdemServico, IdPeca, Situacao) 
values (1, 1, 'Confirmado' ),
	   (1, 2, 'Confirmado' ),
	   (1, 3, 'Confirmado' ),
	   (2, 2, 'Confirmado' ),
	   (3, 3, 'Confirmado' );


-- -------------------------------------------------
-- Criando tabela MaoDeObra 
-- -------------------------------------------------
-- drop table MaoDeObra
 create table MaoDeObra(
	Id int auto_increment primary key,
    Descricao varchar(45) not null,
    Valor float not null,
	Situacao enum('Ativo', 'Inativo') default 'Ativo'
);
alter table MaoDeObra auto_increment=1;

-- desc MaoDeObra
-- select * from MaoDeObra

insert into MaoDeObra (Descricao, Valor, Situacao) 
values ('Mão de obra 1', 100.99, 'Ativo' ),
	   ('Mão de obra 2', 200.99, 'Ativo' ),
	   ('Mão de obra 3', 300.99, 'Ativo' ),
       ('Mão de obra 4', 400.99, 'Inativo' ),   
	   ('Mão de obra 5', 500.99, 'Inativo' ),
	   ('Mão de obra 6', 600.99, 'Inativo' );
       
-- -------------------------------------------------
-- Criando tabela TipoDeServico 
-- -------------------------------------------------
-- drop table TipoDeServico
 create table TipoDeServico(
	Id int auto_increment primary key,
    IdMaoDeObra int,
    Descricao varchar(45) not null,
	Situacao enum('Ativo', 'Inativo') default 'Ativo',
    constraint fk_TipoDeServico_MaoDeObra foreign key (IdMaoDeObra) references MaoDeObra(Id)
);
alter table TipoDeServico auto_increment=1;

-- desc TipoDeServico
-- select * from TipoDeServico

insert into TipoDeServico (IdMaoDeObra, Descricao, Situacao) 
values (1, 'TipoDeServico 1', 'Ativo' ),
	   (2, 'TipoDeServico 2', 'Ativo' ),
	   (3, 'TipoDeServico 3', 'Ativo' ),
       (4, 'TipoDeServico 4', 'Inativo' ),   
	   (5, 'TipoDeServico 5', 'Inativo' ),
	   (6, 'TipoDeServico 6', 'Inativo' );
       

-- -------------------------------------------------
-- Criando tabela OrdemServicoPossuiTipoServico 
-- -------------------------------------------------
create table OrdemServicoPossuiTipoServico(
	Id int auto_increment primary key,
    IdOrdemServico int,
    IdTipoServico int,
	Situacao enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    constraint fk_OrdemServicoPossuiTipoServico_OrdermServico foreign key (IdOrdemServico) references OrdemDeServico(Id),
    constraint fk_OrdemServicoPossuiTipoServico_TipoServico foreign key (IdTipoServico) references Peca(Id)
);
alter table OrdemServicoPossuiTipoServico auto_increment=1;

-- desc OrdemServicoPossuiTipoServico
-- select * from OrdemServicoPossuiTipoServico
-- select * from TipoServico
-- select * from OrdemDeServico

insert into OrdemServicoPossuiTipoServico (IdOrdemServico, IdTipoServico, Situacao) 
values (1, 1, 'Confirmado' ),
	   (1, 2, 'Confirmado' ),
	   (1, 3, 'Confirmado' ),
	   (2, 2, 'Confirmado' ),
	   (3, 3, 'Confirmado' );


