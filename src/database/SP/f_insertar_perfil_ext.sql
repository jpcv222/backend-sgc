CREATE OR REPLACE FUNCTION f_insertar_perfil_ext(in_json_txt JSON)
    RETURNS void AS
    $BODY$
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
$BODY$ LANGUAGE 'plpgsql'