CREATE OR REPLACE FUNCTION f_eliminar_evento(in_id_evento INTEGER)
    RETURNS void AS
    $BODY$
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
$BODY$ LANGUAGE 'plpgsql'