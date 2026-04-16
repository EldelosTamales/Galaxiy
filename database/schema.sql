-- ============================================================
--  BASE DE DATOS PARA BIBLIOTECA
--  Basado en el documento: Base de Datos para Bibliotecas
--  UNEFA - Cátedra: Base de Datos
--  Bachilleres: Del Valle Higuerey / Mariana Centeno
-- ============================================================

-- ============================================================
--  1. CREACIÓN DE LA BASE DE DATOS
-- ============================================================
CREATE DATABASE IF NOT EXISTS biblioteca
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE biblioteca;

-- ============================================================
--  2. DDL – CREACIÓN DE TABLAS (Modelo Relacional Normalizado 3FN)
-- ============================================================

-- ----------------------------------------------------------
--  2.1 ESTADO_PRESTAMO  (catálogo: activo / devuelto)
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS estado_prestamo (
    id_estado   INT          NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(50)  NOT NULL,          -- 'activo' | 'devuelto'
    CONSTRAINT pk_estado PRIMARY KEY (id_estado),
    CONSTRAINT uq_estado UNIQUE (descripcion)
) ENGINE=InnoDB;

-- ----------------------------------------------------------
--  2.2 CATEGORIA
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS categoria (
    id_categoria INT          NOT NULL AUTO_INCREMENT,
    nombre       VARCHAR(100) NOT NULL UNIQUE,
    descripcion  TEXT                  DEFAULT NULL,
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria)
) ENGINE=InnoDB;

-- ----------------------------------------------------------
--  2.3 AUTOR
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS autor (
    id_autor      INT          NOT NULL AUTO_INCREMENT,
    primer_nombre VARCHAR(100) NOT NULL,
    segundo_nombre VARCHAR(100)          DEFAULT NULL,
    primer_apellido VARCHAR(100) NOT NULL,
    segundo_apellido VARCHAR(100)        DEFAULT NULL,
    nacionalidad  VARCHAR(100)           DEFAULT NULL,
    CONSTRAINT pk_autor PRIMARY KEY (id_autor)
) ENGINE=InnoDB;

-- ----------------------------------------------------------
--  2.3 LIBRO
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS libro (
    id_libro           INT          NOT NULL AUTO_INCREMENT,
    id_autor           INT          NOT NULL,
    titulo             VARCHAR(255) NOT NULL,
    genero             VARCHAR(100)          DEFAULT NULL,
    anio_publicado     YEAR                  DEFAULT NULL,
    cantidad_disponible INT         NOT NULL DEFAULT 0,
    CONSTRAINT pk_libro   PRIMARY KEY (id_libro),
    CONSTRAINT fk_libro_autor FOREIGN KEY (id_autor)
        REFERENCES autor(id_autor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ----------------------------------------------------------
--  2.4 USUARIO
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario       INT          NOT NULL AUTO_INCREMENT,
    primer_nombre    VARCHAR(100) NOT NULL,
    segundo_nombre   VARCHAR(100)          DEFAULT NULL,
    primer_apellido  VARCHAR(100) NOT NULL,
    segundo_apellido VARCHAR(100)          DEFAULT NULL,
    fecha_registro   DATE         NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario)
) ENGINE=InnoDB;

