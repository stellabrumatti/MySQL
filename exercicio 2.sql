CREATE DATABASE ecommerce;

USE ecommerce;

CREATE TABLE tb_produtos (
id BIGINT AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    quantidade INT,
    datavalidade DATE,
    preco DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO tb_produtos (nome, quantidade, datavalidade, preco)
VALUES 
('Notebook Dell Inspiron 15', 20, '2030-12-31', 3500.00),
('Smartphone Samsung Galaxy S24', 35, '2030-12-31', 4200.00),
('Smart TV LG 55 Polegadas 4K', 10, '2030-12-31', 3800.00),
('Fone de Ouvido Bluetooth JBL', 100, '2030-12-31', 450.00),
('Console PlayStation 5', 15, '2030-12-31', 4900.00),
('Mouse Gamer Redragon Cobra', 80, '2030-12-31', 160.00),
('Teclado Mecânico Logitech', 50, '2030-12-31', 520.00),
('Monitor Dell 24 Polegadas', 25, '2030-12-31', 950.00);


SELECT *
FROM tb_produtos
WHERE preco > 500;


SELECT *
FROM tb_produtos
WHERE preco < 500;

UPDATE tb_produtos
SET preco = 200.00
WHERE nome = 'Mouse Gamer Redragon Cobra';

