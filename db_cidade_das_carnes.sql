

/* ==============================
   1) Criação do Banco de Dados
   ============================== */
CREATE DATABASE db_cidade_das_carnes
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE db_cidade_das_carnes;

/* ==============================
   2) Criação das Tabelas
   ============================== */

-- Tabela de categorias: pelo menos 2 atributos além da PK
CREATE TABLE tb_categorias (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(60) NOT NULL UNIQUE,
  tipo ENUM('BOVINOS','SUINOS','AVES','PEIXES','EMBUTIDOS','OUTROS') NOT NULL,
  descricao VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Tabela de produtos: 4 atributos além da PK + FK para tb_categorias
CREATE TABLE tb_produtos (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  preco_kg DECIMAL(10,2) NOT NULL CHECK (preco_kg >= 0),
  peso_kg DECIMAL(8,3) NOT NULL CHECK (peso_kg > 0),
  estoque INT UNSIGNED NOT NULL DEFAULT 0,
  validade DATE NULL,
  categoria_id BIGINT NOT NULL,
  CONSTRAINT fk_produtos_categorias
    FOREIGN KEY (categoria_id) REFERENCES tb_categorias(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  INDEX idx_produtos_nome (nome),
  INDEX idx_produtos_preco (preco_kg),
  INDEX idx_produtos_categoria (categoria_id)
) ENGINE=InnoDB;

  
/* ==============================
   3) Inserts
   ============================== */

-- 5 registros em tb_categorias
INSERT INTO tb_categorias (nome, tipo, descricao) VALUES
  ('Cortes Bovinos', 'BOVINOS', 'Carnes de boi: grelha, assados e cozidos.'),
  ('Cortes Suínos',  'SUINOS',  'Carnes de porco e preparos diversos.'),
  ('Aves',           'AVES',    'Frango, peru e outras aves.'),
  ('Peixes',         'PEIXES',  'Peixes de água doce e salgada.'),
  ('Embutidos',      'EMBUTIDOS','Linguiças, salsichas e defumados.');

-- 8 registros em tb_produtos (com chave estrangeira categoria_id)
-- preços por kg e peso do item (em kg) para simular itens embalados
INSERT INTO tb_produtos (nome, preco_kg, peso_kg, estoque, validade, categoria_id) VALUES
  ('Contra-filé',        79.90, 1.200,  25, '2025-12-10', (SELECT id FROM tb_categorias WHERE nome='Cortes Bovinos')),
  ('Picanha',           129.90, 1.000,  15, '2025-12-05', (SELECT id FROM tb_categorias WHERE nome='Cortes Bovinos')),
  ('Filé de peito',      32.90, 1.000,  40, '2025-11-20', (SELECT id FROM tb_categorias WHERE nome='Aves')),
  ('Coxa e sobrecoxa',   24.50, 1.500,  50, '2025-11-25', (SELECT id FROM tb_categorias WHERE nome='Aves')),
  ('Lombo suíno',        39.90, 1.300,  20, '2025-11-30', (SELECT id FROM tb_categorias WHERE nome='Cortes Suínos')),
  ('Linguiça calabresa', 29.90, 1.000,  60, '2026-01-15', (SELECT id FROM tb_categorias WHERE nome='Embutidos')),
  ('Salmão',            115.00, 0.800,  12, '2025-12-08', (SELECT id FROM tb_categorias WHERE nome='Peixes')),
  ('Costela bovina',     55.00, 2.000,  18, '2025-12-12', (SELECT id FROM tb_categorias WHERE nome='Cortes Bovinos'));

  
/* ==============================
   4) Consultas (SELECTs)
   ============================== */

-- a) Produtos com valor (preço por kg) > R$ 50,00
SELECT id, nome, preco_kg, peso_kg, estoque
FROM tb_produtos
WHERE preco_kg > 50.00;

-- b) Produtos com valor (preço por kg) entre R$ 50,00 e R$ 150,00 (inclusive)
SELECT id, nome, preco_kg, peso_kg, estoque
FROM tb_produtos
WHERE preco_kg BETWEEN 50.00 AND 150.00;

-- c) Produtos cujo nome contém a letra 'C' (maiúscula ou minúscula)
SELECT id, nome, preco_kg, peso_kg, estoque
FROM tb_produtos
WHERE UPPER(nome) LIKE '%C%';

-- d) INNER JOIN entre tb_produtos e tb_categorias
SELECT p.id, p.nome AS produto, p.preco_kg, p.peso_kg, p.estoque, p.validade,
       c.nome AS categoria, c.tipo, c.descricao
FROM tb_produtos p
INNER JOIN tb_categorias c ON c.id = p.categoria_id;

-- e) INNER JOIN filtrando por uma categoria específica (ex.: apenas Aves)
SELECT p.id, p.nome AS produto, p.preco_kg, p.peso_kg, p.estoque,
       c.nome AS categoria, c.tipo
FROM tb_produtos p
INNER JOIN tb_categorias c ON c.id = p.categoria_id
WHERE c.nome = 'Aves';

