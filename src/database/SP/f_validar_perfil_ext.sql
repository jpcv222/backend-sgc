CREATE OR REPLACE FUNCTION f_validar_perfil_ext(in_json_txt JSON)
    RETURNS integer
    AS
    $BODY$
        DECLARE
            err_context text;
            v_err_code integer := 0; /*0 no existe, 1 existe*/
            v_id_perfil INTEGER;
            v_id_permiso INTEGER;

    BEGIN
        SELECT id_perfil
            INTO v_id_perfil 
            FROM json_to_record(in_json_txt) 
                AS x(id_perfil INTEGER);

        SELECT id_permiso
            INTO v_id_permiso 
            FROM json_to_record(in_json_txt) 
                AS x(id_permiso INTEGER);

        IF EXISTS 
        (
            SELECT 1 
            FROM    t1002_perfil_extendido
            WHERE   f1002_id_perfil_t1000  = v_id_perfil
            AND     f1002_id_permiso_t1001 = v_id_permiso

        ) THEN
            v_err_code := 1;
        ELSE
            v_err_code := 0;
        END IF;

        RETURN v_err_code;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'