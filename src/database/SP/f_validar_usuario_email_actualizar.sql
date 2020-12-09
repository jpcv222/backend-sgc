CREATE OR REPLACE FUNCTION f_validar_usuario_email_actualizar(in_id_usuario INTEGER,
													          in_email_text TEXT) RETURNS INTEGER
    AS
$BODY$
	DECLARE
		err_context text;
        v_err_code integer := 0; /*0 no existe, 1 existe*/

BEGIN

	IF EXISTS 
	(
		SELECT 1
		FROM t1004_usuarios AS t
		WHERE t.f1004_email = in_email_text
		AND t.f1004_id <> in_id_usuario
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