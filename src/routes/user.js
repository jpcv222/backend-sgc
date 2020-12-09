const { Router } = require('express');
const router = Router();

const userController = require('../controllers/user_controller');

router.route('/getUsers/:id')
    //obtener datos
    .get(userController.getUsers)

router.route('/getProfesiones')
    //obtener profesiones
    .get(userController.getProfesiones)

router.route('/createUser')
    //crear usuario
    .post(userController.createUser)

router.route('/updateUser/:id')
    //actualizar usuario
    .post(userController.updateUser)

router.route('/updateUserPass/:id')
    //actualizar contraseña usuario
    .post(userController.updateUserPass)

router.route('/updateUserEmail/:id')
    //actualizar email usuario
    .post(userController.updateUserEmail)

router.route('/deleteUser')
    //actualizar indicador activo usuario
    .post(userController.deleteUser)

router.route('/activateUser')
    //actualizar indicador activo usuario
    .post(userController.activateUser)

router.route('/updateUserPerfil')
    //actualizar perfil usuario
    .post(userController.updateUserPerfil)

module.exports = router;