CREATE DATABASE db_escola;

USE db_escola;

CREATE TABLE tb_estudantes (
    id BIGINT AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    idade INT,
    serie VARCHAR(50),
    turma VARCHAR(10),
    nota DECIMAL(4,2),
    PRIMARY KEY (id)
);


INSERT INTO tb_estudantes (nome, idade, serie, turma, nota)
VALUES
('Ana Souza', 14, '8º Ano', 'A', 8.50),
('Lucas Oliveira', 15, '9º Ano', 'B', 7.20),
('Mariana Silva', 13, '7º Ano', 'A', 9.10),
('Pedro Santos', 16, '1º Ano EM', 'C', 6.80),
('Beatriz Lima', 14, '8º Ano', 'B', 7.90),
('Rafael Mendes', 17, '2º Ano EM', 'A', 8.00),
('Camila Torres', 15, '9º Ano', 'C', 6.50),
('João Vitor', 18, '3º Ano EM', 'A', 9.30);


SELECT *
FROM tb_estudantes
WHERE nota > 7.0;

SELECT *
FROM tb_estudantes
WHERE nota < 7.0;

UPDATE tb_estudantes
SET nota = 7.50
WHERE nome = 'Camila Torres';

SELECT * 
FROM tb_estudantes
WHERE nome = 'Camila Torres';


SELECT * FROM tb_estudantes;

