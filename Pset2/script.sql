--Relatório da questão 01
select avg(funci.salario) as media_salario, depart.nome_departamento 
from funcionario funci 
inner join departamento depart 
on depart.numero_departamento = funci.numero_departamento 
group by depart.nome_departamento;

--Relatório da questão 02
select avg(funci.salario) as media_salario, funci.sexo
from funcionario funci
group by funci.sexo;

--Relatório da questão 03
select nome_departamento as departamento, concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome, data_nascimento as data_de_nascimento,
floor(DATEDIFF(CURDATE(),data_nascimento)/365.25) as idade, 
salario as salario 
from funcionario funci inner join departamento depart
where funci.numero_departamento = depart.numero_departamento order by nome_departamento;

--Relatório da questão 04
select concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome, 
floor(datediff(curdate(), data_nascimento)/365.25) as idade, 
salario as salario, cast((salario*1.2) as decimal(10,2)) as salario_reajuste from funcionario funci
where salario < '35000'
union
select concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome, 
floor(datediff(curdate(), data_nascimento)/365.25) as idade, 
salario as salario, cast((salario*1.15) as decimal(10,2)) as salario_reajuste from funcionario funci
where salario >= '35000';

--Relatório da questão 05
select nome_departamento as departamento, geren.primeiro_nome as gerente, funci.primeiro_nome as funcionario, salario as salarios
from departamento depart inner join funcionario funci, 
(select primeiro_nome, cpf from funcionario funci inner join departamento depart where funci.cpf = depart.cpf_gerente) as geren
where depart.numero_departamento = funci.numero_departamento and geren.cpf = depart.cpf_gerente order by depart.nome_departamento asc, funci.salario desc;

--Relatório da questão 06
select concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome, depart.nome_departamento as departamento,
depen.nome_dependente as dependente, floor(datediff(curdate(), depen.data_nascimento)/365.25) as idade_dependente,
case when depen.sexo = 'M' then 'masculino' when depen.sexo = 'm' then 'masculino'
when depen.sexo = 'F' then 'Feminino' when depen.sexo = 'funci' then 'feminino' end as sexo_dependente
from funcionario funci 
inner join departamento depart on funci.numero_departamento = depart.numero_departamento inner join dependente depen ON depen.cpf_funcionario = funci.cpf;

--Relatório da questão 07
select distinct concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome, depart.nome_departamento as departamento,
cast((funci.salario) as decimal(10,2)) as salario from funcionario funci
inner join departamento depart inner join dependente depen
where depart.numero_departamento = funci.numero_departamento and
funci.cpf not in (select depen.cpf_funcionario from dependente depen);

--Relatório da questão 08
select depart.nome_departamento as departamento, proj.nome_projeto as projeto,
concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome, tblh.horas as horas
from funcionario funci inner join departamento depart inner join projeto proj inner join trabalha_em tblh
where depart.numero_departamento = funci.numero_departamento and
proj.numero_projeto = tblh.numero_projeto and funci.cpf = tblh.cpf_funcionario order by proj.numero_projeto;

--Relatório da questão 09
select depart.nome_departamento as departamento, proj.nome_projeto as projeto, sum(tblh.horas) as total_horas
from departamento depart inner join projeto proj inner join trabalha_em tblh
where depart.numero_departamento = proj.numero_departamento AND proj.numero_projeto = tblh.numero_projeto group by proj.nome_projeto;

--Relatório da questão 10
select depart.nome_departamento as departamento, cast(avg(funci.salario) as decimal(10,2)) as media_salarial
from departamento depart inner join funcionario funci
where depart.numero_departamento = funci.numero_departamento group by depart.nome_departamento; 

--Relatório da questão 11
select concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome, proj.nome_projeto as projeto,
cast((funci.salario) as decimal(10,2)) as recebimento
from funcionario funci inner join projeto proj inner join trabalha_em tblh
where funci.cpf = tblh.cpf_funcionario and proj.numero_projeto = tblh.numero_projeto group by funci.primeiro_nome;

--Relatório da questão 12
select depart.nome_departamento as departamento, proj.nome_projeto as projeto,
concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome, tblh.horas as horas
from funcionario funci inner join departamento depart inner join projeto proj inner join trabalha_em tblh
where funci.cpf = tblh.cpf_funcionario and proj.numero_projeto = tblh.numero_projeto and (tblh.horas = 0 or tblh.horas = null) group by f.primeiro_nome;

--Relatório da questão 13
select concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome,
case when sexo = 'M' then 'masculino' when sexo = 'm' then 'masculino'
when sexo = 'f' then 'feminino' when sexo = 'f' then 'feminino' end as sexo,
floor(datediff(curdate(), funci.data_nascimento)/365.25) as idade
from funcionario funci

union

select depart.nome_dependente as nome,
case when sexo = 'M' then 'masculino' when sexo = 'm' then 'masculino'
when sexo = 'F' then 'Feminino' when sexo = 'f' then 'Feminino' end as sexo,
floor(datediff(curdate(), depart.data_nascimento)/365.25) as idade
from dependente depart order by idade;

--Relatório da questão 14
select depart.nome_departamento as departamento, count(funci.numero_departamento) as numero_funcionario
from funcionario funci inner join departamento depart
where funci.numero_departamento = depart.numero_departamento group by depart.nome_departamento;

--Relatório da questão 15
select distinct concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as nome,
depart.nome_departamento as departamento, 
proj.nome_projeto as projeto
from departamento depart inner join projeto proj inner join trabalha_em tblh inner join funcionario funci 
where depart.numero_departamento = funci.numero_departamento and proj.numero_projeto = tblh.numero_projeto and
tblh.cpf_funcionario = funci.cpf
union
select distinct concat(funci.primeiro_nome, ' ', funci.nome_meio, ' ', funci.ultimo_nome) as Nome,
depart.nome_departamento as departamento, 
'sem projeto' as projeto
from departamento depart inner join projeto proj inner join trabalha_em tblh inner join funcionario funci 
where depart.numero_departamento = funci.numero_departamento and proj.numero_projeto = tblh.numero_projeto and
(funci.cpf not in (select tblh.cpf_funcionario from trabalha_em tblh)); 