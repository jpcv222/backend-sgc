const { Router } = require('express');
const router = Router();

const eventController = require('../controllers/event_controller');

router.route('/getEvents/:id')
    //obtener datos
    .post(eventController.getEvents)

router.route('/getEventsFilter')
    //obtener datos con filtro
    .post(eventController.getEventsFilter)

router.route('/createEvent')
    //obtener datos con filtro
    .post(eventController.createEvent)

router.route('/deleteEvent')
    //obtener datos con filtro
    .post(eventController.deleteEvent)

router.route('/updateEvent/:id')
    //obtener datos con filtro
    .post(eventController.updateEvent)

router.route('/activateEvent')
    //obtener datos con filtro
    .post(eventController.activateEvent)



module.exports = router;