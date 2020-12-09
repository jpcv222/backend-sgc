-- ************************FILTROS ADMINISTRADOR*******************
-- FILTRO RANGO DE FECHAS:
SELECT  
		f1006_titulo					AS title,
        f1006_descripcion				AS desc,
        f1006_fecha_iso8601_inicial		AS start,
        f1006_fecha_iso8601_final		AS end,
        CASE
                WHEN
                    (f1006_ind_todo_el_dia) = 0 THEN false
                ELSE true
        END	AS allDay
FROM t1006_eventos 
WHERE f1006_fecha_iso8601_inicial::DATE BETWEEN fecha1 AND fecha2;

-- FILTRO TODOS LOS EVENTOS ASIGNADOS A:
SELECT  
		f1006_titulo					AS title,
        f1006_descripcion				AS desc,
        f1006_fecha_iso8601_inicial		AS start,
        f1006_fecha_iso8601_final		AS end,
        CASE
                WHEN
                    (f1006_ind_todo_el_dia) = 0 THEN false
                ELSE true
        END	AS allDay
FROM t1006_eventos 
WHERE f1006_id_usuario_asignado_t1004 = id_usuario

-- FILTRO TODOS LOS EVENTOS CREADOS POR:
SELECT  
		f1006_titulo					AS title,
        f1006_descripcion				AS desc,
        f1006_fecha_iso8601_inicial		AS start,
        f1006_fecha_iso8601_final		AS end,
        CASE
                WHEN
                    (f1006_ind_todo_el_dia) = 0 THEN false
                ELSE true
        END	AS allDay
FROM t1006_eventos 
WHERE f1006_id_usuario_creador_t1004 = id_usuario
