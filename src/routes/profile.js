const { Router } = require('express');
const router = Router();

const profileController = require('../controllers/profile_controller');

router.route('/getProfiles')
    //obtener datos
    .get(profileController.getProfiles)
router.route('/getPermission/:id')
    //obtener permisos por perfil
    .get(profileController.getPermissions)
router.route('/createProfile')
    //crear perfil
    .post(profileController.createProfile)
router.route('/createProfileExt')
    //crear perfil con permiso
    .post(profileController.createProfileExt)
router.route('/deletePermisoExt')
    //eliminar  permiso de perfil
    .delete(profileController.deletePermisoExt)


module.exports = router;