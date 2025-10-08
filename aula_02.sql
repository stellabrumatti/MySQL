CREATE DATABASE db_quitanda;

USE db_quitanda;

CREATE TABLE tb_produtos(
	id bigint AUTO_INCREMENT,
	nome varchar(255) NOT NULL,
    quantidade int,
    data_validade date,
    preco decimal NOT NULL,
    PRIMARY KEY (id)
);

-- Inserir Tabela


INSERT INTO tb_produtos(nome, quantidade, data_validade, preco)
VALUES("Abacate", 10, "2025-10-27", 15.90);

INSERT INTO tb_produtos(nome, quantidade, data_validade, preco)
VALUES("Laranja", 50, "2025-10-27", 12.50);

INSERT INTO tb_produtos(nome, quantidade, data_validade, preco)
VALUES("Morango", 70, "2025-10-11", 10.00);

SELECT * FROM tb_produtos;

-- Modificar a estrutura de um atributo
ALTER TABLE tb_produtos MODIFY preco decimal(6,2); 

UPDATE tb_produtos SET preco = 15.90 WHERE id = 1;

SET SQL_SAFE_UPDATES = 1;
