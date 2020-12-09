const connection = require('../database/database');
const eventController = {};
const rscController = require('../resources/rsc_controller');

eventController.getEvents = async (req, res) => {
    try {
        const id_evento = req.params.id;
        let query = "";
        if (id_evento == 9999) {
            const id_profesion = req.body.id_profesion;
            if (id_profesion == rscController.TIPO_PROFESION.ADMINISTRADOR) {
                query = {
                    text: '    SELECT   ' +
                        '           f1006_ts						AS f_fecha_creacion,  ' +
                        '           f1006_id						AS f_id,  ' +
                        '           f1006_titulo					AS title,  ' +
                        '           f1006_descripcion				AS desc,  ' +
                        '           f1006_fecha_iso8601_inicial		AS start,  ' +
                        '           f1006_fecha_iso8601_final		AS end,  ' +
                        '           CASE  ' +
                        '                   WHEN  ' +
                        '                       (f1006_ind_todo_el_dia) = 0 THEN \'' + 'No' + '\'  ' +
                        '                   ELSE \'' + 'Si' + '\'  ' +
                        '           END	AS allDay,  ' +
                        '           creador.f1004_nombre AS f_creado_por,  ' +
                        '           asignado.f1004_nombre AS f_asignado_a,  ' +
                        '           CASE  ' +
                        '               WHEN  ' +
                        '                   (f1006_ind_estado) = 0 THEN \'' + 'Cancelado' + '\'  ' +
                        '               ELSE \'' + 'Activo' + '\'  ' +
                        '           END	AS Estado  ' +
                        '           FROM t1006_eventos AS eventos  ' +
                        '           LEFT JOIN t1004_usuarios AS creador  ' +
                        '           ON eventos.f1006_id_usuario_creador_t1004 = creador.f1004_id  ' +
                        '           LEFT JOIN t1004_usuarios AS asignado  ' +
                        '          ON eventos.f1006_id_usuario_asignado_t1004 = asignado.f1004_id    '
                }
            } else {
                const id_usuario = req.body.id_usuario;
                console.log(id_usuario)
                query = {
                    text: '    SELECT   ' +
                        '           f1006_ts						AS f_fecha_creacion,  ' +
                        '           f1006_id						AS f_id,  ' +
                        '           f1006_titulo					AS title,  ' +
                        '           f1006_descripcion				AS desc,  ' +
                        '           f1006_fecha_iso8601_inicial		AS start,  ' +
                        '           f1006_fecha_iso8601_final		AS end,  ' +
                        '           CASE  ' +
                        '                   WHEN  ' +
                        '                       (f1006_ind_todo_el_dia) = 0 THEN \'' + 'No' + '\'  ' +
                        '                   ELSE \'' + 'Si' + '\'  ' +
                        '           END	AS allDay,  ' +
                        '           creador.f1004_nombre AS f_creado_por,  ' +
                        '           asignado.f1004_nombre AS f_asignado_a,  ' +
                        '           CASE  ' +
                        '               WHEN  ' +
                        '                   (f1006_ind_estado) = 0 THEN \'' + 'Cancelado' + '\'  ' +
                        '               ELSE \'' + 'Activo' + '\'  ' +
                        '           END	AS Estado  ' +
                        '           FROM t1006_eventos AS eventos  ' +
                        '           LEFT JOIN t1004_usuarios AS creador  ' +
                        '           ON eventos.f1006_id_usuario_creador_t1004 = creador.f1004_id  ' +
                        '           LEFT JOIN t1004_usuarios AS asignado  ' +
                        '          ON eventos.f1006_id_usuario_asignado_t1004 = asignado.f1004_id  ' +
                        '  	WHERE eventos.f1006_id_usuario_asignado_t1004 = ' + id_usuario
                }
            }

            await connection.query(query, (err, results) => {
                if (!err) {
                    res.status(200).json(results.rows);
                } else {
                    connection.query('ROLLBACK');
                    res.json(rscController.leerRecurso(1028, err.message));
                }
            });
        } else {
            query = {
                text: "select * from f_obtener_evento($1)",
                values: [id_evento]
            }
            await connection.query(query, (err, results) => {
                if (!err) {
                    res.status(200).json(results.rows);
                } else {
                    connection.query('ROLLBACK');
                    res.json(rscController.leerRecurso(1028, err.message));
                }
            });
        }

    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1028, error.message));
    }
}

