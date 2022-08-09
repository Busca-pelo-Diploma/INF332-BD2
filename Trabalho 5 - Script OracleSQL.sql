------------------------- CRIAÇÃO DE TIPAGEM ---------------------------

create or replace type t_item_category as object (
    id number(38),
    nome varchar(30)
) not final;
/

create or replace type t_item_tipo as object (
    id number(38),
    nome varchar(30),
    categoria REF t_item_category

) not final;
/

create or replace type t_comunidade as object (
    id number,
    nome varchar(60),
    limite_usuarios number(38)

) not final;
/

create or replace type t_usuario as object (
    id number(38),
    cpf number(38),   
    nome varchar2(30),   
    dataNasc date,   
    idade number(38),   
    endereco varchar2(30),   
    email varchar2(30),   
    telefone number(38),
    sua_comunidade REF t_comunidade, 
    saldoPD float(2),   
    nota_media float(1) 
      
) not final;
/

create or replace type t_item as object (   
    id number(38), 
    nome varchar(60),  
    seu_tipo REF t_item_tipo,
    dono REF t_usuario, 
    tamanhoVol float(2),  
    pesoKg float(2),  
    marca varchar(30),  
    voltagem number(38),  
    valorPD float(2),  
    reservado number(1)
     
) not final;
/

create or replace type t_emprestimo as object (
    id number(38),
    quem_pegou REF t_usuario,  
    item_emprestado REF t_item,  
    prazo date,  
    dataEmprestimo date,
    dataQuePegou date,  
    dataDevolucao date,  
    estadoDevolvido varchar(30),  
    multa float(2),  
    notaDada float(1)  
      
) not final;
/

create type t_gerentePD under t_usuario(
    comunidade_gerenciada REF t_comunidade
) not final;
/

-------------------------- CRIAÇÃO DE TABELAS ------------------------

create table Categorias of t_item_category(constraint pk_categorias primary key (id));
/
create table Tipos of t_item_tipo(constraint pk_tipos primary key (id));
/
create table Itens of t_item(constraint pk_item primary key (id));
/
create table Usuarios of t_usuario(constraint pk_usuarios primary key (id));
/
create table Emprestimos of t_emprestimo(constraint pk_emprestimos primary key (id));
/
create table Comunidades of t_comunidade(constraint pk_comunidades primary key (id));
/
create table Gerentes of t_gerentePD(constraint pk_gerentes primary key (id));
/

------------------------------- VIEWS -------------------------------

create view ComunidadeV of t_comunidade with object id(id)
    as select id, nome, limite_usuarios from Comunidades;
/

create view UsuariosV of t_usuario with object id(id)
    as select id, cpf, nome, dataNasc, idade, endereco, email, telefone,   
    sua_comunidade, saldoPD, nota_media from Usuarios;
/

create view GerentesV of t_gerentePD under UsuariosV
    as select id, cpf, nome, dataNasc, idade, endereco, email, telefone,   
    sua_comunidade, saldoPD, nota_media, comunidade_gerenciada from Gerentes;
/

create view CategoriasV of t_item_category with object id(id)
    as select id, nome from Categorias;
/

------------------------------- INSERT -------------------------------

---- Categorias ----

insert into Categorias values (0, 'Ferramenta');
/
insert into Categorias values (1, 'Eletrodoméstico');
/
insert into Categorias values (2, 'Brinquedo');
/
insert into Categorias values (3, 'Móvel');
/
insert into Categorias values (4, 'Veículo');
/

---- Tipos ----

insert into Tipos values (0,'Maquita', (SELECT REF (t) FROM Categorias t WHERE t.id=0));
/
insert into Tipos values (1,'TV', (SELECT REF (t) FROM Categorias t WHERE t.id=1));
/
insert into Tipos values (2,'Cavalinho Inflável', (SELECT REF (t) FROM Categorias t WHERE t.id=2));
/
insert into Tipos values (3,'Beliche', (SELECT REF (t) FROM Categorias t WHERE t.id=3));
/
insert into Tipos values (4,'Cavalo', (SELECT REF (t) FROM Categorias t WHERE t.id=4));
/
insert into Tipos values (5,'Carro', (SELECT REF (t) FROM Categorias t WHERE t.id=4));
/
insert into Tipos values (6,'Mesa', (SELECT REF (t) FROM Categorias t WHERE t.id=3));
/

---- Comunidades ----

