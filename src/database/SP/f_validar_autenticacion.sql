CREATE OR REPLACE FUNCTION f_validar_autenticacion(in_json_txt JSON)
    RETURNS integer
    AS
    $BODY$
        DECLARE
            err_context TEXT;
            v_err_code INTEGER := 0; /*0 inactivo, 1 no existe, 2 datos incorrectos, 3 existe, activo y correcto*/
            v_email TEXT;
            v_clave TEXT;
            v_activo INTEGER;
            CONST_INACTIVO INTEGER := 0;        

    BEGIN
	
	   SELECT email 
            INTO v_email 
            FROM json_to_record(in_json_txt) 
                AS x(email text);
        
        IF EXISTS (

            SELECT  1 
            FROM    t1004_usuarios
            WHERE   f1004_email = v_email

        ) THEN
            SELECT MD5(clave)
                INTO v_clave 
                FROM json_to_record(in_json_txt) 
                    AS x(clave text);

            IF EXISTS (
                SELECT  1 
                    FROM    t1004_usuarios
                    WHERE   f1004_email = v_email
                    AND     f1004_clave = v_clave
            ) THEN
                SELECT f1004_ind_activo
                    INTO v_activo
                    FROM t1004_usuarios
                    WHERE   f1004_email = v_email
                    AND     f1004_clave = v_clave;

                    IF (v_activo = CONST_INACTIVO) THEN
                        v_err_code := 0;
                    ELSE
                        v_err_code := 3;
                    END IF;
            ELSE
                v_err_code := 2;
            END IF;
           
        ELSE
            v_err_code := 1;
        END IF;

        RETURN v_err_code;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'