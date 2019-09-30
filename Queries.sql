-- create the tables and populate them with the processed csv files

CREATE TABLE public."sistema_operacional"(id integer, nome character varying(30));
COPY public."sistema_operacional" FROM 'C:\Users\thoma\OneDrive\Desktop\sistema_operacional.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public."pais"(id integer, nome character varying(50));
COPY public."pais" FROM 'C:\Users\thoma\OneDrive\Desktop\pais.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public."empresa"(id integer, tamanho character varying(50));
COPY public."empresa" FROM 'C:\Users\thoma\OneDrive\Desktop\empresa.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public."linguagem_programacao"(id integer, nome character varying(50));
COPY public."linguagem_programacao" FROM 'C:\Users\thoma\OneDrive\Desktop\linguagem_programacao.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public."resp_usa_linguagem"(respondent_id integer, linguagem_programacao_id integer);
COPY public."resp_usa_linguagem" FROM 'C:\Users\thoma\OneDrive\Desktop\resp_usa_linguagem.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public."resp_usa_ferramenta"(respondente_id integer, ferramenta_communic_id integer);
COPY public."resp_usa_ferramenta" FROM 'C:\Users\thoma\OneDrive\Desktop\resp_usa_ferramenta.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public."ferramenta_comunic"(id integer, nome character varying(75));
COPY public."ferramenta_comunic" FROM 'C:\Users\thoma\OneDrive\Desktop\ferramenta_comunic.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public."respondente"(id integer, nome character varying(30), contrib_open_source integer, programa_hobby integer, salario float, sistema_operacional_id integer, pais_id integer, empresa_id integer);
COPY public."respondente" FROM 'C:\Users\thoma\OneDrive\Desktop\respondente.csv' DELIMITER ',' CSV HEADER;




-- Question 1
-- Total is not = 10,000 because of the na values

select 
	p.nome as pais, 
	count(distinct r.id) as num_respondente
from respondente as r
left join pais as p
on r.pais_id = p.id
group by p.nome
order by num_respondente DESC;


-- Question 2

select 
	p.nome as pais,
	s_o.nome as sistema_operacional,
	count(r.id) as num_respondente
from respondente as r
left join pais as p
on r.pais_id = p.id
left join sistema_operacional as s_o
on r.sistema_operacional_id = s_o.id
where s_o.nome = 'Windows' and p.nome = 'United States'
group by s_o.nome, p.nome;


-- Question 3

select 
	p.nome as pais,
	s_o.nome as sistema_operacional,
	avg(r.salario) as avg_salario
from respondente as r
left join pais as p
on r.pais_id = p.id
left join sistema_operacional as s_o
on r.sistema_operacional_id = s_o.id
where s_o.nome = 'Linux-based' and p.nome = 'Israel'
group by s_o.nome, p.nome;


-- Question 4

with ferramente_nome as (
	select 
		r_u_f.respondente_id as respondente_id,
		f_c.nome as nome
	from resp_usa_ferramenta as r_u_f
	left join ferramenta_comunic as f_c
	on r_u_f.ferramenta_communic_id = f_c.id
	)

select 
	e.tamanho as empresa_tamanho,
	stddev_samp(r.salario) as std_salario,
	avg(r.salario) as avg_salario
from respondente as r
left join empresa as e
on r.empresa_id = e.id
left join ferramente_nome as f_n
on r.id = f_n.respondente_id
where f_n.nome = 'Slack'
group by e.tamanho, f_n.nome;


-- Question 5

-- select id of brazilian respondents for later filtering
with brasil_respondente as (
	select 
		r.id as r_id
	from respondente as r
	left join pais as p
	on r.pais_id = p.id
	where p.nome = 'Brazil'
	),
	
-- calculate the average salary for all brazilian respondents per os
	avg_all_per_os as (
	select 
		s_o.id as s_o_id,
		s_o.nome as s_o,
		avg(r.salario) as avg_salario_all
	from respondente as r
	left join sistema_operacional as s_o
	on r.sistema_operacional_id = s_o.id
	where r.id in (select r_id from brasil_respondente)
	group by s_o.id, s_o.nome
	),
	
-- calculate the average salary for all brazilian respondents per os
	avg_hobby_per_os as (
		select 
		s_o.id as s_o_id,
		s_o.nome as s_o,
		avg(r.salario) as avg_salario_hobby
	from respondente as r
	left join sistema_operacional as s_o
	on r.sistema_operacional_id = s_o.id
	where r.id in (select r_id from brasil_respondente) and r.programa_hobby = 1
	group by s_o.id, s_o.nome
	)

select 
	a_a_p_o.s_o as os,
	a_h_p_o.avg_salario_hobby, 
	a_a_p_o.avg_salario_all,
	ABS(a_a_p_o.avg_salario_all - a_h_p_o.avg_salario_hobby) as diff_media
from avg_all_per_os as a_a_p_o
left join avg_hobby_per_os as a_h_p_o
on a_a_p_o.s_o_id = a_h_p_o.s_o_id;


-- Question 6

select
	l_p.nome,
	count(distinct r_u_l.respondent_id) as num_users
from resp_usa_linguagem as r_u_l
left join linguagem_programacao as l_p
on r_u_l.linguagem_programacao_id = l_p.id
group by l_p.nome
order by num_users DESC
limit 3;


-- Question 7

select 
	p.nome as pais,
	round(avg(r.salario)) as avg_salario
from respondente as r
left join pais as p
on r.pais_id = p.id
group by p.nome
order by avg_salario DESC
limit 5;


-- Question 8

CREATE TABLE public."salary_comparison"(pais character varying(50), min_salary float);

INSERT INTO salary_comparison (pais, min_salary)
VALUES
   ('United States', 4787.90),
   ('India', 243.52),
   ('United Kingdom', 6925.63),
   ('Germany', 6664.00),
   ('Canada', 5567.68);

with comparison as (
	select 
		s_c.pais as pais,
		s_c.min_salary * 5 as base_comparison,
		p.id as id
	from salary_comparison as s_c
	left join pais as p
	on s_c.pais = p.nome
	)

select 
	c.pais,
	sum(case when r.salario > c.base_comparison then 1 else 0 END) as num_respondent
from respondente as r
left join comparison as c
on r.pais_id = c.id
group by c.pais
order by num_respondent DESC;



   
   
   
   
   