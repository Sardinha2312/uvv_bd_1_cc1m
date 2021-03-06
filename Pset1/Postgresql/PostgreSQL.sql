create user lucas superuser createdb createrole inherit login password '12345';

create database uvv
with
owner = "lucas"
template = template0
encoding = 'UTF8'
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE = 'pt_BR.UTF-8'
ALLOW_CONNECTIONS = true;

\c uvv lucas

create schema if not exists elmasri authorization lucas;

alter user lucas
set search_path to elmasri, "$user", public;

/* Geração da tabela funcionario */
CREATE TABLE elmasri.funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(35),
                sexo CHAR(1),
                salario NUMERIC(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT funcionario_pk PRIMARY KEY (cpf)
);

COMMENT ON TABLE elmasri.funcionario IS 'Tabela contendo informações gerais de cada funcionario';
COMMENT ON COLUMN elmasri.funcionario.cpf IS 'Coluna contendo o cpf do funcionário';
COMMENT ON COLUMN elmasri.funcionario.primeiro_nome IS 'Coluna contendo o primeiro nome do funcionário';
COMMENT ON COLUMN elmasri.funcionario.nome_meio IS 'Coluna contendo o nome do meio do funcionário';
COMMENT ON COLUMN elmasri.funcionario.ultimo_nome IS 'Coluna com o último nome do funcionario ';
COMMENT ON COLUMN elmasri.funcionario.data_nascimento IS 'Coluna com a data de nascimento do funcionário ';
COMMENT ON COLUMN elmasri.funcionario.endereco IS 'Coluna com o endereço do funcionário';
COMMENT ON COLUMN elmasri.funcionario.sexo IS 'Coluna incluindo o sexo do funcionário';
COMMENT ON COLUMN elmasri.funcionario.salario IS 'Coluna com o salário do funcionário';
COMMENT ON COLUMN elmasri.funcionario.cpf_supervisor IS 'Coluna com o cpf do supervisor ';
COMMENT ON COLUMN elmasri.funcionario.numero_departamento IS 'Coluna com o número do departamento';

/* Geração da tabela dependente */
CREATE TABLE elmasri.dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                CONSTRAINT dependente_pk PRIMARY KEY (cpf_funcionario, nome_dependente)
);

COMMENT ON TABLE elmasri.dependente IS 'Tabela contendo os dados do dependente';
COMMENT ON COLUMN elmasri.dependente.cpf_funcionario IS 'Coluna contendo o cpf do funcionário ';
COMMENT ON COLUMN elmasri.dependente.nome_dependente IS 'Coluna contendo o nome do dependente';
COMMENT ON COLUMN elmasri.dependente.sexo IS 'Coluna contendo o sexo do dependente';
COMMENT ON COLUMN elmasri.dependente.data_nascimento IS 'Coluna contendo a data de nascimento do dependente';
COMMENT ON COLUMN elmasri.dependente.parentesco IS 'Coluna contendo o parentesco do dependente';

/* Criação da tabela departamento */
CREATE TABLE elmasri.departamento (
                numero_departamento INTEGER NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT departamento_pk PRIMARY KEY (numero_departamento)
);

COMMENT ON TABLE elmasri.departamento IS 'Tabela contendo os dados do departamento ';
COMMENT ON COLUMN elmasri.departamento.numero_departamento IS 'Coluna contendo o número do departamento ';
COMMENT ON COLUMN elmasri.departamento.nome_departamento IS 'Coluna contendo o nome do departamento ';
COMMENT ON COLUMN elmasri.departamento.cpf_gerente IS 'Coluna contendo o cpf do gerente';
COMMENT ON COLUMN elmasri.departamento.data_inicio_gerente IS 'Coluna contendo a data de ínicio do gerente';

/* Criação do unique index no nome_departamento */ 
CREATE UNIQUE INDEX departamento_idx
 ON elmasri.departamento
 ( nome_departamento ASC );

/* Criação da tabela projeto */
CREATE TABLE elmasri.projeto (
                numero_projeto INTEGER NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT projeto_pk PRIMARY KEY (numero_projeto)
);

COMMENT ON TABLE elmasri.projeto IS 'Tabela contendo os dados do projeto ';
COMMENT ON COLUMN elmasri.projeto.numero_projeto IS 'Coluna contendo o número do projeto  ';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Coluna contendo o nome do projeto ';
COMMENT ON COLUMN elmasri.projeto.local_projeto IS 'Coluna contendo o local do projeto';
COMMENT ON COLUMN elmasri.projeto.numero_departamento IS 'Coluna contendo o número do departamento';

/* Criação do unique index no nome_projeto */
CREATE UNIQUE INDEX projeto_idx
 ON elmasri.projeto
 ( nome_projeto ASC );

/* Criação da tabela trabalha_em */
CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1) NOT NULL,
                CONSTRAINT trabalha_em_pk PRIMARY KEY (cpf_funcionario, numero_projeto)
);

COMMENT ON TABLE elmasri.trabalha_em IS 'Tabela contendo os dados de trabalha em';
COMMENT ON COLUMN elmasri.trabalha_em.cpf_funcionario IS 'Coluna contendo o cpf do funcionário ';
COMMENT ON COLUMN elmasri.trabalha_em.numero_projeto IS 'Coluna contendo o número do projeto';
COMMENT ON COLUMN elmasri.trabalha_em.horas IS 'Coluna contendo o número de horas';

/* Geração da tabela localizacoes_departamento */
CREATE TABLE elmasri.localizacoes_departamento (
                numero_departamento INTEGER NOT NULL,
                local VARCHAR(15) NOT NULL,
                CONSTRAINT localizacoes_departamento_pk PRIMARY KEY (numero_departamento, local)
);