eventController.getEventsFilter = async (req, res) => {
    try {
        let query = "";
        const id_profesion = req.body.id_profesion;
        if (id_profesion == rscController.TIPO_PROFESION.ADMINISTRADOR) {
            query = {
                text: '       SELECT   ' +
                    '           f1006_titulo					AS title,  ' +
                    '   		CASE  ' +
                    '   			WHEN  ' +
                    '   				(f1006_ind_estado) = 0 THEN f1006_descripcion || \'' + ' ' + '\' || \'' + 'Y su estado es cancelado' + '\'  ' +
                    '   			ELSE f1006_descripcion || \'' + ' ' + '\' || \'' + 'Y su estado es activo' + '\'  ' +
                    '           END	AS desc,  ' +
                    '           f1006_fecha_iso8601_inicial		AS start,  ' +
                    '           f1006_fecha_iso8601_final		AS end,  ' +
                    '           CASE  ' +
                    '                   WHEN  ' +
                    '                       (f1006_ind_todo_el_dia) = 0 THEN false  ' +
                    '                   ELSE true  ' +
                    '           END	AS allDay  ' +
                    '          FROM t1006_eventos AS eventos  '
            }
        } else {
            const id_usuario = req.body.id_usuario;
            query = {
                text: '       SELECT   ' +
                    '           f1006_titulo					AS title,  ' +
                    '   		CASE  ' +
                    '   			WHEN  ' +
                    '   				(f1006_ind_estado) = 0 THEN f1006_descripcion || \'' + ' ' + '\' || \'' + 'Y su estado es cancelado' + '\'  ' +
                    '   			ELSE f1006_descripcion || \'' + ' ' + '\' || \'' + 'Y su estado es activo' + '\'  ' +
                    '           END	AS desc,  ' +
                    '           f1006_fecha_iso8601_inicial		AS start,  ' +
                    '           f1006_fecha_iso8601_final		AS end,  ' +
                    '           CASE  ' +
                    '                   WHEN  ' +
                    '                       (f1006_ind_todo_el_dia) = 0 THEN false  ' +
                    '                   ELSE true  ' +
                    '           END	AS allDay  ' +
                    '          FROM t1006_eventos' +
                    '  WHERE f1006_id_usuario_asignado_t1004 =' + id_usuario
            }

        }

        await connection.query(query, (err, results) => {
            if (!err) {
                res.status(200).json(results.rows);
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1028, err.message));
            }
        });


    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1028, error.message));
    }
}

eventController.createEvent = async (req, res) => {
    try {
        const queryValidarEvento = {
            text: "select * from f_validar_evento($1,$2)",
            values: [req.body.id_asignado, req.body.fecha_inicial]
        };
        // Validamos que el evento no exista
        await connection.query(queryValidarEvento, (err, results) => {
            if (!err) {
                const estadoEvento = results.rows[0].f_validar_evento;
                const resultadoValidar = (estadoEvento == rscController.ESTADO_EVENTO.NO_EXISTE) ? true : false;
                if (resultadoValidar) {
                    const newEvent = req.body;
                    const query = {
                        text: "select * from f_insertar_evento($1)",
                        values: [newEvent]
                    };
                    connection.query(query, (err, results) => {
                        if (!err) {
                            res.json(rscController.leerRecurso(1035));

                        } else {
                            connection.query('ROLLBACK');
                            res.json(rscController.leerRecurso(1034, err.message));
                        }
                    });
                } else {
                    res.json(rscController.leerRecurso(1036));
                }
            } else {
                res.json(rscController.leerRecurso(1034, err.message));
            }
        });

    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1034, error.message));
    }
}

eventController.deleteEvent = async (req, res) => {
    try {
        const id_evento = req.body.id;

        const query = {
            text: "select * from f_eliminar_evento($1)",
            values: [id_evento]
        }
        await connection.query(query, (err, results) => {
            if (!err) {
                res.json(rscController.leerRecurso(1038));
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1037, err.message));
            }
        });


    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1037, error.message));
    }
}

eventController.activateEvent = async (req, res) => {
    try {
        const id_evento = req.body.id;

        const query = {
            text: "select * from f_activar_evento($1)",
            values: [id_evento]
        }
        await connection.query(query, (err, results) => {
            if (!err) {
                res.json(rscController.leerRecurso(1042));
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1043, err.message));
            }
        });


    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1037, error.message));
    }
}

eventController.updateEvent = async (req, res) => {
    try {
        const id_evento = req.params.id;
        const queryValidarEvento = {
            text: "select * from f_validar_evento_actualizar($1,$2,$3)",
            values: [req.body.id_asignado, req.body.fecha_inicial, id_evento]
        };
        // Validamos que el evento no exista
        await connection.query(queryValidarEvento, (err, results) => {
            if (!err) {
                const estadoEvento = results.rows[0].f_validar_evento_actualizar;
                console.log(estadoEvento);
                const resultadoValidar = (estadoEvento == rscController.ESTADO_EVENTO.NO_EXISTE) ? true : false;

                if (resultadoValidar) {
                    const newData = req.body;

                    const query = {
                        text: "select * from f_actualizar_evento($1,$2)",
                        values: [newData, id_evento]
                    }
                    connection.query(query, (err, results) => {
                        if (!err) {
                            res.json(rscController.leerRecurso(1039));
                        } else {
                            connection.query('ROLLBACK');
                            res.json(rscController.leerRecurso(1040, err.message));
                        }
                    });
                } else {
                    res.json(rscController.leerRecurso(1036));
                }
            } else {
                res.json(rscController.leerRecurso(1040, err.message));
            }
        });

    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1040, error.message));
    }
}

eventController.traerCitasDiarias = async (req, res) => {
    try {
        
    } catch (error) {
        await connection.query('ROLLBACK');
    }
}


module.exports = eventController;