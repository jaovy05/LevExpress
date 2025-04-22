create database lev_express 

create table if not exists entregador(id serial primary key, cnh char(9) not null, nome varchar(255) not null);