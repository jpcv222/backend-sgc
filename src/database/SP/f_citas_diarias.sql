CREATE OR REPLACE FUNCTION f_citas_diarias()
RETURNS SETOF t1006_eventos AS
$BODY$
DECLARE
    reg RECORD;
	err_context text;
    CONST_ACTIVO INTEGER := 1;   

BEGIN

    FOR REG IN
        SELECT  *
        FROM    t1006_eventos
        WHERE   (date(f1006_fecha_iso8601_inicial) = now()::date
        OR      date(f1006_fecha_iso8601_final) = now()::date)
        AND     f1006_ind_estado = CONST_ACTIVO
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