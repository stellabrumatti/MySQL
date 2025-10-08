CREATE DATABASE db_rh ;

USE db_rh;

CREATE TABLE tb_colaboradores (
	id BIGINT AUTO_INCREMENT,
    nome VARCHAR (255) NOT NULL,
    idade INT,
    setor VARCHAR(255) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id)
    
    
);

DROP TABLE tb_colaboradores;

CREATE TABLE tb_colaboradores (
  id BIGINT AUTO_INCREMENT,
  nome VARCHAR(255) NOT NULL,
  idade INT,
  setor VARCHAR(255) NOT NULL,
  salario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO tb_colaboradores (nome, idade, setor, salario)
VALUES 
('Maria Silva', 29, 'Recursos Humanos', 4500.00),
('João Souza', 35, 'Financeiro', 5200.00),
('Ana Pereira', 26, 'Marketing', 4100.50),
('Carlos Mendes', 42, 'TI', 6800.00),
('Fernanda Lima', 31, 'Vendas', 4700.75);


SELECT *
FROM tb_colaboradores
WHERE salario > 2000;

SELECT *
FROM tb_colaboradores
WHERE salario < 2000;

SET SQL_SAFE_UPDATES = 0;

UPDATE tb_colaboradores
SET salario = salario * 1.10
WHERE salario < 3000;

-- Atualizando um registro específico da tabela
UPDATE tb_colaboradores
SET salario = 7000.00
WHERE nome = 'Carlos Mendes';

-- Verificando se a atualização foi feita corretamente
SELECT * 
FROM tb_colaboradores
WHERE nome = 'Carlos Mendes';