insert into Comunidades values (0, 'Kleuber s Neighborhood', 20 );
/
insert into Comunidades values (1, 'Odeio segunda-feira', 20 );
/
insert into Comunidades values (2, 'Cavaleiros do vale do Jequitinhonha', 20 );
/

---- Usuários ----

insert into Usuarios values (0, 13187930689,'Tiago Costa', '18NOV1997', 24, 'Alojamento PÓS 2111', 'tiago@ufv.br', 31996812157,
    (SELECT REF (t) FROM Comunidades t WHERE t.id=2), 50, 8.3);
/
insert into Usuarios values (1, 84732475691,'Levi Martins', '23MAR1990', 31, 'Perto do BondBoca 2000', 'levi@ufv.br', 31985726146,
    (SELECT REF (t) FROM Comunidades t WHERE t.id=1), 120, 9.1);
/
insert into Usuarios values (2, 26581029483,'Kleuber Neves', '01JUN1930', 92, 'Alojamento PÓS 1921', 'kleuber@ufv.br', 31995726354,
    (SELECT REF (t) FROM Comunidades t WHERE t.id=0), -20, 3.5);
/
insert into Usuarios values (4, 14727462194,'Jugurta', '25DEC1980', 42, 'Acamari', 'jugurta@ufv.br', 31982746104,
    (SELECT REF (t) FROM Comunidades t WHERE t.id=2), 1500, 7.2);
/

---- Itens ----

insert into Itens values (0,'Bosh 2000 Gurren-Lagann', (SELECT REF (t) FROM Tipos t WHERE t.id=0), (SELECT REF (t) FROM Usuarios t WHERE t.id=1),
    999999, 300, 'Bosh', '220', 40, 0);
/
insert into Itens values (1,'Manga-Larga Marchador do Jugurta', (SELECT REF (t) FROM Tipos t WHERE t.id=4), (SELECT REF (t) FROM Usuarios t WHERE t.id=4),
    200, 200, 'Manga-Larga Marchador', '0', 3000, 0);
/
insert into Itens values (2,'Cavalinho do Gugu', (SELECT REF (t) FROM Tipos t WHERE t.id=2), (SELECT REF (t) FROM Usuarios t WHERE t.id=0),
    50, 1, 'Estrela', '0', 65, 1);
/
insert into Itens values (3,'SmarTV Samsung Braba', (SELECT REF (t) FROM Tipos t WHERE t.id=1), (SELECT REF (t) FROM Usuarios t WHERE t.id=2),
    1000, 8, 'Samsung', '220', 4300, 1);
/
insert into Itens values (4,'SmartTV LG WebOS', (SELECT REF (t) FROM Tipos t WHERE t.id=1), (SELECT REF (t) FROM Usuarios t WHERE t.id=1),
    1000, 7, 'LG', '220', 4100, 1);
/
insert into Itens values (5,'Fusca', (SELECT REF (t) FROM Tipos t WHERE t.id=5), (SELECT REF (t) FROM Usuarios t WHERE t.id=4),
    3000, 1364, 'Wolks', '0', 4000, 0);
/
insert into Itens values (6,'Mesa de Jantar Suculenta', (SELECT REF (t) FROM Tipos t WHERE t.id=6), (SELECT REF (t) FROM Usuarios t WHERE t.id=0),
    999, 8, 'coiote', '0', 1250, 1);
/
insert into Itens values (8,'LG mr bombastic', (SELECT REF (t) FROM Tipos t WHERE t.id=1), (SELECT REF (t) FROM Usuarios t WHERE t.id=2),
    300, 10, 'LG', '220', 100, 0);
/
insert into Itens values (9,'Cavalo litle poney', (SELECT REF (t) FROM Tipos t WHERE t.id=4), (SELECT REF (t) FROM Usuarios t WHERE t.id=2),
    20, 5, 'poney', '0', 1000, 0);
/
insert into Itens values (10,'nome do burro do shrek', (SELECT REF (t) FROM Tipos t WHERE t.id=2), (SELECT REF (t) FROM Usuarios t WHERE t.id=2),
    25, 6, 'burro', '0', 1000, 0);
/
insert into Itens values (11,'ahundred thousand', (SELECT REF (t) FROM Tipos t WHERE t.id=3), (SELECT REF (t) FROM Usuarios t WHERE t.id=2),
    30, 8, 'coiote', '0', 1000, 0);
/

