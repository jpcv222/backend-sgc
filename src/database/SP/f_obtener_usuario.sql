CREATE OR REPLACE FUNCTION f_obtener_usuario(in_id_usuario INTEGER)
RETURNS SETOF t1004_usuarios AS
$BODY$
DECLARE
    reg RECORD;
	err_context text;

BEGIN
    FOR REG IN
        SELECT *
        FROM t1004_usuarios
        WHERE f1004_id = in_id_usuario
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

