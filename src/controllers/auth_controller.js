const connection = require('../database/database');
const authController = {};
const rscController = require('../resources/rsc_controller');
const CONFIG = require("../config/config");
const jwt = require("jsonwebtoken");

// function para la autenticacion

authController.auth = async (req, res) => {
    try {
        const user = req.body;
        const queryValidarUsuario = {
            text: "select * from f_validar_autenticacion($1)",
            values: [user]
        };
        // Validamos que el usuario exista
        connection.query(queryValidarUsuario, async (err, results) => {
            if (!err) {
                const estadoUsuario = results.rows[0].f_validar_autenticacion;
                switch (estadoUsuario) {
                    case rscController.ESTADO_USUARIO.NO_EXISTE:
                        res.json(rscController.leerRecurso(1008));
                        break;
                    case rscController.ESTADO_USUARIO.INACTIVO:
                        res.json(rscController.leerRecurso(1007));
                        break;
                    case rscController.ESTADO_USUARIO.DATOS_INCORRECTOS:
                        res.json(rscController.leerRecurso(1006));
                        break;
                    default:
                        const query = {
                            text: "select * from f_autenticacion_usuario($1)",
                            values: [user]
                        };
                        connection.query(query, (err, results) => {
                            if (!err) {
                                const payload = results.rows[0];
                                jwt.sign(payload, CONFIG.SECRET_KEY, (jwtErr, token) => {
                                    if (!jwtErr) {
                                        res.status(200).json({ token: token });
                                    } else {
                                        console.log("Errrrrr")
                                        res.json(rscController.leerRecurso(1005, jwtErr.message));
                                    }
                                });

                            } else {
                                connection.query('ROLLBACK');
                                res.json(rscController.leerRecurso(1005, err.message));
                                console.log("Errrrrr")
                            }
                        });
                }
            }
            else {
                connection.query('ROLLBACK');
                res.json(rscController.leerRecurso(1005, err.message));
            }
        });

    } catch (error) {
        connection.query('ROLLBACK');
        res.json(rscController.leerRecurso(1005, error.message));
    }

}



module.exports = authController;