const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
require('dotenv').config()
const authToken = require("./middlewares/auth_token");
const config = require('./config/config')
const bodyParser = require('body-parser');
const app = express();

app.use(cors(config.application.cors.server));
// app.use(cors({
//     origin: ['*'],
//     credentials: true
// }));
app.use(express.urlencoded({extended:false}));
app.use(express.json());

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
    res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
    res.header('Allow', 'GET, POST, OPTIONS, PUT, DELETE');
    next();
});

app.use(authToken);
app.use('/api/user', require('./routes/user'));
app.use('/api/user/auth', require('./routes/auth'));
app.use('/api/user/profile', require('./routes/profile'));
app.use('/api/user/events', require('./routes/events'));

//SETTINGS
app.set('port', config.API_PORT || 4000);

module.exports = app;