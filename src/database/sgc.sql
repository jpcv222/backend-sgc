--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: f_activar_evento(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_activar_evento(in_id_evento integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;
        CONST_ACTIVO INTEGER := 1; 

    BEGIN

        UPDATE t1006_eventos
        SET
            f1006_ind_estado = CONST_ACTIVO
        WHERE f1006_id = in_id_evento;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_activar_evento(in_id_evento integer) OWNER TO postgres;

--
-- Name: f_activar_usuario(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_activar_usuario(in_id_usuario integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;
        CONST_ACTIVO INTEGER := 1; 

    BEGIN

        UPDATE t1004_usuarios
        SET
            f1004_ind_activo = CONST_ACTIVO
        WHERE f1004_id = in_id_usuario;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_activar_usuario(in_id_usuario integer) OWNER TO postgres;

--
-- Name: f_actualizar_evento(json, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_actualizar_evento(in_json_txt json, in_id_evento integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;
        v_titulo TEXT;
        v_descripcion TEXT;
        v_fecha_inicial TIMESTAMP;
        v_fecha_final TIMESTAMP;
        v_ind_todo_el_dia INTEGER;
        v_id_asignado INTEGER;

    BEGIN
        SELECT titulo INTO v_titulo FROM json_to_record(in_json_txt) AS x(titulo TEXT);
        SELECT descripcion INTO v_descripcion FROM json_to_record(in_json_txt) AS x(descripcion TEXT);
        SELECT fecha_inicial INTO v_fecha_inicial FROM json_to_record(in_json_txt) AS x(fecha_inicial TIMESTAMP);
        SELECT fecha_final INTO v_fecha_final FROM json_to_record(in_json_txt) AS x(fecha_final TIMESTAMP);
        SELECT ind_todo_el_dia INTO v_ind_todo_el_dia FROM json_to_record(in_json_txt) AS x(ind_todo_el_dia INTEGER);
        SELECT id_asignado INTO v_id_asignado FROM json_to_record(in_json_txt) AS x(id_asignado INTEGER);

        UPDATE t1006_eventos
        SET
            f1006_titulo                    = v_titulo,
            f1006_descripcion               = v_descripcion,
            f1006_fecha_iso8601_inicial     = v_fecha_inicial,
            f1006_fecha_iso8601_final       = v_fecha_final,
            f1006_ind_todo_el_dia           = v_ind_todo_el_dia,
            f1006_id_usuario_asignado_t1004 = v_id_asignado          
        WHERE f1006_id = in_id_evento;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_actualizar_evento(in_json_txt json, in_id_evento integer) OWNER TO postgres;

--
-- Name: f_actualizar_usuario(json, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_actualizar_usuario(in_json_txt json, in_id_usuario integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;
        v_nombre TEXT;
        v_apellido TEXT;
        -- v_fecha_nacimiento DATE;
        v_id_profesion INTEGER;
        -- v_id_perfil INTEGER;

    BEGIN
        SELECT nombre INTO v_nombre FROM json_to_record(in_json_txt) AS x(nombre TEXT);
        SELECT apellido INTO v_apellido FROM json_to_record(in_json_txt) AS x(apellido TEXT);
        -- SELECT fecha_nacimiento INTO v_fecha_nacimiento FROM json_to_record(in_json_txt) AS x(fecha_nacimiento DATE);
        SELECT id_profesion INTO v_id_profesion FROM json_to_record(in_json_txt) AS x(id_profesion INTEGER);
        -- SELECT id_perfil INTO v_id_perfil FROM json_to_record(in_json_txt) AS x(id_perfil INTEGER);

        UPDATE t1004_usuarios
        SET
            f1004_nombre = v_nombre,
            f1004_apellido = v_apellido,
            -- f1004_fecha_nacimiento = v_fecha_nacimiento,
            f1004_id_profesion_t1003 = v_id_profesion
            -- f1004_id_perfil_t1000 = v_id_perfil
        WHERE f1004_id = in_id_usuario;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_actualizar_usuario(in_json_txt json, in_id_usuario integer) OWNER TO postgres;

--
-- Name: f_actualizar_usuario_clave(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_actualizar_usuario_clave(in_clave text, in_id_usuario integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;

    BEGIN

        UPDATE t1004_usuarios
        SET
            f1004_clave = MD5(in_clave)
        WHERE f1004_id = in_id_usuario;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_actualizar_usuario_clave(in_clave text, in_id_usuario integer) OWNER TO postgres;

--
-- Name: f_actualizar_usuario_email(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_actualizar_usuario_email(in_email text, in_id_usuario integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;

    BEGIN

        UPDATE t1004_usuarios
        SET
            f1004_email = in_email
        WHERE f1004_id = in_id_usuario;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_actualizar_usuario_email(in_email text, in_id_usuario integer) OWNER TO postgres;

--
-- Name: f_actualizar_usuario_perfil(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_actualizar_usuario_perfil(in_id_perfil integer, in_id_usuario integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;

    BEGIN

        UPDATE t1004_usuarios
        SET
            f1004_id_perfil_t1000 = in_id_perfil
        WHERE f1004_id = in_id_usuario;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_actualizar_usuario_perfil(in_id_perfil integer, in_id_usuario integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: t1004_usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t1004_usuarios (
    f1004_ts timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    f1004_id integer NOT NULL,
    f1004_nombre character varying(100) NOT NULL,
    f1004_apellido character varying(100),
    f1004_fecha_nacimiento date,
    f1004_id_profesion_t1003 integer NOT NULL,
    f1004_email character varying(100) NOT NULL,
    f1004_clave character varying(250) NOT NULL,
    f1004_id_perfil_t1000 integer NOT NULL,
    f1004_ind_activo integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.t1004_usuarios OWNER TO postgres;

--
-- Name: f_autenticacion_usuario(json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_autenticacion_usuario(in_json_txt json) RETURNS SETOF public.t1004_usuarios
    LANGUAGE plpgsql
    AS $$
DECLARE
    reg RECORD;
	err_context text;
    v_email text;
    v_clave text;

BEGIN
    SELECT email 
        INTO v_email 
        FROM json_to_record(in_json_txt) 
            AS x(email text);
    SELECT MD5(clave)
        INTO v_clave 
        FROM json_to_record(in_json_txt) 
            AS x(clave text);

    FOR REG IN
        SELECT *
        FROM t1004_usuarios
        WHERE   f1004_email = v_email
        AND     f1004_clave = v_clave
        LOOP
        RETURN NEXT reg;
    END LOOP;
    RETURN;


        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
END
$$;


ALTER FUNCTION public.f_autenticacion_usuario(in_json_txt json) OWNER TO postgres;

--
-- Name: f_eliminar_evento(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_eliminar_evento(in_id_evento integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;
        CONST_INACTIVO INTEGER := 0; 

    BEGIN

        UPDATE t1006_eventos
        SET
            f1006_ind_estado = CONST_INACTIVO
        WHERE f1006_id = in_id_evento;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_eliminar_evento(in_id_evento integer) OWNER TO postgres;

--
-- Name: f_eliminar_permiso_ext(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_eliminar_permiso_ext(in_id_perfil integer, in_id_permiso integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;

    BEGIN

        DELETE FROM t1002_perfil_extendido
        WHERE f1002_id_perfil_t1000 = in_id_perfil
        AND f1002_id_permiso_t1001 = in_id_permiso;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_eliminar_permiso_ext(in_id_perfil integer, in_id_permiso integer) OWNER TO postgres;

--
-- Name: f_eliminar_usuario(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_eliminar_usuario(in_id_usuario integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context TEXT;
        CONST_INACTIVO INTEGER := 0; 

    BEGIN

        UPDATE t1004_usuarios
        SET
            f1004_ind_activo = CONST_INACTIVO
        WHERE f1004_id = in_id_usuario;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_eliminar_usuario(in_id_usuario integer) OWNER TO postgres;

--
-- Name: f_insertar_evento(json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_insertar_evento(in_json_txt json) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context text;

    BEGIN

        INSERT INTO t1006_eventos(
            f1006_titulo,
            f1006_descripcion,
            f1006_fecha_iso8601_inicial,
            f1006_fecha_iso8601_final,
            f1006_ind_todo_el_dia,
            f1006_id_usuario_creador_t1004,
            f1006_id_usuario_asignado_t1004
        )
        SELECT
            titulo,
            descripcion,
            fecha_inicial,
            fecha_final,
            ind_todo_el_dia,
            id_creador,
            id_asignado
        FROM json_to_record(in_json_txt) AS x( 
            titulo TEXT,
            descripcion TEXT,
            fecha_inicial TIMESTAMP,
            fecha_final TIMESTAMP,
            ind_todo_el_dia INTEGER,
            id_creador INTEGER,
            id_asignado INTEGER
        );

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_insertar_evento(in_json_txt json) OWNER TO postgres;

--
-- Name: f_insertar_perfil(json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_insertar_perfil(in_json_txt json) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context text;

    BEGIN

        INSERT INTO t1000_perfiles(
            f1000_nombre,
            f1000_descripcion
        )
        SELECT
            nombre,
            descripcion
        FROM json_to_record(in_json_txt) AS x( 
            nombre text,
            descripcion text
        );

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_insertar_perfil(in_json_txt json) OWNER TO postgres;

--
-- Name: f_insertar_perfil_ext(json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_insertar_perfil_ext(in_json_txt json) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context text;

    BEGIN

        INSERT INTO t1002_perfil_extendido(
            f1002_id_perfil_t1000,
            f1002_id_permiso_t1001
        )
        SELECT
            id_perfil,
            id_permiso
        FROM json_to_record(in_json_txt) AS x( 
            id_perfil INTEGER,
            id_permiso INTEGER
        );

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_insertar_perfil_ext(in_json_txt json) OWNER TO postgres;

--
-- Name: f_insertar_usuario(json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_insertar_usuario(in_json_txt json) RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context text;

    BEGIN

        INSERT INTO t1004_usuarios(
            f1004_nombre,
            f1004_apellido,
            f1004_fecha_nacimiento,
            f1004_id_profesion_t1003,
            f1004_email,
            f1004_clave,
            f1004_id_perfil_t1000
        )
        SELECT
            nombre,
            apellido,
            fecha_nacimiento,
            id_profesion,
            email,
            MD5(clave),
            id_perfil
        FROM json_to_record(in_json_txt) AS x( 
            nombre text,
            apellido text,
            fecha_nacimiento date,
            id_profesion int,
            email text,
            clave text,
            id_perfil int
        );

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_insertar_usuario(in_json_txt json) OWNER TO postgres;

--
-- Name: t1006_eventos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t1006_eventos (
    f1006_ts timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    f1006_id integer NOT NULL,
    f1006_titulo character varying(100) NOT NULL,
    f1006_descripcion character varying(100),
    f1006_fecha_iso8601_inicial timestamp without time zone NOT NULL,
    f1006_fecha_iso8601_final timestamp without time zone NOT NULL,
    f1006_ind_todo_el_dia integer,
    f1006_id_usuario_creador_t1004 integer NOT NULL,
    f1006_id_usuario_asignado_t1004 integer NOT NULL,
    f1006_ind_estado integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.t1006_eventos OWNER TO postgres;

--
-- Name: f_obtener_evento(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_obtener_evento(in_id_evento integer) RETURNS SETOF public.t1006_eventos
    LANGUAGE plpgsql
    AS $$
DECLARE
    reg RECORD;
	err_context text;

BEGIN
    FOR REG IN
        SELECT *
        FROM t1006_eventos
        WHERE f1006_id = in_id_evento
        LOOP
        RETURN NEXT reg;
    END LOOP;
    RETURN;


        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
END
$$;


ALTER FUNCTION public.f_obtener_evento(in_id_evento integer) OWNER TO postgres;

--
-- Name: v2002_eventos_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v2002_eventos_info AS
 SELECT eventos.f1006_ts AS f_fecha_creacion,
    eventos.f1006_id AS f_id,
    eventos.f1006_titulo AS title,
    eventos.f1006_descripcion AS "desc",
    eventos.f1006_fecha_iso8601_inicial AS start,
    eventos.f1006_fecha_iso8601_final AS "end",
        CASE
            WHEN (eventos.f1006_ind_todo_el_dia = 0) THEN 'No'::text
            ELSE 'Si'::text
        END AS allday,
    creador.f1004_nombre AS f_creado_por,
    asignado.f1004_nombre AS f_asignado_a,
        CASE
            WHEN (eventos.f1006_ind_estado = 0) THEN 'Cancelado'::text
            ELSE 'Activo'::text
        END AS estado
   FROM ((public.t1006_eventos eventos
     LEFT JOIN public.t1004_usuarios creador ON ((eventos.f1006_id_usuario_asignado_t1004 = creador.f1004_id)))
     LEFT JOIN public.t1004_usuarios asignado ON ((eventos.f1006_id_usuario_creador_t1004 = asignado.f1004_id)));


ALTER TABLE public.v2002_eventos_info OWNER TO postgres;

--
-- Name: f_obtener_eventos_ext(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_obtener_eventos_ext() RETURNS SETOF public.v2002_eventos_info
    LANGUAGE plpgsql
    AS $$
        DECLARE
            r v2002_eventos_info%rowtype;
            err_context text;
    BEGIN
        FOR r IN SELECT * FROM v2002_eventos_info
            LOOP
            RETURN NEXT r;
        END LOOP;
        RETURN;
        
        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
    END
$$;


ALTER FUNCTION public.f_obtener_eventos_ext() OWNER TO postgres;

--
-- Name: t1000_perfiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t1000_perfiles (
    f1000_ts timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    f1000_id integer NOT NULL,
    f1000_nombre character varying(100) NOT NULL,
    f1000_descripcion character varying(100)
);


ALTER TABLE public.t1000_perfiles OWNER TO postgres;

--
-- Name: f_obtener_perfiles(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_obtener_perfiles() RETURNS SETOF public.t1000_perfiles
    LANGUAGE plpgsql
    AS $$
DECLARE
    reg RECORD;
	err_context text;

BEGIN
    FOR REG IN
        SELECT *
        FROM t1000_perfiles
        LOOP
        RETURN NEXT reg;
    END LOOP;
    RETURN;


        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
END
$$;


ALTER FUNCTION public.f_obtener_perfiles() OWNER TO postgres;

--
-- Name: t1001_permisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t1001_permisos (
    f1001_ts timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    f1001_id integer NOT NULL,
    f1001_nombre character varying(100) NOT NULL,
    f1001_descripcion character varying(100)
);


ALTER TABLE public.t1001_permisos OWNER TO postgres;

--
-- Name: f_obtener_permisos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_obtener_permisos() RETURNS SETOF public.t1001_permisos
    LANGUAGE plpgsql
    AS $$
DECLARE
    reg RECORD;
	err_context text;

BEGIN
    FOR REG IN
        SELECT *
        FROM t1001_permisos
        LOOP
        RETURN NEXT reg;
    END LOOP;
    RETURN;


        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
END
$$;


ALTER FUNCTION public.f_obtener_permisos() OWNER TO postgres;

--
-- Name: t1002_perfil_extendido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t1002_perfil_extendido (
    f1002_ts timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    f1002_id integer NOT NULL,
    f1002_id_perfil_t1000 integer NOT NULL,
    f1002_id_permiso_t1001 integer NOT NULL
);


ALTER TABLE public.t1002_perfil_extendido OWNER TO postgres;

--
-- Name: v2001_permisos_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v2001_permisos_info AS
 SELECT t1000_perfiles.f1000_id AS f_id_pefil,
    t1001_permisos.f1001_ts AS f_fecha_creacion_permiso,
    t1001_permisos.f1001_id AS f_id_permiso,
    t1001_permisos.f1001_nombre AS f_nombre_permiso,
    t1001_permisos.f1001_descripcion AS f_desc_permiso
   FROM ((public.t1000_perfiles
     JOIN public.t1002_perfil_extendido ON ((t1000_perfiles.f1000_id = t1002_perfil_extendido.f1002_id_perfil_t1000)))
     JOIN public.t1001_permisos ON ((t1001_permisos.f1001_id = t1002_perfil_extendido.f1002_id_permiso_t1001)));


ALTER TABLE public.v2001_permisos_info OWNER TO postgres;

--
-- Name: f_obtener_permisos_ext(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_obtener_permisos_ext(p_id_perfil integer) RETURNS SETOF public.v2001_permisos_info
    LANGUAGE plpgsql
    AS $$
        DECLARE
            r v2001_permisos_info%rowtype;
            err_context text;
    BEGIN
        FOR r IN 
            SELECT *
            FROM v2001_permisos_info
            WHERE f_id_pefil = p_id_perfil
            LOOP
            RETURN NEXT r;
        END LOOP;
        RETURN;
        
        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
    END
$$;


ALTER FUNCTION public.f_obtener_permisos_ext(p_id_perfil integer) OWNER TO postgres;

--
-- Name: t1003_profesion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t1003_profesion (
    f1003_ts timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    f1003_id integer NOT NULL,
    f1003_nombre character varying(100) NOT NULL,
    f1003_descripcion character varying(100)
);


ALTER TABLE public.t1003_profesion OWNER TO postgres;

--
-- Name: f_obtener_profesiones(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_obtener_profesiones() RETURNS SETOF public.t1003_profesion
    LANGUAGE plpgsql
    AS $$
DECLARE
    reg RECORD;
	err_context text;

BEGIN
    FOR REG IN
        SELECT *
        FROM t1003_profesion
        LOOP
        RETURN NEXT reg;
    END LOOP;
    RETURN;


        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
END
$$;


ALTER FUNCTION public.f_obtener_profesiones() OWNER TO postgres;

--
-- Name: f_obtener_usuario(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_obtener_usuario(in_id_usuario integer) RETURNS SETOF public.t1004_usuarios
    LANGUAGE plpgsql
    AS $$
DECLARE
    reg RECORD;
	err_context text;

BEGIN
    FOR REG IN
        SELECT *
        FROM t1004_usuarios
        WHERE f1004_id = in_id_usuario
        LOOP
        RETURN NEXT reg;
    END LOOP;
    RETURN;


        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
END
$$;


ALTER FUNCTION public.f_obtener_usuario(in_id_usuario integer) OWNER TO postgres;

--
-- Name: v2000_usuarios_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v2000_usuarios_info AS
 SELECT t1004_usuarios.f1004_ts AS f_fecha_creacion,
    t1004_usuarios.f1004_id AS f_id,
    t1004_usuarios.f1004_nombre AS f_nombre,
    t1004_usuarios.f1004_apellido AS f_apellido,
    t1004_usuarios.f1004_fecha_nacimiento AS f_fecha_nacimiento,
    t1003_profesion.f1003_nombre AS f_profesion,
    t1004_usuarios.f1004_email AS f_email,
    t1004_usuarios.f1004_clave AS f_clave,
    t1000_perfiles.f1000_nombre AS f_perfil,
        CASE
            WHEN (t1004_usuarios.f1004_ind_activo = 0) THEN 'Inactivo'::text
            ELSE 'Activo'::text
        END AS f_activo
   FROM ((public.t1004_usuarios
     JOIN public.t1003_profesion ON ((t1004_usuarios.f1004_id_profesion_t1003 = t1003_profesion.f1003_id)))
     JOIN public.t1000_perfiles ON ((t1004_usuarios.f1004_id_perfil_t1000 = t1000_perfiles.f1000_id)));


ALTER TABLE public.v2000_usuarios_info OWNER TO postgres;

--
-- Name: f_obtener_usuarios(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_obtener_usuarios() RETURNS SETOF public.v2000_usuarios_info
    LANGUAGE plpgsql
    AS $$
    DECLARE
      r v2000_usuarios_info%rowtype;
	  err_context text;
    BEGIN
   FOR r IN SELECT * FROM v2000_usuarios_info
    LOOP
        RETURN NEXT r;
    END LOOP;
    RETURN;
	  
	 EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RAISE INFO 'Error Context:%', err_context;
    END
$$;


ALTER FUNCTION public.f_obtener_usuarios() OWNER TO postgres;

--
-- Name: f_validar_autenticacion(json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_validar_autenticacion(in_json_txt json) RETURNS integer
    LANGUAGE plpgsql
    AS $$
        DECLARE
            err_context TEXT;
            v_err_code INTEGER := 0; /*0 inactivo, 1 no existe, 2 datos incorrectos, 3 existe, activo y correcto*/
            v_email TEXT;
            v_clave TEXT;
            v_activo INTEGER;
            CONST_INACTIVO INTEGER := 0;        

    BEGIN
	
	   SELECT email 
            INTO v_email 
            FROM json_to_record(in_json_txt) 
                AS x(email text);
        
        IF EXISTS (

            SELECT  1 
            FROM    t1004_usuarios
            WHERE   f1004_email = v_email

        ) THEN
            SELECT MD5(clave)
                INTO v_clave 
                FROM json_to_record(in_json_txt) 
                    AS x(clave text);

            IF EXISTS (
                SELECT  1 
                    FROM    t1004_usuarios
                    WHERE   f1004_email = v_email
                    AND     f1004_clave = v_clave
            ) THEN
                SELECT f1004_ind_activo
                    INTO v_activo
                    FROM t1004_usuarios
                    WHERE   f1004_email = v_email
                    AND     f1004_clave = v_clave;

                    IF (v_activo = CONST_INACTIVO) THEN
                        v_err_code := 0;
                    ELSE
                        v_err_code := 3;
                    END IF;
            ELSE
                v_err_code := 2;
            END IF;
           
        ELSE
            v_err_code := 1;
        END IF;

        RETURN v_err_code;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_validar_autenticacion(in_json_txt json) OWNER TO postgres;

--
-- Name: f_validar_crear_perfil(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_validar_crear_perfil(in_nombre_perfil text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context text;
        v_err_code integer := 0; /*0 no existe, 1 existe*/

    BEGIN

        IF EXISTS 
        (
            SELECT 1 
            FROM    t1000_perfiles
            WHERE   f1000_nombre = in_nombre_perfil

        ) THEN
            v_err_code := 1;
        ELSE
            v_err_code := 0;
        END IF;

        RETURN v_err_code;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_validar_crear_perfil(in_nombre_perfil text) OWNER TO postgres;

--
-- Name: f_validar_evento(integer, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_validar_evento(in_id_usuario_asignado integer, in_fecha_inicial timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context text;
        v_err_code integer := 0; /*0 no existe, 1 existe*/
		CONST_ACTIVO INTEGER := 1;

BEGIN

	IF EXISTS 
	(
		SELECT 1
		FROM t1006_eventos AS t
		WHERE in_fecha_inicial BETWEEN t.f1006_fecha_iso8601_inicial AND t.f1006_fecha_iso8601_final
		AND t.f1006_id_usuario_asignado_t1004 = in_id_usuario_asignado
		AND f1006_ind_estado = CONST_ACTIVO
	) THEN
    	v_err_code := 1;
  	ELSE
    	v_err_code := 0;
  	END IF;
			

    RETURN v_err_code;

    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RAISE INFO 'Error Context:%', err_context;

END
$$;


ALTER FUNCTION public.f_validar_evento(in_id_usuario_asignado integer, in_fecha_inicial timestamp without time zone) OWNER TO postgres;

--
-- Name: f_validar_evento_actualizar(integer, timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_validar_evento_actualizar(in_id_usuario_asignado integer, in_fecha_inicial timestamp without time zone, in_id_evento integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context text;
        v_err_code integer := 0; /*0 no existe, 1 existe*/
		CONST_ACTIVO INTEGER := 1;

BEGIN

	IF EXISTS 
	(
		SELECT 1
		FROM t1006_eventos AS t
		WHERE t.f1006_fecha_iso8601_inicial = in_fecha_inicial
		AND t.f1006_id_usuario_asignado_t1004 = in_id_usuario_asignado
		AND t.f1006_id <> in_id_evento
		AND f1006_ind_estado = CONST_ACTIVO
	) THEN
    	v_err_code := 1;
  	ELSE
    	v_err_code := 0;
  	END IF;
			

    RETURN v_err_code;

    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RAISE INFO 'Error Context:%', err_context;

END
$$;


ALTER FUNCTION public.f_validar_evento_actualizar(in_id_usuario_asignado integer, in_fecha_inicial timestamp without time zone, in_id_evento integer) OWNER TO postgres;

--
-- Name: f_validar_perfil_ext(json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_validar_perfil_ext(in_json_txt json) RETURNS integer
    LANGUAGE plpgsql
    AS $$
        DECLARE
            err_context text;
            v_err_code integer := 0; /*0 no existe, 1 existe*/
            v_id_perfil INTEGER;
            v_id_permiso INTEGER;

    BEGIN
        SELECT id_perfil
            INTO v_id_perfil 
            FROM json_to_record(in_json_txt) 
                AS x(id_perfil INTEGER);

        SELECT id_permiso
            INTO v_id_permiso 
            FROM json_to_record(in_json_txt) 
                AS x(id_permiso INTEGER);

        IF EXISTS 
        (
            SELECT 1 
            FROM    t1002_perfil_extendido
            WHERE   f1002_id_perfil_t1000  = v_id_perfil
            AND     f1002_id_permiso_t1001 = v_id_permiso

        ) THEN
            v_err_code := 1;
        ELSE
            v_err_code := 0;
        END IF;

        RETURN v_err_code;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_validar_perfil_ext(in_json_txt json) OWNER TO postgres;

--
-- Name: f_validar_usuario_db(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_validar_usuario_db(in_email_text text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
        DECLARE
            err_context text;
            v_err_code integer := 0; /*0 no existe, 1 existe*/

    BEGIN

        IF EXISTS 
        (
            SELECT 1 
            FROM t1004_usuarios
            WHERE f1004_email = in_email_text

        ) THEN
            v_err_code := 1;
        ELSE
            v_err_code := 0;
        END IF;

        RETURN v_err_code;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$$;


ALTER FUNCTION public.f_validar_usuario_db(in_email_text text) OWNER TO postgres;

--
-- Name: f_validar_usuario_email_actualizar(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_validar_usuario_email_actualizar(in_id_usuario integer, in_email_text text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context text;
        v_err_code integer := 0; /*0 no existe, 1 existe*/

BEGIN

	IF EXISTS 
	(
		SELECT 1
		FROM t1004_usuarios AS t
		WHERE t.f1004_email = in_email_text
		AND t.f1004_id <> in_id_usuario
	) THEN
    	v_err_code := 1;
  	ELSE
    	v_err_code := 0;
  	END IF;
			

    RETURN v_err_code;

    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RAISE INFO 'Error Context:%', err_context;

END
$$;


ALTER FUNCTION public.f_validar_usuario_email_actualizar(in_id_usuario integer, in_email_text text) OWNER TO postgres;

--
-- Name: f_verificar_permiso_usuario(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_verificar_permiso_usuario(in_id_perfil integer, in_id_permiso integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	DECLARE
		err_context text;
        v_err_code integer := 0; /*0 no existe, 1 existe*/

BEGIN

	IF EXISTS 
	(
		SELECT 1 FROM(
				SELECT f1002_id_permiso_t1001 AS f_id_permisos
					FROM t1000_perfiles
					INNER JOIN t1002_perfil_extendido
					ON f1000_id = f1002_id_perfil_t1000
					WHERE f1000_id = in_id_perfil
			) AS t_permisos
		WHERE t_permisos.f_id_permisos = in_id_permiso
	) THEN
    	v_err_code := 1;
  	ELSE
    	v_err_code := 0;
  	END IF;
			

    RETURN v_err_code;

    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RAISE INFO 'Error Context:%', err_context;

END
$$;


ALTER FUNCTION public.f_verificar_permiso_usuario(in_id_perfil integer, in_id_permiso integer) OWNER TO postgres;

--
-- Name: t1000_perfiles_f1000_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t1000_perfiles_f1000_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t1000_perfiles_f1000_id_seq OWNER TO postgres;

--
-- Name: t1000_perfiles_f1000_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t1000_perfiles_f1000_id_seq OWNED BY public.t1000_perfiles.f1000_id;


--
-- Name: t1001_permisos_f1001_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t1001_permisos_f1001_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t1001_permisos_f1001_id_seq OWNER TO postgres;

--
-- Name: t1001_permisos_f1001_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t1001_permisos_f1001_id_seq OWNED BY public.t1001_permisos.f1001_id;


--
-- Name: t1002_perfil_extendido_f1002_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t1002_perfil_extendido_f1002_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t1002_perfil_extendido_f1002_id_seq OWNER TO postgres;

--
-- Name: t1002_perfil_extendido_f1002_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t1002_perfil_extendido_f1002_id_seq OWNED BY public.t1002_perfil_extendido.f1002_id;


--
-- Name: t1003_profesion_f1003_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t1003_profesion_f1003_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t1003_profesion_f1003_id_seq OWNER TO postgres;

--
-- Name: t1003_profesion_f1003_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t1003_profesion_f1003_id_seq OWNED BY public.t1003_profesion.f1003_id;


--
-- Name: t1004_usuarios_f1004_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t1004_usuarios_f1004_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t1004_usuarios_f1004_id_seq OWNER TO postgres;

--
-- Name: t1004_usuarios_f1004_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t1004_usuarios_f1004_id_seq OWNED BY public.t1004_usuarios.f1004_id;


--
-- Name: t1005_imagenes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t1005_imagenes (
    f1005_ts timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    f1005_id integer NOT NULL,
    f1005_nombre character varying(100) NOT NULL,
    f1005_descripcion character varying(100),
    f1005_data bytea NOT NULL
);


ALTER TABLE public.t1005_imagenes OWNER TO postgres;

--
-- Name: t1005_imagenes_f1005_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t1005_imagenes_f1005_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t1005_imagenes_f1005_id_seq OWNER TO postgres;

--
-- Name: t1005_imagenes_f1005_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t1005_imagenes_f1005_id_seq OWNED BY public.t1005_imagenes.f1005_id;


--
-- Name: t1006_eventos_f1006_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.t1006_eventos_f1006_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t1006_eventos_f1006_id_seq OWNER TO postgres;

--
-- Name: t1006_eventos_f1006_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.t1006_eventos_f1006_id_seq OWNED BY public.t1006_eventos.f1006_id;


--
-- Name: v2003_eventos_filtro; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v2003_eventos_filtro AS
 SELECT eventos.f1006_titulo AS title,
    eventos.f1006_descripcion AS "desc",
    eventos.f1006_fecha_iso8601_inicial AS start,
    eventos.f1006_fecha_iso8601_final AS "end",
        CASE
            WHEN (eventos.f1006_ind_todo_el_dia = 0) THEN false
            ELSE true
        END AS allday,
    creador.f1004_id AS f_creado_por,
    asignado.f1004_id AS f_asignado_a
   FROM ((public.t1006_eventos eventos
     LEFT JOIN public.t1004_usuarios creador ON ((eventos.f1006_id_usuario_asignado_t1004 = creador.f1004_id)))
     LEFT JOIN public.t1004_usuarios asignado ON ((eventos.f1006_id_usuario_creador_t1004 = asignado.f1004_id)));


ALTER TABLE public.v2003_eventos_filtro OWNER TO postgres;

--
-- Name: t1000_perfiles f1000_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1000_perfiles ALTER COLUMN f1000_id SET DEFAULT nextval('public.t1000_perfiles_f1000_id_seq'::regclass);


--
-- Name: t1001_permisos f1001_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1001_permisos ALTER COLUMN f1001_id SET DEFAULT nextval('public.t1001_permisos_f1001_id_seq'::regclass);


--
-- Name: t1002_perfil_extendido f1002_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1002_perfil_extendido ALTER COLUMN f1002_id SET DEFAULT nextval('public.t1002_perfil_extendido_f1002_id_seq'::regclass);


--
-- Name: t1003_profesion f1003_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1003_profesion ALTER COLUMN f1003_id SET DEFAULT nextval('public.t1003_profesion_f1003_id_seq'::regclass);


--
-- Name: t1004_usuarios f1004_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1004_usuarios ALTER COLUMN f1004_id SET DEFAULT nextval('public.t1004_usuarios_f1004_id_seq'::regclass);


--
-- Name: t1005_imagenes f1005_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1005_imagenes ALTER COLUMN f1005_id SET DEFAULT nextval('public.t1005_imagenes_f1005_id_seq'::regclass);


--
-- Name: t1006_eventos f1006_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1006_eventos ALTER COLUMN f1006_id SET DEFAULT nextval('public.t1006_eventos_f1006_id_seq'::regclass);


--
-- Data for Name: t1000_perfiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t1000_perfiles (f1000_ts, f1000_id, f1000_nombre, f1000_descripcion) FROM stdin;
2020-04-12 14:26:44.068995	3	Perfil Admin	Perfil principal para administradores
2020-04-24 09:08:22.563417	13	perfil colaborador	Perfil principal para colaboradores
\.


--
-- Data for Name: t1001_permisos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t1001_permisos (f1001_ts, f1001_id, f1001_nombre, f1001_descripcion) FROM stdin;
2020-04-11 18:24:27.54707	2	CREAR_USUARIOS	CREAR_USUARIO
2020-05-20 19:44:23.517714	4	CREAR_CITAS	CREAR_CITAS
2020-05-20 19:44:23.517714	5	EDITAR_CITAS	EDITAR_CITAS
2020-05-20 19:44:23.517714	6	CANCELAR_CITAS	CANCELAR_CITAS
2020-05-20 19:44:23.517714	8	EDITAR_USUARIOS	EDITAR_USUARIOS
2020-05-20 19:44:23.517714	9	INACTIVAR_USUARIOS	INACTIVAR_USUARIOS
2020-05-20 19:44:23.517714	10	CREAR_PERFIL	CREAR_PERFIL
2020-05-20 20:52:08.908259	12	ACTIVAR_USUARIOS	ACTIVAR_USUARIOS
2020-05-20 20:52:21.198692	13	ACTIVAR_CITAS	ACTIVAR_CITAS
\.


--
-- Data for Name: t1002_perfil_extendido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t1002_perfil_extendido (f1002_ts, f1002_id, f1002_id_perfil_t1000, f1002_id_permiso_t1001) FROM stdin;
2020-05-20 20:10:24.312378	72	3	2
2020-05-20 20:27:39.537334	74	13	4
2020-05-20 20:38:54.915265	75	3	4
2020-05-20 20:56:02.740089	76	3	6
2020-05-20 21:06:49.849694	78	3	8
2020-05-20 21:08:38.798698	79	3	9
2020-05-20 21:14:12.578097	80	3	10
2020-05-20 21:18:23.540577	81	3	13
2020-05-20 21:19:19.167825	82	3	12
2020-05-23 15:43:31.747626	102	3	5
\.


--
-- Data for Name: t1003_profesion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t1003_profesion (f1003_ts, f1003_id, f1003_nombre, f1003_descripcion) FROM stdin;
2020-04-08 22:08:38.092219	1	Colaborador	Colaborador
2020-04-18 16:10:50.996103	2	Administrador	Administrador
\.


--
-- Data for Name: t1004_usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t1004_usuarios (f1004_ts, f1004_id, f1004_nombre, f1004_apellido, f1004_fecha_nacimiento, f1004_id_profesion_t1003, f1004_email, f1004_clave, f1004_id_perfil_t1000, f1004_ind_activo) FROM stdin;
2020-04-11 15:33:59.234053	52	Administrador	Spa	2020-02-04	2	admin@gmail.com	202cb962ac59075b964b07152d234b70	3	1
2020-04-24 21:49:05.761153	56	Colaborador	Spa	1999-02-04	1	colaborador@gmail.com	202cb962ac59075b964b07152d234b70	13	1
\.


--
-- Data for Name: t1005_imagenes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t1005_imagenes (f1005_ts, f1005_id, f1005_nombre, f1005_descripcion, f1005_data) FROM stdin;
\.


--
-- Data for Name: t1006_eventos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.t1006_eventos (f1006_ts, f1006_id, f1006_titulo, f1006_descripcion, f1006_fecha_iso8601_inicial, f1006_fecha_iso8601_final, f1006_ind_todo_el_dia, f1006_id_usuario_creador_t1004, f1006_id_usuario_asignado_t1004, f1006_ind_estado) FROM stdin;
2020-05-23 22:34:29.614371	66	prueba 2	prueba 2	2020-05-23 18:34:00	2020-05-23 19:34:00	0	52	56	1
2020-05-23 22:35:35.386537	67	prueba 3	prueba 3	2020-05-24 08:34:53	2020-05-24 10:34:53	0	52	56	1
2020-05-23 22:43:55.465919	68	prueba 4 editada	descripcion	2020-05-24 21:30:47	2020-05-24 22:30:47	0	52	56	1
2020-05-23 22:50:31.341901	69	adsfgh	sdfdgdfdg	2020-05-24 16:04:31	2020-05-24 17:49:31	0	52	56	1
2020-05-23 22:51:28.003179	70	sdfghjhk	dgfnvbsfdg	2020-05-26 14:51:06	2020-05-26 15:51:06	0	52	56	1
2020-05-27 10:08:57.061574	71	Prueba	adsfdsd	2020-05-27 10:08:25	2020-05-27 10:08:25	0	52	56	1
2020-05-27 10:10:33.738273	72	aad	ssdsd	2020-05-27 10:10:15	2020-05-27 10:10:15	0	52	52	1
2020-05-27 10:14:55.865826	73	sdfgh	fdgffdgf	2020-05-27 10:13:19	2020-05-27 14:13:19	0	52	56	1
2020-05-27 18:05:28.275071	74	asdfasdsf	dsfgdsfdg	2020-05-27 18:05:05	2020-05-27 20:05:05	0	52	56	1
2020-05-23 22:28:24.472445	65	Prueba	esta es una prueba	2020-05-23 15:27:48	2020-05-23 17:27:48	0	52	52	0
\.


--
-- Name: t1000_perfiles_f1000_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t1000_perfiles_f1000_id_seq', 57, true);


--
-- Name: t1001_permisos_f1001_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t1001_permisos_f1001_id_seq', 13, true);


--
-- Name: t1002_perfil_extendido_f1002_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t1002_perfil_extendido_f1002_id_seq', 130, true);


--
-- Name: t1003_profesion_f1003_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t1003_profesion_f1003_id_seq', 2, true);


--
-- Name: t1004_usuarios_f1004_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t1004_usuarios_f1004_id_seq', 75, true);


--
-- Name: t1005_imagenes_f1005_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t1005_imagenes_f1005_id_seq', 1, false);


--
-- Name: t1006_eventos_f1006_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.t1006_eventos_f1006_id_seq', 74, true);


--
-- Name: t1000_perfiles t1000_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1000_perfiles
    ADD CONSTRAINT t1000_pk PRIMARY KEY (f1000_id);


--
-- Name: t1001_permisos t1001_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1001_permisos
    ADD CONSTRAINT t1001_pk PRIMARY KEY (f1001_id);


--
-- Name: t1002_perfil_extendido t1002_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1002_perfil_extendido
    ADD CONSTRAINT t1002_pk PRIMARY KEY (f1002_id);


--
-- Name: t1003_profesion t1003_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1003_profesion
    ADD CONSTRAINT t1003_pk PRIMARY KEY (f1003_id);


--
-- Name: t1004_usuarios t1004_no_repeat; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1004_usuarios
    ADD CONSTRAINT t1004_no_repeat UNIQUE (f1004_email);


--
-- Name: t1004_usuarios t1004_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1004_usuarios
    ADD CONSTRAINT t1004_pk PRIMARY KEY (f1004_id);


--
-- Name: t1005_imagenes t1005_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1005_imagenes
    ADD CONSTRAINT t1005_pk PRIMARY KEY (f1005_id);


--
-- Name: t1006_eventos t1006_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1006_eventos
    ADD CONSTRAINT t1006_pk PRIMARY KEY (f1006_id);


--
-- Name: t1002_perfil_extendido t1002_fk_t1000; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1002_perfil_extendido
    ADD CONSTRAINT t1002_fk_t1000 FOREIGN KEY (f1002_id_perfil_t1000) REFERENCES public.t1000_perfiles(f1000_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: t1002_perfil_extendido t1002_fk_t1001; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1002_perfil_extendido
    ADD CONSTRAINT t1002_fk_t1001 FOREIGN KEY (f1002_id_permiso_t1001) REFERENCES public.t1001_permisos(f1001_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: t1004_usuarios t1004_fk_t1000; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1004_usuarios
    ADD CONSTRAINT t1004_fk_t1000 FOREIGN KEY (f1004_id_perfil_t1000) REFERENCES public.t1000_perfiles(f1000_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: t1004_usuarios t1004_fk_t1003; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t1004_usuarios
    ADD CONSTRAINT t1004_fk_t1003 FOREIGN KEY (f1004_id_profesion_t1003) REFERENCES public.t1003_profesion(f1003_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

