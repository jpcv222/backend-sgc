CREATE OR REPLACE FUNCTION f_obtener_profesiones()
RETURNS SETOF t1003_profesion AS
$BODY$
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
$BODY$ LANGUAGE 'plpgsql'

