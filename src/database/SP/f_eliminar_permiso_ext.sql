CREATE OR REPLACE FUNCTION f_eliminar_permiso_ext(in_id_perfil INTEGER, in_id_permiso INTEGER)
    RETURNS void AS
    $BODY$
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
$BODY$ LANGUAGE 'plpgsql'