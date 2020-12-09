const connection = require('../database/database');
const profileController = {};
const rscController = require('../resources/rsc_controller');

profileController.getProfiles = async (req, res) => {
    try {
        const query = {
            text: "select * from f_obtener_perfiles()"
        }
        await connection.query(query, (err, results) => {
            if (!err) {
                res.status(200).json(results.rows);
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1011, err.message));
            }
        });
    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1011, error.message));
    }
}

profileController.getPermissions = async (req, res) => {
    try {
        const id_perfil = req.params.id;
        if (id_perfil != 9999) {
            const query = {
                text: "select * from f_obtener_permisos_ext($1)",
                values: [id_perfil]
            }
            await connection.query(query, (err, results) => {
                if (!err) {
                    res.status(200).json(results.rows);
                } else {
                    connection.query('ROLLBACK');
                    res.json(rscController.leerRecurso(1012, err.message));
                }
            });
        } else {
            const query = {
                text: "select * from f_obtener_permisos()"
            }
            await connection.query(query, (err, results) => {
                if (!err) {
                    res.status(200).json(results.rows);
                } else {
                    connection.query('ROLLBACK');
                    res.json(rscController.leerRecurso(1012, err.message));
                }
            });
        }

    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1012, error.message));
    }
}

profileController.createProfile = async (req, res) => {
    try {
        const nombrePerfil = req.body.nombre;
        const perfil = req.body;
        const queryValidarPerfil = {
            text: "select * from f_validar_crear_perfil($1)",
            values: [nombrePerfil]
        };
        // Validamos que el permiso ya no este asiganado
        await connection.query(queryValidarPerfil, (err, results) => {
            if (!err) {
                const estadoPerfil = results.rows[0].f_validar_crear_perfil;
                const resultadoValidar = (estadoPerfil == rscController.ESTADO_PERMISO.NO_EXISTE) ? true : false;
                if (resultadoValidar) {
                    const query = {
                        text: "select * from f_insertar_perfil($1)",
                        values: [perfil]
                    };
                    connection.query(query, (err, results) => {
                        if (!err) {
                            res.json(rscController.leerRecurso(1014));
                        } else {
                            connection.query('ROLLBACK');
                            res.json(rscController.leerRecurso(1013, err.message));
                        }
                    });
                } else {
                    res.json(rscController.leerRecurso(1044));
                }
            } else {
                res.json(rscController.leerRecurso(1013, err.message));
            }
        });


    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1013, error.message));
    }
}

profileController.createProfileExt = async (req, res) => {
    try {
        const datos = req.body;
        console.log(datos);
        const queryValidarUsuario = {
            text: "select * from f_validar_perfil_ext($1)",
            values: [datos]
        };
        // Validamos que el permiso ya no este asiganado
        await connection.query(queryValidarUsuario, (err, results) => {
            if (!err) {
                const estadoPerfil = results.rows[0].f_validar_perfil_ext;
                const resultadoValidar = (estadoPerfil == rscController.ESTADO_PERMISO.NO_EXISTE) ? true : false;
                if (resultadoValidar) {
                    const query = {
                        text: "select * from f_insertar_perfil_ext($1)",
                        values: [datos]
                    };
                    connection.query(query, (err, results) => {
                        if (!err) {
                            res.json(rscController.leerRecurso(1017));
                            

                        } else {
                            connection.query('ROLLBACK');
                            res.json(rscController.leerRecurso(1015, err.message));
                            
                        }
                    });
                } else {
                    res.json(rscController.leerRecurso(1016));
                }

            } else {
                res.json(rscController.leerRecurso(1016, err.message));
                
            }
        });


    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1015, error.message));
    }
}

profileController.deletePermisoExt = async (req, res) => {
    try {
        const perfil = req.body.perfil;
        const permiso = req.body.permiso;

        const query = {
            text: "select * from f_eliminar_permiso_ext($1,$2)",
            values: [perfil, permiso]
        };
        await connection.query(query, (err, results) => {
            if (!err) {
                res.json(rscController.leerRecurso(1029));
            } else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1030, err.message));
            }
        });
    } catch (error) {
        await connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1030, error.message));
    }
}

module.exports = profileController;
