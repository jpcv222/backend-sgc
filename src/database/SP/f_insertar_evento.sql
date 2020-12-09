CREATE OR REPLACE FUNCTION f_insertar_evento(in_json_txt JSON)
    RETURNS void AS
    $BODY$
	DECLARE
		err_context text;

    BEGIN

        INSERT INTO t1006_eventos(
            f1006_titulo,
            f1006_descripcion,
            f1006_fecha_iso8601_inicial,
            f1006_fecha_iso8601_final,
            f1006_ind_todo_el_dia,
            f1006_id_usuario_creador_t1004,
            f1006_id_usuario_asignado_t1004
        )
        SELECT
            titulo,
            descripcion,
            fecha_inicial,
            fecha_final,
            ind_todo_el_dia,
            id_creador,
            id_asignado
        FROM json_to_record(in_json_txt) AS x( 
            titulo TEXT,
            descripcion TEXT,
            fecha_inicial TIMESTAMP,
            fecha_final TIMESTAMP,
            ind_todo_el_dia INTEGER,
            id_creador INTEGER,
            id_asignado INTEGER
        );

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'