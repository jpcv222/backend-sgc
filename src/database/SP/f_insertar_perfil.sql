CREATE OR REPLACE FUNCTION f_insertar_perfil(in_json_txt JSON)
    RETURNS void AS
    $BODY$
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
$BODY$ LANGUAGE 'plpgsql'