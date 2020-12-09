CREATE DATABASE sgc;

USE sgc;

CREATE TABLE t1000_perfiles(
    f1000_ts TIMESTAMP NOT NULL DEFAULT NOW()::TIMESTAMP,
    f1000_id SERIAL NOT NULL,
    f1000_nombre VARCHAR(100) NOT NULL,
    f1000_descripcion VARCHAR(100),
    CONSTRAINT t1000_pk
        PRIMARY KEY (f1000_id),
    CONSTRAINT t1000_no_repeat UNIQUE(f1000_nombre)
);

CREATE TABLE t1001_permisos(
    f1001_ts TIMESTAMP NOT NULL DEFAULT NOW()::TIMESTAMP,
    f1001_id SERIAL NOT NULL,
    f1001_nombre VARCHAR(100) NOT NULL,
    f1001_descripcion VARCHAR(100),
    CONSTRAINT t1001_pk
        PRIMARY KEY (f1001_id),
    CONSTRAINT t1001_no_repeat UNIQUE(f1001_nombre)
);

CREATE TABLE t1002_perfil_extendido(
    f1002_ts TIMESTAMP NOT NULL DEFAULT NOW()::TIMESTAMP,
    f1002_id SERIAL NOT NULL,
    f1002_id_perfil_t1000 INTEGER NOT NULL,
    f1002_id_permiso_t1001 INTEGER NOT NULL,
    CONSTRAINT t1002_pk
        PRIMARY KEY (f1002_id),
    CONSTRAINT t1002_fk_t1000
        FOREIGN KEY (f1002_id_perfil_t1000)
        REFERENCES t1000_perfiles(f1000_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT t1002_fk_t1001
        FOREIGN KEY (f1002_id_permiso_t1001)
        REFERENCES t1001_permisos(f1001_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE t1003_profesion(
    f1003_ts TIMESTAMP NOT NULL DEFAULT NOW()::TIMESTAMP,
    f1003_id SERIAL NOT NULL,
    f1003_nombre VARCHAR(100) NOT NULL,
    f1003_descripcion VARCHAR(100),
    CONSTRAINT t1003_pk
        PRIMARY KEY (f1003_id),
    CONSTRAINT t1003_no_repeat UNIQUE(f1003_nombre)
);

CREATE TABLE t1004_usuarios(
    f1004_ts TIMESTAMP NOT NULL DEFAULT NOW()::TIMESTAMP,
    f1004_id SERIAL NOT NULL,
    f1004_nombre VARCHAR(100) NOT NULL,
    f1004_apellido VARCHAR(100) ,
    f1004_fecha_nacimiento DATE,
    f1004_id_profesion_t1003 INTEGER NOT NULL,
    f1004_email VARCHAR(100) NOT NULL,
    f1004_clave VARCHAR(250) NOT NULL,
    f1004_id_perfil_t1000 INTEGER NOT NULL,
    f1004_ind_activo INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT t1004_pk
        PRIMARY KEY (f1004_id),
    CONSTRAINT t1004_fk_t1003
        FOREIGN KEY (f1004_id_profesion_t1003)
        REFERENCES t1003_profesion(f1003_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT t1004_fk_t1000
        FOREIGN KEY (f1004_id_perfil_t1000)
        REFERENCES t1000_perfiles(f1000_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT t1004_no_repeat UNIQUE(f1004_email)
);

CREATE TABLE t1005_imagenes(
    f1005_ts TIMESTAMP NOT NULL DEFAULT NOW()::TIMESTAMP,
    f1005_id SERIAL NOT NULL,
    f1005_nombre VARCHAR(100) NOT NULL,
    f1005_descripcion VARCHAR(100),
    f1005_data BYTEA NOT NULL,
    CONSTRAINT t1005_pk
        PRIMARY KEY (f1005_id)
);

CREATE TABLE t1006_eventos(
    f1006_ts TIMESTAMP NOT NULL DEFAULT NOW()::TIMESTAMP,
    f1006_id SERIAL NOT NULL,
    f1006_titulo VARCHAR(100) NOT NULL,
    f1006_descripcion VARCHAR(100),
    f1006_fecha_iso8601_inicial TIMESTAMP NOT NULL,
    f1006_fecha_iso8601_final TIMESTAMP NOT NULL,
    f1006_ind_todo_el_dia INTEGER ,
    f1006_id_usuario_creador_t1004 INTEGER NOT NULL,
    f1006_id_usuario_asignado_t1004 INTEGER NOT NULL,
    CONSTRAINT t1006_pk
        PRIMARY KEY (f1006_id),
    CONSTRAINT t1006_fk_t1004_1
        FOREIGN KEY (f1006_id_usuario_creador_t1004)
        REFERENCES t1004_usuarios(f1004_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT t1006_fk_t1004_2
        FOREIGN KEY (f1006_id_usuario_asignado_t1004)
        REFERENCES t1004_usuarios(f1004_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
ALTER TABLE t1006_eventos ADD f1006_ind_estado INTEGER NOT NULL DEFAULT 1;

CREATE OR REPLACE VIEW v2000_usuarios_info AS(
    SELECT
		f1004_ts 					AS f_fecha_creacion,
		f1004_id 					AS f_id,
		f1004_nombre 				AS f_nombre,
		f1004_apellido				AS f_apellido,
		f1004_fecha_nacimiento		AS f_fecha_nacimiento,
		f1003_nombre				AS f_profesion,
		f1004_email					AS f_email,
		f1004_clave					AS f_clave,
		f1000_nombre				AS f_perfil,
		CASE
			WHEN
				(f1004_ind_activo) = 0 THEN 'Inactivo'
			ELSE 'Activo'
		END	AS f_activo
	FROM t1004_usuarios
	INNER JOIN t1003_profesion
	ON t1004_usuarios.f1004_id_profesion_t1003 = t1003_profesion.f1003_id
	INNER JOIN t1000_perfiles
	ON t1004_usuarios.f1004_id_perfil_t1000 = t1000_perfiles.f1000_id
);

CREATE OR REPLACE VIEW v2001_permisos_info AS(
SELECT 			
    f1000_id 			AS f_id_pefil,
    f1001_ts 			AS f_fecha_creacion_permiso,
    f1001_id 			AS f_id_permiso,
    f1001_nombre 		AS f_nombre_permiso,
    f1001_descripcion 	AS f_desc_permiso
    FROM t1000_perfiles
    INNER JOIN t1002_perfil_extendido
    ON f1000_id = f1002_id_perfil_t1000
    INNER JOIN t1001_permisos
    ON t1001_permisos.f1001_id = t1002_perfil_extendido.f1002_id_permiso_t1001
                
);

CREATE OR REPLACE VIEW v2002_eventos_info AS(
    SELECT 
        f1006_ts						AS f_fecha_creacion,
        f1006_id						AS f_id,
        f1006_titulo					AS title,
        f1006_descripcion				AS desc,
        f1006_fecha_iso8601_inicial		AS start,
        f1006_fecha_iso8601_final		AS end,
        CASE
                WHEN
                    (f1006_ind_todo_el_dia) = 0 THEN 'No'
                ELSE 'Si'
        END	AS allDay,
        creador.f1004_nombre AS f_creado_por,
        asignado.f1004_nombre AS f_asignado_a,
        CASE
            WHEN
                (f1006_ind_estado) = 0 THEN 'Cancelado'
            ELSE 'Activo'
        END	AS Estado
        FROM t1006_eventos AS eventos
        LEFT JOIN t1004_usuarios AS creador
        ON eventos.f1006_id_usuario_asignado_t1004 = creador.f1004_id
        LEFT JOIN t1004_usuarios AS asignado
        ON eventos.f1006_id_usuario_creador_t1004 = asignado.f1004_id        
);


CREATE OR REPLACE VIEW v2003_eventos_filtro AS(
    SELECT 
        f1006_titulo					AS title,
        f1006_descripcion				AS desc,
        f1006_fecha_iso8601_inicial		AS start,
        f1006_fecha_iso8601_final		AS end,
        CASE
                WHEN
                    (f1006_ind_todo_el_dia) = 0 THEN false
                ELSE true
        END	AS allDay,
        creador.f1004_id AS f_creado_por,
        asignado.f1004_id AS f_asignado_a
        FROM t1006_eventos AS eventos
        LEFT JOIN t1004_usuarios AS creador
        ON eventos.f1006_id_usuario_asignado_t1004 = creador.f1004_id
        LEFT JOIN t1004_usuarios AS asignado
        ON eventos.f1006_id_usuario_creador_t1004 = asignado.f1004_id       
);