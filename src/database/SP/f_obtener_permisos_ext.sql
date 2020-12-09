CREATE OR REPLACE FUNCTION f_obtener_permisos_ext(p_id_perfil INTEGER)
    RETURNS SETOF v2001_permisos_info AS
    $BODY$
        DECLARE
            r v2001_permisos_info%rowtype;
            err_context text;
    BEGIN
        FOR r IN 
            SELECT *
            FROM v2001_permisos_info
            WHERE f_id_pefil = p_id_perfil
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
