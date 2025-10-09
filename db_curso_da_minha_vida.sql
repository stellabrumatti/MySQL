

/* ==============================
   1) Criação do Banco de Dados
   ============================== */

CREATE DATABASE db_curso_da_minha_vida
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE db_curso_da_minha_vida;

/* ==============================
   2) Criação das Tabelas
   ============================== */

-- Tabela de categorias: pelo menos 2 atributos além da PK
CREATE TABLE tb_categorias (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE,
  area ENUM('PROGRAMACAO','DADOS','DESIGN','NEGOCIOS','LIFESTYLE','OUTROS') NOT NULL,
  descricao VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Tabela de cursos: 4 atributos além da PK + FK para tb_categorias
CREATE TABLE tb_cursos (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  instrutor VARCHAR(100) NOT NULL,
  carga_horaria INT UNSIGNED NOT NULL,
  preco DECIMAL(10,2) NOT NULL CHECK (preco >= 0),
  nivel ENUM('INICIANTE','INTERMEDIARIO','AVANCADO') NOT NULL DEFAULT 'INICIANTE',
  categoria_id BIGINT NOT NULL,
  CONSTRAINT fk_cursos_categorias
    FOREIGN KEY (categoria_id) REFERENCES tb_categorias(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  INDEX idx_cursos_nome (nome),
  INDEX idx_cursos_preco (preco),
  INDEX idx_cursos_categoria (categoria_id)
) ENGINE=InnoDB;

  
/* ==============================
   3) Inserts
   ============================== */

-- 5 registros em tb_categorias
INSERT INTO tb_categorias (nome, area, descricao) VALUES
  ('Java',           'PROGRAMACAO', 'Cursos da linguagem Java e seu ecossistema.'),
  ('Ciência de Dados','DADOS',      'Análise, estatística, machine learning e IA.'),
  ('Design UX/UI',   'DESIGN',      'Experiência do usuário, interfaces e prototipação.'),
  ('Negócios e Gestão','NEGOCIOS',  'Estratégia, produtos digitais e liderança.'),
  ('Produtividade',  'LIFESTYLE',   'Organização, foco e rotinas de estudo.');

-- 8 registros em tb_cursos (com chave estrangeira categoria_id)
INSERT INTO tb_cursos (nome, instrutor, carga_horaria, preco, nivel, categoria_id) VALUES
  ('Java do Zero ao Avançado',          'Ana Martins',     60,  799.00, 'INTERMEDIARIO', (SELECT id FROM tb_categorias WHERE nome='Java')),
  ('Spring Boot Microservices',         'Carlos Souza',    48,  899.00, 'AVANCADO',      (SELECT id FROM tb_categorias WHERE nome='Java')),
  ('Estruturas de Dados com Java',      'Fernanda Lima',   36,  649.00, 'INTERMEDIARIO', (SELECT id FROM tb_categorias WHERE nome='Java')),
  ('Introdução à Ciência de Dados',     'João Ribeiro',    30,  499.00, 'INICIANTE',     (SELECT id FROM tb_categorias WHERE nome='Ciência de Dados')),
  ('Machine Learning Prático',          'Mariana Alves',   40,  950.00, 'INTERMEDIARIO', (SELECT id FROM tb_categorias WHERE nome='Ciência de Dados')),
  ('Figma para Iniciantes',             'Paula Rocha',     20,  299.00, 'INICIANTE',     (SELECT id FROM tb_categorias WHERE nome='Design UX/UI')),
  ('Gestão de Produtos Digitais',       'Ricardo Torres',  35,  720.00, 'INTERMEDIARIO', (SELECT id FROM tb_categorias WHERE nome='Negócios e Gestão')),
  ('Produtividade com Notion',          'Camila Santos',   12,  180.00, 'INICIANTE',     (SELECT id FROM tb_categorias WHERE nome='Produtividade'));

  
/* ==============================
   4) Consultas (SELECTs)
   ============================== */

-- a) Cursos com valor > R$ 500,00
SELECT id, nome, instrutor, carga_horaria, preco
FROM tb_cursos
WHERE preco > 500.00;

-- b) Cursos com valor entre R$ 600,00 e R$ 1.000,00 (inclusive)
SELECT id, nome, instrutor, carga_horaria, preco
FROM tb_cursos
WHERE preco BETWEEN 600.00 AND 1000.00;

-- c) Cursos cujo nome contém a letra 'J' (maiúscula ou minúscula)
SELECT id, nome, instrutor, carga_horaria, preco
FROM tb_cursos
WHERE UPPER(nome) LIKE '%J%';
-- Observação: Em collation case-insensitive, LIKE '%j%' já seria suficiente.

-- d) INNER JOIN entre tb_cursos e tb_categorias
SELECT c.id, c.nome AS curso, c.instrutor, c.carga_horaria, c.preco, c.nivel,
       cat.nome AS categoria, cat.area, cat.descricao
FROM tb_cursos c
INNER JOIN tb_categorias cat ON cat.id = c.categoria_id;

-- e) INNER JOIN filtrando por uma categoria específica (ex.: apenas Java)
SELECT c.id, c.nome AS curso, c.instrutor, c.preco, c.nivel,
       cat.nome AS categoria, cat.area
FROM tb_cursos c
INNER JOIN tb_categorias cat ON cat.id = c.categoria_id
WHERE cat.nome = 'Java';

