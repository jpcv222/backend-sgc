CREATE OR REPLACE FUNCTION f_validar_evento(in_id_usuario_asignado INTEGER,
											in_fecha_inicial TIMESTAMP) RETURNS INTEGER
    AS
$BODY$
	DECLARE
		err_context text;
        v_err_code integer := 0; /*0 no existe, 1 existe*/
		CONST_ACTIVO INTEGER := 1;

BEGIN

	IF EXISTS 
	(
		SELECT 1
		FROM t1006_eventos AS t
		WHERE in_fecha_inicial BETWEEN t.f1006_fecha_iso8601_inicial AND t.f1006_fecha_iso8601_final
		AND t.f1006_id_usuario_asignado_t1004 = in_id_usuario_asignado
		AND f1006_ind_estado = CONST_ACTIVO
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