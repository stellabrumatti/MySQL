

/* ==============================
   1) Criação do Banco de Dados
   ============================== */
CREATE DATABASE db_pizzaria_legal
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE db_pizzaria_legal;

/* ==============================
   2) Criação das Tabelas
   ============================== */

-- Tabela de categorias: pelo menos 2 atributos além da PK
CREATE TABLE tb_categorias (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(60) NOT NULL UNIQUE,
  tipo ENUM('DOCE','SALGADA') NOT NULL,
  descricao VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Tabela de pizzas: 4 atributos além da PK + FK para tb_categorias
CREATE TABLE tb_pizzas (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL,
  tamanho ENUM('BROTO','MEDIA','GRANDE','GIGANTE') NOT NULL DEFAULT 'MEDIA',
  preco DECIMAL(8,2) NOT NULL CHECK (preco >= 0),
  ingredientes VARCHAR(255) NOT NULL,
  categoria_id BIGINT NOT NULL,
  CONSTRAINT fk_pizzas_categorias
    FOREIGN KEY (categoria_id) REFERENCES tb_categorias(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  INDEX idx_pizzas_nome (nome),
  INDEX idx_pizzas_preco (preco),
  INDEX idx_pizzas_categoria (categoria_id)
) ENGINE=InnoDB;

  
/* ==============================
   3) Inserts
   ============================== */

-- 5 registros em tb_categorias
INSERT INTO tb_categorias (nome, tipo, descricao) VALUES
  ('Tradicionais', 'SALGADA', 'Clássicos populares com ingredientes tradicionais.'),
  ('Especiais',    'SALGADA', 'Combinações diferenciadas e autorais.'),
  ('Doces',        'DOCE',    'Pizzas com coberturas doces.'),
  ('Veganas',      'SALGADA', 'Opções 100% base vegetal, sem ingredientes de origem animal.'),
  ('Premium',      'SALGADA', 'Ingredientes nobres e importados.');

-- 8 registros em tb_pizzas (com chave estrangeira categoria_id)
INSERT INTO tb_pizzas (nome, tamanho, preco, ingredientes, categoria_id) VALUES
  ('Margherita',     'GRANDE',  49.90, 'Molho, muçarela, tomate, manjericão', (SELECT id FROM tb_categorias WHERE nome='Tradicionais')),
  ('Calabresa',      'GRANDE',  54.90, 'Molho, muçarela, calabresa, cebola',  (SELECT id FROM tb_categorias WHERE nome='Tradicionais')),
  ('Quatro Queijos', 'MEDIA',   59.90, 'Muçarela, gorgonzola, provolone, parmesão', (SELECT id FROM tb_categorias WHERE nome='Especiais')),
  ('Portuguesa',     'GIGANTE', 69.90, 'Muçarela, presunto, ovo, ervilha, cebola',  (SELECT id FROM tb_categorias WHERE nome='Tradicionais')),
  ('Brigadeiro',     'MEDIA',   44.90, 'Chocolate, granulado, leite condensado',    (SELECT id FROM tb_categorias WHERE nome='Doces')),
  ('Romeu e Julieta','BROTO',   32.00, 'Goiabada, queijo',                           (SELECT id FROM tb_categorias WHERE nome='Doces')),
  ('Margarita Vegan','GRANDE',  57.00, 'Molho, queijo vegetal, tomate, manjericão', (SELECT id FROM tb_categorias WHERE nome='Veganas')),
  ('Trufada Premium','MEDIA',   95.00, 'Muçarela de búfala, funghi, azeite trufado', (SELECT id FROM tb_categorias WHERE nome='Premium'));

  
/* ==============================
   4) Consultas (SELECTs)
   ============================== */

-- a) Pizzas com valor > R$ 45,00
SELECT id, nome, tamanho, preco
FROM tb_pizzas
WHERE preco > 45.00;

-- b) Pizzas com valor entre R$ 50,00 e R$ 100,00 (inclusive)
SELECT id, nome, tamanho, preco
FROM tb_pizzas
WHERE preco BETWEEN 50.00 AND 100.00;

-- c) Pizzas cujo nome contém a letra 'M' (maiúscula ou minúscula)
SELECT id, nome, tamanho, preco
FROM tb_pizzas
WHERE UPPER(nome) LIKE '%M%';
-- Observação: Em collation case-insensitive, LIKE '%m%' já seria suficiente.

-- d) INNER JOIN entre tb_pizzas e tb_categorias
SELECT p.id, p.nome AS pizza, p.tamanho, p.preco, p.ingredientes,
       c.nome AS categoria, c.tipo, c.descricao
FROM tb_pizzas p
INNER JOIN tb_categorias c ON c.id = p.categoria_id;

-- e) INNER JOIN filtrando por uma categoria específica (ex.: apenas Doces)
SELECT p.id, p.nome AS pizza, p.tamanho, p.preco,
       c.nome AS categoria, c.tipo
FROM tb_pizzas p
INNER JOIN tb_categorias c ON c.id = p.categoria_id
WHERE c.nome = 'Doces';

