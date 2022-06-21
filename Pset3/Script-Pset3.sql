with recursive classificacao_P AS (
select codigo, concat(nome) as nome, codigo_pai
from classificacao
where codigo_pai is null


UNION all


select class02.codigo, concat(pf.nome || ' --> ' || class02.nome), class02.codigo_pai
from classificacao AS class02
inner join classificacao_P as pf on pf.codigo = class02.codigo_pai
where class02.codigo_Pai is NOT null)
select codigo as "Código",nome as "Entidades",codigo_pai as "Código Pai"
from classificacao_P 
order by classificacao_P.nome;