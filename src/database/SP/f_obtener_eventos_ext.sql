CREATE OR REPLACE FUNCTION f_obtener_eventos_ext()
    RETURNS SETOF v2002_eventos_info AS
    $BODY$
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
$BODY$ LANGUAGE 'plpgsql'
