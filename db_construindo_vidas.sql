

/* ==============================
   1) Criação do Banco de Dados
   ============================== */

CREATE DATABASE db_construindo_vidas
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE db_construindo_vidas;

/* ==============================
   2) Criação das Tabelas
   ============================== */

-- Tabela de categorias: pelo menos 2 atributos além da PK
CREATE TABLE tb_categorias (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(60) NOT NULL UNIQUE,
  setor ENUM('HIDRAULICA','ELETRICA','FERRAMENTAS','TINTAS','BASICOS','OUTROS') NOT NULL,
  descricao VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Tabela de produtos: 4 atributos além da PK + FK para tb_categorias
CREATE TABLE tb_produtos (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  marca VARCHAR(80) NOT NULL,
  unidade ENUM('UN','KG','L','M2','M') NOT NULL DEFAULT 'UN',
  preco DECIMAL(10,2) NOT NULL CHECK (preco >= 0),
  estoque INT UNSIGNED NOT NULL DEFAULT 0,
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
INSERT INTO tb_categorias (nome, setor, descricao) VALUES
  ('Hidráulica', 'HIDRAULICA', 'Tubos, conexões, registros e itens para água e esgoto.'),
  ('Elétrica',   'ELETRICA',   'Fios, disjuntores, tomadas e iluminação.'),
  ('Ferramentas','FERRAMENTAS','Ferramentas manuais e elétricas.'),
  ('Tintas',     'TINTAS',     'Tintas, massas, rolos e acessórios de pintura.'),
  ('Básicos',    'BASICOS',    'Cimento, areia, brita e materiais de alvenaria.');

-- 8 registros em tb_produtos (com chave estrangeira categoria_id)
INSERT INTO tb_produtos (nome, marca, unidade, preco, estoque, categoria_id) VALUES
  ('Cimento CP-II 50kg',            'Votoran',     'UN',  42.90, 120, (SELECT id FROM tb_categorias WHERE nome='Básicos')),
  ('Massa corrida 25kg',            'Suvinil',     'UN', 129.90,  35, (SELECT id FROM tb_categorias WHERE nome='Tintas')),
  ('Tinta acrílica 18L',            'Coral',       'L',  499.00,  20, (SELECT id FROM tb_categorias WHERE nome='Tintas')),
  ('Esmerilhadeira 900W',           'Bosch',       'UN', 349.90,  15, (SELECT id FROM tb_categorias WHERE nome='Ferramentas')),
  ('Fio flexível 2,5mm 100m',       'Prysmian',    'M',  279.00,  25, (SELECT id FROM tb_categorias WHERE nome='Elétrica')),
  ('Disjuntor 2P 32A',              'Siemens',     'UN',  74.90,  60, (SELECT id FROM tb_categorias WHERE nome='Elétrica')),
  ('Registro esfera 1/2"',          'Tigre',       'UN',  58.50,  80, (SELECT id FROM tb_categorias WHERE nome='Hidráulica')),
  ('Conexão PVC joelho 90º 25mm',   'Tigre',       'UN',   6.90, 200, (SELECT id FROM tb_categorias WHERE nome='Hidráulica'));

  
/* ==============================
   4) Consultas (SELECTs)
   ============================== */

-- a) Produtos com valor > R$ 100,00
SELECT id, nome, marca, unidade, preco
FROM tb_produtos
WHERE preco > 100.00;

-- b) Produtos com valor entre R$ 70,00 e R$ 150,00 (inclusive)
SELECT id, nome, marca, unidade, preco
FROM tb_produtos
WHERE preco BETWEEN 70.00 AND 150.00;

-- c) Produtos cujo nome contém a letra 'C' (maiúscula ou minúscula)
SELECT id, nome, marca, unidade, preco
FROM tb_produtos
WHERE UPPER(nome) LIKE '%C%';
-- Observação: Em collation case-insensitive, LIKE '%c%' já seria suficiente.

-- d) INNER JOIN entre tb_produtos e tb_categorias
SELECT p.id, p.nome AS produto, p.marca, p.unidade, p.preco, p.estoque,
       c.nome AS categoria, c.setor, c.descricao
FROM tb_produtos p
INNER JOIN tb_categorias c ON c.id = p.categoria_id;

-- e) INNER JOIN filtrando por uma categoria específica (ex.: apenas Hidráulica)
SELECT p.id, p.nome AS produto, p.marca, p.unidade, p.preco,
       c.nome AS categoria, c.setor
FROM tb_produtos p
INNER JOIN tb_categorias c ON c.id = p.categoria_id
WHERE c.nome = 'Hidráulica';