------- Empréstimos ---------
insert into Emprestimos values (0,(SELECT REF (t) FROM Usuarios t WHERE t.id=4),(SELECT REF (t) FROM itens t WHERE t.id=2), 
    '26DEC2020', '25DEC2020', '26DEC2020', '27DEC2020', 'Devolvido', 10, 5);
/
insert into Emprestimos values (1,(SELECT REF (t) FROM Usuarios t WHERE t.id=0),(SELECT REF (t) FROM itens t WHERE t.id=8), 
    '22JUL2022', '17JUL2022', '17JUL2022', '21JUL2022', 'Devolvido', 0, 10);
/
insert into Emprestimos values (2,(SELECT REF (t) FROM Usuarios t WHERE t.id=2),(SELECT REF (t) FROM itens t WHERE t.id=0), 
    '27JUL2022', '24JUL2022', '24JUL2022', '27JUL2022', 'Devolvido', 0, 9);
/
insert into Emprestimos values (3,(SELECT REF (t) FROM Usuarios t WHERE t.id=4),(SELECT REF (t) FROM itens t WHERE t.id=2), 
    '14APR2021', '12APR2021', '12APR2021', '15APR2021', 'Devolvido', 2, 7);
/
insert into Emprestimos values (4,(SELECT REF (t) FROM Usuarios t WHERE t.id=1),(SELECT REF (t) FROM itens t WHERE t.id=8), 
    '17JUN2022', '10JUN2022', '10JUN2022', '16JUN2022', 'Devolvido', 0, 10);
/
insert into Emprestimos values (5,(SELECT REF (t) FROM Usuarios t WHERE t.id=2),(SELECT REF (t) FROM itens t WHERE t.id=0), 
    '26DEC2020', '25DEC2020', '26DEC2020', '05JAN2021', 'Devolvido', 10, 3);
/

-------- Gerentes ----------
insert into Gerentes values (0, 12476843695,'Ivo de Almeida', '25DEC1992', 27, 'Ponte Nova', 'ivo_almeida@gmail.com', 31973168110,
    (SELECT REF (t) FROM Comunidades t WHERE t.id=2), 2500, 9.2, (SELECT REF (t) FROM Comunidades t WHERE t.id=2));
/    
insert into Gerentes values (1, 12345678900,'Givanildo Hulk', '25JUL1986', 36, 'Campina Grande, Paraíba', 'hulk_esmaga@gmail.com', 35973168110,
    (SELECT REF (t) FROM Comunidades t WHERE t.id=1), 1562500, 9.8, (SELECT REF (t) FROM Comunidades t WHERE t.id=1));
/
---- Query ----

-- Query1

SELECT 
    u.sua_comunidade.nome as Nome, 
    u.sua_comunidade.limite_usuarios as "LIMITE DE MEMBROS",
    u.nome, u.cpf, u.idade, u.endereco as Endereço, u.email, u.telefone
    FROM Usuarios u WHERE u.sua_comunidade.id = '2';
/

-- Query 2
SELECT
    e.prazo,
    e.dataQuePegou as "DATA DO EMPRÉSTIMO",
    e.dataDevolucao as "DATA DE DEVOLUÇÃO",
    e.estadoDevolvido as "ESTADO NA ENTREGA",
    e.multa,
    e.notaDada as "NOTA"
FROM Emprestimos e;
/

-- Query 4
SELECT c.nome, c.limite_usuarios as "LIMITE DE USUÁRIOS",
    (select g.nome from Gerentes g where g.comunidade_gerenciada.id = c.id) as Gerente,
    (select count(u.id) from Usuarios u inner join Comunidades gi on u.sua_comunidade.id = gi.id where gi.id = c.id) as "TOTAL DE MEMBROS",
    (select count(i.id) from Itens i inner join Usuarios u on i.dono.id = u.id where u.sua_comunidade.id = c.id) as "TOTAL DE ITEMS"
FROM Comunidades c
/
-- Query 6
SELECT
    g.cpf,
    g.nome,
    g.dataNasc as "DATA DE NASCIMENTO",
    g.idade,
    g.endereco,
    g.email,
    g.telefone,
    g.sua_comunidade.nome as "NOME DA COMUNIDADE",
    g.saldoPD as "SALDO",
    g.nota_media as "NOTA",
    g.comunidade_gerenciada.nome as "COMUNIDADE GERENCIADA",
    g.comunidade_gerenciada.limite_usuarios as "COMUNIDADE GERENCIADA - LIMITE DE USUÁRIOS"
FROM
    GerentesV g;
/