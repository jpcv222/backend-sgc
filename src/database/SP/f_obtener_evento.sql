CREATE OR REPLACE FUNCTION f_obtener_evento(in_id_evento INTEGER)
RETURNS SETOF t1006_eventos AS
$BODY$
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
$BODY$ LANGUAGE 'plpgsql'

