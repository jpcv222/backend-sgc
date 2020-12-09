CREATE OR REPLACE FUNCTION f_actualizar_evento(in_json_txt JSON,
                                                in_id_evento INTEGER)
    RETURNS void AS
    $BODY$
	DECLARE
		err_context TEXT;
        v_titulo TEXT;
        v_descripcion TEXT;
        v_fecha_inicial TIMESTAMP;
        v_fecha_final TIMESTAMP;
        v_ind_todo_el_dia INTEGER;
        v_id_asignado INTEGER;

    BEGIN
        SELECT titulo INTO v_titulo FROM json_to_record(in_json_txt) AS x(titulo TEXT);
        SELECT descripcion INTO v_descripcion FROM json_to_record(in_json_txt) AS x(descripcion TEXT);
        SELECT fecha_inicial INTO v_fecha_inicial FROM json_to_record(in_json_txt) AS x(fecha_inicial TIMESTAMP);
        SELECT fecha_final INTO v_fecha_final FROM json_to_record(in_json_txt) AS x(fecha_final TIMESTAMP);
        SELECT ind_todo_el_dia INTO v_ind_todo_el_dia FROM json_to_record(in_json_txt) AS x(ind_todo_el_dia INTEGER);
        SELECT id_asignado INTO v_id_asignado FROM json_to_record(in_json_txt) AS x(id_asignado INTEGER);

        UPDATE t1006_eventos
        SET
            f1006_titulo                    = v_titulo,
            f1006_descripcion               = v_descripcion,
            f1006_fecha_iso8601_inicial     = v_fecha_inicial,
            f1006_fecha_iso8601_final       = v_fecha_final,
            f1006_ind_todo_el_dia           = v_ind_todo_el_dia,
            f1006_id_usuario_asignado_t1004 = v_id_asignado          
        WHERE f1006_id = in_id_evento;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'