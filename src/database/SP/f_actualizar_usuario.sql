CREATE OR REPLACE FUNCTION f_actualizar_usuario(in_json_txt JSON,
                                                in_id_usuario INTEGER)
    RETURNS void AS
    $BODY$
	DECLARE
		err_context TEXT;
        v_nombre TEXT;
        v_apellido TEXT;
        -- v_fecha_nacimiento DATE;
        v_id_profesion INTEGER;
        -- v_id_perfil INTEGER;

    BEGIN
        SELECT nombre INTO v_nombre FROM json_to_record(in_json_txt) AS x(nombre TEXT);
        SELECT apellido INTO v_apellido FROM json_to_record(in_json_txt) AS x(apellido TEXT);
        -- SELECT fecha_nacimiento INTO v_fecha_nacimiento FROM json_to_record(in_json_txt) AS x(fecha_nacimiento DATE);
        SELECT id_profesion INTO v_id_profesion FROM json_to_record(in_json_txt) AS x(id_profesion INTEGER);
        -- SELECT id_perfil INTO v_id_perfil FROM json_to_record(in_json_txt) AS x(id_perfil INTEGER);

        UPDATE t1004_usuarios
        SET
            f1004_nombre = v_nombre,
            f1004_apellido = v_apellido,
            -- f1004_fecha_nacimiento = v_fecha_nacimiento,
            f1004_id_profesion_t1003 = v_id_profesion
            -- f1004_id_perfil_t1000 = v_id_perfil
        WHERE f1004_id = in_id_usuario;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'