COMMENT ON TABLE elmasri.localizacoes_departamento IS 'Tabela contendo as localizações do departamento ';
COMMENT ON COLUMN elmasri.localizacoes_departamento.numero_departamento IS 'Coluna contendo o número do departamento';
COMMENT ON COLUMN elmasri.localizacoes_departamento.local IS 'Coluna contendo o local do departamento  ';

/* A fk cpf_supervisor está referenciando a pk cpf dentro da tabela funcionario */
ALTER TABLE elmasri.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* A foreign key cpf_gerente da tabela departamento está referenciando a primary key cpf da tabela funcionario */
ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* A fk cpf_funcionario da tabela trabalha_em está referenciando a primary key cpf da tabela funcionario */
ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* A fk cpf_funcionario da tabela dependente está referenciando a pk cpf da tabela funcionario */
ALTER TABLE elmasri.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* A fk numero_departamento da tabela localizacoes_departamento está referenciando a pk numero_departamento da tabela departamento */
ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* O numero_departamento que é uma fk da tabela projeto está referenciando a pk numero_departamento da tabela departamento */
ALTER TABLE elmasri.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* A fk numero_projeto da tabela trabalha_em está referenciando a pk numero_projeto da tabela projeto */
ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Inclusão de valores dentro da tabela funcionario */
INSERT INTO elmasri.funcionario (
primeiro_nome, nome_meio, ultimo_nome, cpf, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento
)
values 
('Jorge', 'E', 'Brito','88866555576', '1937-11-10', 'Rua do Horto,35,São Paulo,SP', 'M', '55.000', '88866555576', '1'),
('Fernando', 'T', 'Wong', '33344555587', '1955-08-12', 'Rua da Lapa,34,São Paulo,SP', 'M', '40.000', '88866555576', '5'),
('João', 'B', 'Silva', '12345678966', '1968-12-08', 'Rua das Flores,751,São Paulo', 'M', '30.000', '33344555587', '5'),
('Jennifer', 'S', 'Souza', '98765432168', '1941-06-20', 'Av.Arthur de Lima,54,Santo André,SP', 'F', '43.000', '88866555576', '4'),
('Alice', 'J', 'Zelaya', '99988777767', '1968-01-19', 'Rua Souza Lima,35,Curitiba,PR', 'F', '25.000', '98765432168', '4'),
('Ronaldo', 'K', 'Lima', '66688444476', '1962-09-15', 'Rua Rebouças,65,Piracicaba,SP', 'M', '38.000', '33344555587', '5'),
('Joice','A','Leite','45345345376','1972-07-31', 'Av.Lucas Obes,74,São Paulo, SP', 'F', '25.000','33344555587', '5'),
('André', 'V', 'Pereira', '98798798733', '1969-03-29', 'Rua Timbiera, 35, São Paulo,SP', 'M', '25.000', '98765432168', '4');

/* Inclusão de valores dentro da tabela departamento */
INSERT INTO elmasri.departamento (
nome_departamento, numero_departamento, cpf_gerente, data_inicio_gerente
)
VALUES
('Pesquisa', '5', '33344555587', '1988-05-22'),
('Administração', '4', '98765432168', '1995-01-01'),
('Matriz', '1', '88866555576', '1981-06-19');

/* Inclusão de valores dentro da tabela localizacoes_departamento */
INSERT INTO elmasri.localizacoes_departamento (
numero_departamento, local
)
VALUES 
('1', 'São Paulo'),
('4', 'Mauá'),
('5', 'Santo André'),
('5', 'Itu'),
('5', 'São Paulo');

/* Inclusão de valores dentro da tabela projeto */
INSERT INTO elmasri.projeto (
nome_projeto, numero_projeto, local_projeto, numero_departamento
)
VALUES 
('ProdutoX', '1', 'Santo André', '5'),
('ProdutoY', '2', 'Itu', '5'),
('ProdutoZ', '3', 'São Paulo', '5'),
('Informatização', '10', 'Mauá', '4'),
('Reorganização', '20', 'São Paulo', '1'),
('Novosbenefícios', '30', 'Mauá', '4');

/* Inclusão de valores dentro da tabela dependente */
INSERT INTO elmasri.dependente (
cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco
)
VALUES 
('33344555587', 'Alicia', 'F', '1986-04-05', 'Filha'),
('33344555587', 'Thiago', 'M', '1983-10-25', 'Filho'),
('33344555587', 'Janaína', 'F', '1958-05-03', 'Esposa'),
('98765432168', 'Antonio', 'M', '1942-02-28', 'Marido'),
('12345678966', 'Michael', 'M', '1988-01-04', 'Filho'),
('12345678966', 'Alicia', 'F', '1988-12-30', 'Filha'),
('12345678966', 'Elizabeth', 'F', '1967-05-05', 'Esposa');

/* Inclusão de valores dentro da tabela trabalha_em */
INSERT INTO elmasri.trabalha_em ( 
cpf_funcionario, numero_projeto, horas
)
VALUES 
('12345678966', 1, '32.5'),
('12345678966', 2, '7.5'),
('66688444476', 3, '40.0'),
('45345345376', 1, '20.0'),
('45345345376', 2, '20.0'),
('33344555587', 2, '10.0'),
('33344555587', 3, '10.0'),
('33344555587', 10, '10.0'),
('33344555587', 20, '10.0'),
('99988777767', 30, '30.0'),
('99988777767', 10, '10.0'),
('98798798733', 10, '35.0'),
('98798798733', 30, '5.0'),
('98765432168', 30, '20.0'),
('98765432168', 20, '15.0'),
('88866555576', 20, '0.0');