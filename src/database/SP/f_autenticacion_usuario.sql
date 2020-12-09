CREATE OR REPLACE FUNCTION f_autenticacion_usuario(in_json_txt JSON)
RETURNS SETOF t1004_usuarios AS
$BODY$
DECLARE
    reg RECORD;
	err_context text;
    v_email text;
    v_clave text;

BEGIN
    SELECT email 
        INTO v_email 
        FROM json_to_record(in_json_txt) 
            AS x(email text);
    SELECT MD5(clave)
        INTO v_clave 
        FROM json_to_record(in_json_txt) 
            AS x(clave text);

    FOR REG IN
        SELECT *
        FROM t1004_usuarios
        WHERE   f1004_email = v_email
        AND     f1004_clave = v_clave
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

