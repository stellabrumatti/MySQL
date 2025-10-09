

/* ==============================
   1) Criação do Banco de Dados
   ============================== */
CREATE DATABASE db_farmacia_bem_estar
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE db_farmacia_bem_estar;

/* ==============================
   2) Criação das Tabelas
   ============================== */

-- Tabela de categorias: pelo menos 2 atributos além da PK
CREATE TABLE tb_categorias (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(60) NOT NULL UNIQUE,
  tipo ENUM('MEDICAMENTO','COSMÉTICO','HIGIENE','SUPLEMENTO','INFANTIL') NOT NULL,
  descricao VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Tabela de produtos: 4 atributos além da PK + FK para tb_categorias
CREATE TABLE tb_produtos (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  fabricante VARCHAR(100) NOT NULL,
  preco DECIMAL(10,2) NOT NULL CHECK (preco >= 0),
  estoque INT UNSIGNED NOT NULL DEFAULT 0,
  validade DATE NULL,
  categoria_id BIGINT NOT NULL,
  CONSTRAINT fk_produtos_categorias
    FOREIGN KEY (categoria_id) REFERENCES tb_categorias(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  INDEX idx_produtos_nome (nome),
  INDEX idx_produtos_preco (preco),
  INDEX idx_produtos_categoria (categoria_id)
) ENGINE=InnoDB;

  
/* ==============================
   3) Inserts
   ============================== */

-- 5 registros em tb_categorias
INSERT INTO tb_categorias (nome, tipo, descricao) VALUES
  ('Medicamentos Tarja Vermelha', 'MEDICAMENTO', 'Medicamentos sob prescrição, sem retenção de receita.'),
  ('Medicamentos Isentos de Prescrição', 'MEDICAMENTO', 'Analgésicos, antigripais e afins.'),
  ('Cosméticos', 'COSMÉTICO', 'Produtos para cuidados com pele, cabelo e corpo.'),
  ('Higiene Pessoal', 'HIGIENE', 'Itens de higiene diária e cuidados pessoais.'),
  ('Suplementos', 'SUPLEMENTO', 'Vitaminas, minerais e produtos nutricionais.');

-- 8 registros em tb_produtos (com chave estrangeira categoria_id)
INSERT INTO tb_produtos (nome, fabricante, preco, estoque, validade, categoria_id) VALUES
  ('Paracetamol 750mg',      'GenPharma',  12.90, 150, '2027-03-01', (SELECT id FROM tb_categorias WHERE nome='Medicamentos Isentos de Prescrição')),
  ('Dipirona 500mg',         'SaúdeMais',  10.50, 200, '2026-11-15', (SELECT id FROM tb_categorias WHERE nome='Medicamentos Isentos de Prescrição')),
  ('Shampoo Anticaspa',      'DermaCare',  58.90,  45,  NULL,         (SELECT id FROM tb_categorias WHERE nome='Cosméticos')),
  ('Creme Hidratante Facial','Beleza+', 79.00,  30,  NULL,         (SELECT id FROM tb_categorias WHERE nome='Cosméticos')),
  ('Escova Dental Macia',    'Higiclean',  15.90, 120,  NULL,         (SELECT id FROM tb_categorias WHERE nome='Higiene Pessoal')),
  ('Vitamina C 1g',          'NutriLife',  64.50,  60, '2026-05-30', (SELECT id FROM tb_categorias WHERE nome='Suplementos')),
  ('Colágeno Hidrolisado',   'NutriLife',  89.90,  35, '2026-09-10', (SELECT id FROM tb_categorias WHERE nome='Suplementos')),
  ('Amoxicilina 500mg',      'BioMed',     52.00,  80, '2027-01-20', (SELECT id FROM tb_categorias WHERE nome='Medicamentos Tarja Vermelha'));

  
/* ==============================
   4) Consultas (SELECTs)
   ============================== */

-- a) Produtos com valor > R$ 50,00
SELECT id, nome, fabricante, preco
FROM tb_produtos
WHERE preco > 50.00;

-- b) Produtos com valor entre R$ 5,00 e R$ 60,00 (inclusive)
SELECT id, nome, fabricante, preco
FROM tb_produtos
WHERE preco BETWEEN 5.00 AND 60.00;

-- c) Produtos cujo nome contém a letra 'C' (maiúscula ou minúscula)
SELECT id, nome, fabricante, preco
FROM tb_produtos
WHERE UPPER(nome) LIKE '%C%';
-- Observação: Em collation case-insensitive, LIKE '%c%' já seria suficiente.

-- d) INNER JOIN entre tb_produtos e tb_categorias
SELECT p.id, p.nome AS produto, p.fabricante, p.preco, p.estoque, p.validade,
       c.nome AS categoria, c.tipo, c.descricao
FROM tb_produtos p
INNER JOIN tb_categorias c ON c.id = p.categoria_id;

-- e) INNER JOIN filtrando por uma categoria específica (ex.: apenas Cosméticos)
SELECT p.id, p.nome AS produto, p.fabricante, p.preco,
       c.nome AS categoria, c.tipo
FROM tb_produtos p
INNER JOIN tb_categorias c ON c.id = p.categoria_id
WHERE c.nome = 'Cosméticos';

/* ==============================
   5) Dicas para GitHub
   ==============================
   Salve este arquivo como db_farmacia_bem_estar.sql e suba para o seu repositório de Banco de Dados.
*/