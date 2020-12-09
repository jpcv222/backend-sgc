CREATE OR REPLACE FUNCTION f_verificar_permiso_usuario(in_id_perfil integer,
											           in_id_permiso integer) RETURNS integer
    AS
$BODY$
	DECLARE
		err_context text;
        v_err_code integer := 0; /*0 no existe, 1 existe*/

BEGIN

	IF EXISTS 
	(
		SELECT 1 FROM(
				SELECT f1002_id_permiso_t1001 AS f_id_permisos
					FROM t1000_perfiles
					INNER JOIN t1002_perfil_extendido
					ON f1000_id = f1002_id_perfil_t1000
					WHERE f1000_id = in_id_perfil
			) AS t_permisos
		WHERE t_permisos.f_id_permisos = in_id_permiso
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