CREATE OR REPLACE FUNCTION f_insertar_usuario(in_json_txt JSON)
    RETURNS void AS
    $BODY$
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
$BODY$ LANGUAGE 'plpgsql'