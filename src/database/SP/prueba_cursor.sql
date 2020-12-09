create or replace function get_test_(ref refcursor)
returns refcursor as
$BODY$
DECLARE
    reg RECORD;
	err_context text;
BEGIN	
	OPEN ref FOR
	SELECT eventos.f1006_ts AS f_fecha_creacion,
    eventos.f1006_id AS f_id,
    eventos.f1006_titulo AS title,
    eventos.f1006_descripcion AS "desc",
    eventos.f1006_fecha_iso8601_inicial AS start,
    eventos.f1006_fecha_iso8601_final AS "end",
        CASE
            WHEN eventos.f1006_ind_todo_el_dia = 0 THEN 'No'::text
            ELSE 'Si'::text
        END AS allday,
    creador.f1004_nombre AS f_creado_por,
    asignado.f1004_nombre AS f_asignado_a,
        CASE
            WHEN eventos.f1006_ind_estado = 0 THEN 'Cancelado'::text
            ELSE 'Activo'::text
        END AS estado
   FROM t1006_eventos eventos
     LEFT JOIN t1004_usuarios creador ON eventos.f1006_id_usuario_asignado_t1004 = creador.f1004_id
     LEFT JOIN t1004_usuarios asignado ON eventos.f1006_id_usuario_creador_t1004 = asignado.f1004_id;
    RETURN ref;   
		EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
END
$BODY$ LANGUAGE 'plpgsql';


   SELECT get_test_('eventos_cur');
 
   FETCH ALL IN "eventos_cur";


