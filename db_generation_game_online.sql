
/* ==============================
   1) Criação do Banco de Dados
   ============================== */
CREATE DATABASE db_generation_game_online
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE db_generation_game_online;

/* ==============================
   2) Criação das Tabelas
   ============================== */

-- Tabela de classes: pelo menos 2 atributos além da PK
CREATE TABLE tb_classes (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(60) NOT NULL UNIQUE,
  tipo_dano ENUM('FISICO','MAGICO','HÍBRIDO') NOT NULL,
  descricao VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- Tabela de personagens: 4 atributos além da PK + FK para tb_classes
CREATE TABLE tb_personagens (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL,
  nivel INT UNSIGNED NOT NULL DEFAULT 1,
  poder_ataque INT UNSIGNED NOT NULL,
  poder_defesa INT UNSIGNED NOT NULL,
  classe_id BIGINT NOT NULL,
  CONSTRAINT fk_personagens_classes
    FOREIGN KEY (classe_id) REFERENCES tb_classes(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  INDEX idx_personagens_nome (nome),
  INDEX idx_personagens_nivel (nivel),
  INDEX idx_personagens_classe (classe_id)
) ENGINE=InnoDB;

  
/* ==============================
   3) Inserts
   ============================== */

-- 5 registros em tb_classes
INSERT INTO tb_classes (nome, tipo_dano, descricao) VALUES
  ('Guerreiro', 'FISICO', 'Especialista em combate corpo-a-corpo e alta resistência.'),
  ('Mago', 'MAGICO', 'Usa feitiços devastadores, porém com pouca defesa física.'),
  ('Arqueiro', 'FISICO', 'Ataques à distância com alta precisão.'),
  ('Clérigo', 'HÍBRIDO', 'Suporte com cura e proteção, além de dano sagrado.'),
  ('Assassino', 'FISICO', 'Dano explosivo e furtividade, porém frágil.');

-- 8 registros em tb_personagens (com chave estrangeira classe_id)
INSERT INTO tb_personagens (nome, nivel, poder_ataque, poder_defesa, classe_id) VALUES
  ('Cassandra', 35, 2100, 1200, (SELECT id FROM tb_classes WHERE nome='Arqueiro')),
  ('Baldur',    42, 2500, 1800, (SELECT id FROM tb_classes WHERE nome='Guerreiro')),
  ('Myrddin',   50, 3200,  900, (SELECT id FROM tb_classes WHERE nome='Mago')),
  ('Selene',    28, 1900, 2100, (SELECT id FROM tb_classes WHERE nome='Clérigo')),
  ('Corvan',    31, 2300, 1300, (SELECT id FROM tb_classes WHERE nome='Assassino')),
  ('Cael',      22, 1600, 1400, (SELECT id FROM tb_classes WHERE nome='Arqueiro')),
  ('Ciri',      44, 2700, 1600, (SELECT id FROM tb_classes WHERE nome='Assassino')),
  ('Thorin',    39, 2000, 2200, (SELECT id FROM tb_classes WHERE nome='Guerreiro'));

  
/* ==============================
   4) Consultas (SELECTs)
   ============================== */

-- a) Personagens com poder de ataque > 2000
SELECT id, nome, nivel, poder_ataque, poder_defesa
FROM tb_personagens
WHERE poder_ataque > 2000;

-- b) Personagens com poder de defesa entre 1000 e 2000 (inclusive)
SELECT id, nome, nivel, poder_ataque, poder_defesa
FROM tb_personagens
WHERE poder_defesa BETWEEN 1000 AND 2000;

-- c) Personagens cujo nome contém a letra 'C' (maiúscula ou minúscula)
SELECT id, nome, nivel, poder_ataque, poder_defesa
FROM tb_personagens
WHERE UPPER(nome) LIKE '%C%';
-- Observação: Em collation case-insensitive, LIKE '%c%' já seria suficiente.

-- d) INNER JOIN entre tb_personagens e tb_classes
SELECT p.id, p.nome AS personagem, p.nivel, p.poder_ataque, p.poder_defesa,
       c.nome AS classe, c.tipo_dano, c.descricao
FROM tb_personagens p
INNER JOIN tb_classes c ON c.id = p.classe_id;

-- e) INNER JOIN filtrando por uma classe específica (ex.: somente Arqueiros)
SELECT p.id, p.nome AS personagem, p.nivel, p.poder_ataque, p.poder_defesa,
       c.nome AS classe
FROM tb_personagens p
INNER JOIN tb_classes c ON c.id = p.classe_id
WHERE c.nome = 'Arqueiro';

