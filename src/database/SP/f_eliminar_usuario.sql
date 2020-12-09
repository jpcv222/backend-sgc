CREATE OR REPLACE FUNCTION f_eliminar_usuario(in_id_usuario INTEGER)
    RETURNS void AS
    $BODY$
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
$BODY$ LANGUAGE 'plpgsql'