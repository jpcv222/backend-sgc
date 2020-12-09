const connection = require('../database/database');
const userController = {};
const rscController = require('../resources/rsc_controller')

// Funcion para obtener usuarios
userController.getUsers = async (req, res) => {
    try {
        const id_usuario = req.params.id;
        if (id_usuario == 9999) {
            const query = {
                text: "select * from f_obtener_usuarios()"
            }
            await connection.query(query, (err, results) => {
                if (!err) {
                    res.status(200).json(results.rows);
                } else {
                    connection.query('ROLLBACK');
                    res.json(rscController.leerRecurso(1000, err.message));
                }
            });
        } else {
            const query = {
                text: "select * from f_obtener_usuario($1)",
                values: [id_usuario]
            }
            await connection.query(query, (err, results) => {
                if (!err) {
                    res.status(200).json(results.rows);
                } else {
                    connection.query('ROLLBACK');
                    res.json(rscController.leerRecurso(1000, err.message));
                }
            });
        }

    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1000, error.message));
    }
}

// funcion para guardar usuarios
userController.createUser = async (req, res) => {
    try {
        const queryValidarUsuario = {
            text: "select * from f_validar_usuario_db($1)",
            values: [req.body.email]
        };
        // Validamos que el email no exista
        await connection.query(queryValidarUsuario, (err, results) => {
            if (!err) {
                const estadoUsuario = results.rows[0].f_validar_usuario_db;
                resultadoValidar = (estadoUsuario != rscController.ESTADO_USUARIO.NO_EXISTE) ? true : false;
                if (resultadoValidar) {
                    const newUser = req.body;
                    const query = {
                        text: "select * from f_insertar_usuario($1)",
                        values: [newUser]
                    };
                    connection.query(query, (err, results) => {
                        if (!err) {
                            res.json(rscController.leerRecurso(1002));

                        } else {
                            connection.query('ROLLBACK');
                            res.json(rscController.leerRecurso(1003, err.message));
                        }
                    });
                } else {
                    res.json(rscController.leerRecurso(1004));
                }
            } else {
                res.json(rscController.leerRecurso(1003, err.message));
            }
        });


    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1003, error.message));
    }
}

userController.updateUser = async (req, res) => {
    try {
        const id_usuario = req.params.id;
        const newData = req.body;

        const query = {
            text: "select * from f_actualizar_usuario($1,$2)",
            values: [newData, id_usuario]
        }
        await connection.query(query, (err, results) => {
            if (!err) {
                res.json(rscController.leerRecurso(1018));
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1019, err.message));
            }
        });


    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1019, error.message));
    }
}

userController.updateUserPass = async (req, res) => {
    try {
        const id_usuario = req.params.id;
        const clave = req.body.clave;

        const query = {
            text: "select * from f_actualizar_usuario_clave($1,$2)",
            values: [clave, id_usuario]
        }
        await connection.query(query, (err, results) => {
            if (!err) {
                res.json(rscController.leerRecurso(1021));
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1020, err.message));
            }
        });


    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1020, error.message));
    }
}

userController.updateUserEmail = async (req, res) => {
    try {
        const id_usuario = req.params.id;
        const email = req.body.email;

        const queryValidarUsuario = {
            text: "select * from f_validar_usuario_email_actualizar($1,$2)",
            values: [id_usuario, email]
        };
        // Validamos que el email no exista
        await connection.query(queryValidarUsuario, (err, results) => {
            if (!err) {
                const estadoUsuario = results.rows[0].f_validar_usuario_email_actualizar;
                const resultadoValidar = (estadoUsuario != rscController.ESTADO_USUARIO.NO_EXISTE) ? true : false;

                if (resultadoValidar) {
                    const query = {
                        text: "select * from f_actualizar_usuario_email($1,$2)",
                        values: [email, id_usuario]
                    }
                     connection.query(query, (err, results) => {
                        if (!err) {
                            res.json(rscController.leerRecurso(1023));
                        } else {
                            connection.query('ROLLBACK');
                            res.json(rscController.leerRecurso(1022, err.message));
                        }
                    });
                } else {
                    res.json(rscController.leerRecurso(1004));
                }
            } else {
                res.json(rscController.leerRecurso(1022, err.message));
            }
        });

    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1022, error.message));
    }
}

userController.deleteUser = async (req, res) => {
    try {
        const id_usuario = req.body.id;

        const query = {
            text: "select * from f_eliminar_usuario($1)",
            values: [id_usuario]
        }
        await connection.query(query, (err, results) => {
            if (!err) {
                res.json(rscController.leerRecurso(1025));
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1024, err.message));
            }
        });


    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1024, error.message));
    }
}

userController.activateUser = async (req, res) => {
    try {
        const id_usuario = req.body.id;

        const query = {
            text: "select * from f_activar_usuario($1)",
            values: [id_usuario]
        }
        await connection.query(query, (err, results) => {
            if (!err) {
                res.json(rscController.leerRecurso(1027));
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1026, err.message));
            }
        });

    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1026, error.message));
    }
}

userController.updateUserPerfil = async (req, res) => {
    try {
        const id_usuario = req.body.id_usuario;
        const id_perfil = req.body.id_perfil;
        const query = {
            text: "select * from f_actualizar_usuario_perfil($1,$2)",
            values: [id_perfil, id_usuario]
        }
        await connection.query(query, (err, results) => {
            if (!err) {
                res.json(rscController.leerRecurso(1031));
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1032, err.message));
            }
        });

    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1032, error.message));
    }
}

// Funcion para obtener porfesiones
userController.getProfesiones = async (req, res) => {
    try {

        const query = {
            text: "select * from f_obtener_profesiones()"
        }
        await connection.query(query, (err, results) => {
            if (!err) {
                res.status(200).json(results.rows);
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1033, err.message));
            }
        });

    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1033, error.message));
    }
}


module.exports = userController;