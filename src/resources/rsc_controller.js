const connection = require('../database/database');
const rsc = require('./constantes/rsc_server');

const rsc_controller = {};

// Declaramos enumeradores para no crear confusion al leer el codigo
rsc_controller.ESTADO_USUARIO = {
    INACTIVO: 0,
    NO_EXISTE: 1,
    DATOS_INCORRECTOS: 2,
    EXISTE_PERMISO: 1
}

rsc_controller.ESTADO_PERMISO = {
    NO_EXISTE: 0
}

rsc_controller.ESTADO_EVENTO = {
    NO_EXISTE: 0
}

rsc_controller.TIPO_PROFESION = {
    COLABORADOR: 1,
    ADMINISTRADOR: 2

}

// Funcion para obtener el json del recurso para enviar al Cliente 
// el parametro traza sera opcional para cuando se llame un recurso
// de error, para mostrar un mensaje adecuado al cliente pero 
// igual tener una traza del error
rsc_controller.leerRecurso = (keymsg, traza = "") => {
    try {
        let data = {
            id: 0000,
            description: "",
            status: ""
        };
        Object.keys(rsc).forEach(function (key) {
            var value = rsc[key];
            if (value.id == keymsg) {
                if (traza != "") {
                    value.traza = traza;
                    data = value;
                } else {
                    data = value;
                }
            } else {
                return "";
            }

        });
        return data;
    } catch (error) {
        console.log(error);
    }
};

rsc_controller.obtenerEstadoUsuario = async (email) => {
    try {
        const query = {
            text: "select f_validar_usuario_db($1)",
            values: [email]
        };
        await connection.query(query, (err, results) => {
            if (!err) {
                const estadoUsuario = results.rows[0].f_validar_usuario_db;
                return (estadoUsuario == ESTADO_USUARIO.NO_EXISTE) ? true : false;
            } else {
                return false;
            }
        });

    } catch (error) {
        console.log(error);
        return false;
    }
};


rsc_controller.validarPermisoUsuario = (perfil, permiso) => {

    const query = {
        text: "select f_verificar_permiso_usuario($1, $2)",
        values: [perfil, permiso],
    }
    connection.query(query, (err, results) => {
        if (!err) {
            const permisoUsuario = results.rows[0].f_verificar_permiso_usuario;
            // return permisoUsuario == 1 ? { status: true } : { status: false };
             console.log(permisoUsuario == 1 ? {status:true} : {status:false});
        }
        else {
            return err.message;
        }
    });

}


rsc_controller.snooze = ms => new Promise(resolve => setTimeout(resolve, ms));

module.exports = rsc_controller;