-- ----------------------------------------------------------
--  2.5 CONTACTO_USUARIO  (teléfono y e-mail separados – 3FN)
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS contacto_usuario (
    id_contacto INT          NOT NULL AUTO_INCREMENT,
    id_usuario  INT          NOT NULL,
    email       VARCHAR(150) NOT NULL,
    telefono    VARCHAR(20)           DEFAULT NULL,
    CONSTRAINT pk_contacto_usuario PRIMARY KEY (id_contacto),
    CONSTRAINT uq_email_usuario UNIQUE (email),
    CONSTRAINT fk_cu_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------
--  2.6 BIBLIOTECARIO
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS bibliotecario (
    id_bibliotecario INT          NOT NULL AUTO_INCREMENT,
    primer_nombre    VARCHAR(100) NOT NULL,
    segundo_nombre   VARCHAR(100)          DEFAULT NULL,
    primer_apellido  VARCHAR(100) NOT NULL,
    segundo_apellido VARCHAR(100)          DEFAULT NULL,
    CONSTRAINT pk_bibliotecario PRIMARY KEY (id_bibliotecario)
) ENGINE=InnoDB;

-- ----------------------------------------------------------
--  2.7 CONTACTO_BIBLIOTECARIO  (teléfono y e-mail – 3FN)
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS contacto_bibliotecario (
    id_contacto      INT          NOT NULL AUTO_INCREMENT,
    id_bibliotecario INT          NOT NULL,
    email            VARCHAR(150) NOT NULL,
    telefono         VARCHAR(20)           DEFAULT NULL,
    CONSTRAINT pk_contacto_bib PRIMARY KEY (id_contacto),
    CONSTRAINT uq_email_bib UNIQUE (email),
    CONSTRAINT fk_cb_bibliotecario FOREIGN KEY (id_bibliotecario)
        REFERENCES bibliotecario(id_bibliotecario)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------
--  2.8 PRESTAMO
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS prestamo (
    id_prestamo      INT  NOT NULL AUTO_INCREMENT,
    id_usuario       INT  NOT NULL,
    id_bibliotecario INT  NOT NULL,
    id_estado        INT  NOT NULL DEFAULT 1,   -- 1 = activo
    fecha_prestamo   DATE NOT NULL DEFAULT (CURRENT_DATE),
    fecha_devolucion DATE          DEFAULT NULL,
    CONSTRAINT pk_prestamo PRIMARY KEY (id_prestamo),
    CONSTRAINT fk_pre_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pre_bib FOREIGN KEY (id_bibliotecario)
        REFERENCES bibliotecario(id_bibliotecario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pre_estado FOREIGN KEY (id_estado)
        REFERENCES estado_prestamo(id_estado)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ----------------------------------------------------------
--  2.9 PRESTAMO_LIBRO  (tabla asociativa – relación N:M)
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS prestamo_libro (
    id_prestamo INT NOT NULL,
    id_libro    INT NOT NULL,
    CONSTRAINT pk_prestamo_libro PRIMARY KEY (id_prestamo, id_libro),
    CONSTRAINT fk_pl_prestamo FOREIGN KEY (id_prestamo)
        REFERENCES prestamo(id_prestamo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pl_libro FOREIGN KEY (id_libro)
        REFERENCES libro(id_libro)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;


-- ============================================================
--  3. DML – DATOS DE EJEMPLO (INSERT)
-- ============================================================

-- Catálogo de estados
INSERT INTO estado_prestamo (descripcion) VALUES ('activo'), ('devuelto');

-- Autores
INSERT INTO autor (primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, nacionalidad) VALUES
('Gabriel',  'José',    'García',   'Márquez',   'Colombiana'),
('Isabel',    NULL,      'Allende',  NULL,        'Chilena'),
('Mario',    'Vargas',   'Llosa',    NULL,        'Peruana'),
('Arturo',    NULL,      'Pérez-Reverte', NULL,  'Española'),
('Jorge',    'Luis',    'Borges',   NULL,        'Argentina');

-- Libros
INSERT INTO libro (id_autor, titulo, genero, anio_publicado, cantidad_disponible) VALUES
(1, 'Cien años de soledad',         'Realismo mágico', 1967, 5),
(1, 'El amor en los tiempos del cólera', 'Novela',     1985, 3),
(2, 'La casa de los espíritus',     'Novela',          1982, 4),
(3, 'La ciudad y los perros',       'Novela',          1963, 2),
(4, 'El nombre de la rosa',         'Histórica',       1980, 6),
(5, 'Ficciones',                    'Cuento',          1944, 2),
(5, 'El Aleph',                     'Cuento',          1949, 1);

-- Usuarios
INSERT INTO usuario (primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, fecha_registro) VALUES
('Ana',    'María',   'González', 'Pérez',    '2025-01-10'),
('Carlos', NULL,      'Rodríguez','López',    '2025-02-15'),
('Luisa',  'Fernanda','Martínez', 'García',   '2025-03-01'),
('Pedro',  NULL,      'Hernández','Morales',  '2025-03-20'),
('Sofia',  'Isabel',  'Ramírez',  NULL,       '2025-04-05');

-- Contactos de usuarios
INSERT INTO contacto_usuario (id_usuario, email, telefono) VALUES
(1, 'ana.gonzalez@email.com',    '0412-1234567'),
(2, 'carlos.rodriguez@email.com','0414-7654321'),
(3, 'luisa.martinez@email.com',  '0416-9876543'),
(4, 'pedro.hernandez@email.com', '0424-4561237'),
(5, 'sofia.ramirez@email.com',   '0426-3217654');

-- Bibliotecarios
INSERT INTO bibliotecario (primer_nombre, segundo_nombre, primer_apellido, segundo_apellido) VALUES
('Bilmaro',  NULL,     'Fernández', 'Silva'),
('Carmen',   'Rosa',   'Torres',    'Díaz'),
('Javier',   NULL,     'Moreno',    'Ruiz');

-- Contactos de bibliotecarios
INSERT INTO contacto_bibliotecario (id_bibliotecario, email, telefono) VALUES
(1, 'bilmaro.fernandez@biblioteca.com', '0212-5550101'),
(2, 'carmen.torres@biblioteca.com',     '0212-5550102'),
(3, 'javier.moreno@biblioteca.com',     '0212-5550103');

-- Préstamos
INSERT INTO prestamo (id_usuario, id_bibliotecario, id_estado, fecha_prestamo, fecha_devolucion) VALUES
(1, 1, 1, '2025-07-01', '2025-07-15'),  -- activo
(2, 1, 2, '2025-07-03', '2025-07-10'),  -- devuelto
(3, 2, 1, '2025-07-05', '2025-07-20'),  -- activo
(1, 2, 1, '2025-07-08', '2025-07-22'),  -- activo (usuario con más de 1 activo)
(4, 3, 2, '2025-07-10', '2025-07-17'),  -- devuelto
(5, 1, 1, '2025-07-12', '2025-07-26');  -- activo

-- Libros por préstamo (N:M)
INSERT INTO prestamo_libro (id_prestamo, id_libro) VALUES
(1, 1),
(1, 3),
(2, 4),
(3, 2),
(3, 5),
(4, 6),
(5, 7),
(6, 1);


-- ============================================================
--  4. DDL ADICIONAL – Ejemplos ALTER / DROP / RENAME / TRUNCATE
-- ============================================================

-- Agregar columna de observaciones a préstamo
ALTER TABLE prestamo ADD COLUMN observaciones VARCHAR(255) DEFAULT NULL;

-- Modificar longitud del campo titulo en libro
ALTER TABLE libro MODIFY COLUMN titulo VARCHAR(300) NOT NULL;

-- Agregar índice para búsquedas frecuentes por título
ALTER TABLE libro ADD INDEX idx_titulo (titulo);

-- Agregar índice compuesto en préstamo (usuario + estado)
ALTER TABLE prestamo ADD INDEX idx_usuario_estado (id_usuario, id_estado);

-- Ejemplo COMMENT en columna (MySQL 8+)
ALTER TABLE libro
  MODIFY COLUMN cantidad_disponible INT NOT NULL DEFAULT 0
  COMMENT 'Copias físicamente disponibles para préstamo';


-- ============================================================
--  5. DML – 15 CONSULTAS SQL (REPORTES)
-- ============================================================

-- 1. Préstamos activos
SELECT
    p.id_prestamo,
    CONCAT(u.primer_nombre,' ',u.primer_apellido) AS usuario,
    p.fecha_prestamo,
    p.fecha_devolucion
FROM prestamo p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN estado_prestamo ep ON p.id_estado = ep.id_estado
WHERE ep.descripcion = 'activo';

-- 2. Préstamos devueltos
SELECT
    p.id_prestamo,
    CONCAT(u.primer_nombre,' ',u.primer_apellido) AS usuario,
    p.fecha_prestamo,
    p.fecha_devolucion
FROM prestamo p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN estado_prestamo ep ON p.id_estado = ep.id_estado
WHERE ep.descripcion = 'devuelto';

-- 3. Libros con menos de 3 copias disponibles
SELECT id_libro, titulo, cantidad_disponible
FROM libro
WHERE cantidad_disponible < 3;

-- 4. Usuarios con más de un préstamo activo
SELECT
    u.id_usuario,
    CONCAT(u.primer_nombre,' ',u.primer_apellido) AS usuario,
    COUNT(*) AS prestamos_activos
FROM prestamo p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN estado_prestamo ep ON p.id_estado = ep.id_estado
WHERE ep.descripcion = 'activo'
GROUP BY u.id_usuario, u.primer_nombre, u.primer_apellido
HAVING prestamos_activos > 1;

-- 5. Libros más prestados
SELECT
    l.titulo,
    COUNT(pl.id_prestamo) AS veces_prestado
FROM prestamo_libro pl
JOIN libro l ON pl.id_libro = l.id_libro
GROUP BY l.id_libro, l.titulo
ORDER BY veces_prestado DESC;

-- 6. Historial de préstamos por usuario
SELECT
    CONCAT(u.primer_nombre,' ',u.primer_apellido) AS usuario,
    l.titulo,
    p.fecha_prestamo,
    ep.descripcion AS estado
FROM prestamo p
JOIN usuario u ON p.id_usuario = u.id_usuario
JOIN estado_prestamo ep ON p.id_estado = ep.id_estado
JOIN prestamo_libro pl ON p.id_prestamo = pl.id_prestamo
JOIN libro l ON pl.id_libro = l.id_libro
ORDER BY u.primer_apellido, p.fecha_prestamo;

-- 7. Préstamos realizados en julio 2025
SELECT *
FROM prestamo
WHERE fecha_prestamo BETWEEN '2025-07-01' AND '2025-07-31';

-- 8. Libros que nunca han sido prestados
SELECT l.id_libro, l.titulo
FROM libro l
WHERE l.id_libro NOT IN (
    SELECT DISTINCT id_libro FROM prestamo_libro
);

-- 9. Préstamos gestionados por cada bibliotecario
SELECT
    CONCAT(b.primer_nombre,' ',b.primer_apellido) AS bibliotecario,
    COUNT(*) AS cantidad_prestamos
FROM prestamo p
JOIN bibliotecario b ON p.id_bibliotecario = b.id_bibliotecario
GROUP BY b.id_bibliotecario, b.primer_nombre, b.primer_apellido
ORDER BY cantidad_prestamos DESC;

-- 10. Autores con más de un libro registrado
SELECT
    CONCAT(a.primer_nombre,' ',a.primer_apellido) AS autor,
    COUNT(*) AS total_libros
FROM libro l
JOIN autor a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.primer_nombre, a.primer_apellido
HAVING total_libros > 1;

-- 11. Últimos 5 libros prestados
SELECT
    l.titulo,
    p.fecha_prestamo
FROM prestamo p
JOIN prestamo_libro pl ON p.id_prestamo = pl.id_prestamo
JOIN libro l ON pl.id_libro = l.id_libro
ORDER BY p.fecha_prestamo DESC
LIMIT 5;

-- 12. Usuarios registrados el mes en curso
SELECT
    id_usuario,
    CONCAT(primer_nombre,' ',primer_apellido) AS nombre,
    fecha_registro
FROM usuario
WHERE MONTH(fecha_registro) = MONTH(CURDATE())
  AND YEAR(fecha_registro)  = YEAR(CURDATE());

-- 13. Cantidad total de préstamos por libro
SELECT
    l.titulo,
    COUNT(pl.id_prestamo) AS total_prestamos
FROM libro l
LEFT JOIN prestamo_libro pl ON l.id_libro = pl.id_libro
GROUP BY l.id_libro, l.titulo
ORDER BY total_prestamos DESC;

-- 14. Usuarios que nunca han solicitado un préstamo
SELECT
    id_usuario,
    CONCAT(primer_nombre,' ',primer_apellido) AS nombre
FROM usuario
WHERE id_usuario NOT IN (
    SELECT DISTINCT id_usuario FROM prestamo
);

-- 15. Detalle completo de préstamos (usuario + libro + bibliotecario)
SELECT
    CONCAT(u.primer_nombre,' ',u.primer_apellido)  AS usuario,
    l.titulo                                        AS libro,
    CONCAT(b.primer_nombre,' ',b.primer_apellido)  AS bibliotecario,
    p.fecha_prestamo,
    p.fecha_devolucion,
    ep.descripcion                                  AS estado
FROM prestamo p
JOIN usuario      u  ON p.id_usuario       = u.id_usuario
JOIN bibliotecario b ON p.id_bibliotecario = b.id_bibliotecario
JOIN estado_prestamo ep ON p.id_estado     = ep.id_estado
JOIN prestamo_libro  pl ON p.id_prestamo   = pl.id_prestamo
JOIN libro           l  ON pl.id_libro     = l.id_libro
ORDER BY p.fecha_prestamo DESC;


-- ============================================================
--  6. VISTAS ÚTILES
-- ============================================================

CREATE OR REPLACE VIEW v_prestamos_activos AS
SELECT
    p.id_prestamo,
    CONCAT(u.primer_nombre,' ',u.primer_apellido) AS usuario,
    cu.email,
    l.titulo,
    p.fecha_prestamo,
    p.fecha_devolucion,
    DATEDIFF(p.fecha_devolucion, CURDATE()) AS dias_restantes
FROM prestamo p
JOIN usuario u             ON p.id_usuario = u.id_usuario
JOIN contacto_usuario cu   ON cu.id_usuario = u.id_usuario
JOIN estado_prestamo ep    ON p.id_estado   = ep.id_estado
JOIN prestamo_libro pl     ON p.id_prestamo = pl.id_prestamo
JOIN libro l               ON pl.id_libro   = l.id_libro
WHERE ep.descripcion = 'activo';

CREATE OR REPLACE VIEW v_stock_libros AS
SELECT
    l.id_libro,
    l.titulo,
    l.genero,
    l.anio_publicado,
    l.cantidad_disponible,
    CONCAT(a.primer_nombre,' ',a.primer_apellido) AS autor
FROM libro l
JOIN autor a ON l.id_autor = a.id_autor;


-- ============================================================
--  FIN DEL SCRIPT
-- ============================================================
