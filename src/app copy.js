const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
require('dotenv').config()
const app = express();
const authToken = require("./middlewares/auth_token");
const config = require('./config/config')

//SETTINGS
app.set('port', config.API_PORT ||  4000);


//MIDDLEWARES
//se le dice al servidor que debe entender json
//enviar en este caso o entender
app.use(morgan('dev'));
app.use(cors());
// app.use(express.urlencoded({extended:false}));
app.use(express.json());



// app.use(function (req, res, next) {
//     res.header("Access-Control-Allow-Origin", "*");
//     res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
//     next();
// });
// const corsOptions = {
//     origin: 'localhost:3000',
//     optionsSuccessStatus: 200
// }
// app.options('*', cors(corsOptions))
// 
//SETTINGS



//MIDDLEWARES
//se le dice al servidor que debe entender json
//enviar en este caso o entender
// const corsOptions = {
//     origin: true,
//     credentials: true
//   }
// app.options('*', cors(corsOptions));
// app.use(morgan('dev'));
// app.use(express.json());
// app.use(cors(
//     // corsOptions
// ));


// // app.use(cors());
// // app.use(express.urlencoded({extended: false}));
// // app.use(express.json());




// //ROUTES
// //especificamos las urls que la aplicacion de react
// //podra acceder
// app.use(function (req, res, next) { req.headers['if-none-match'] = 'no-match-for-this'; next(); });
// app.use((req, res, next) => {
//     res.header('Access-Control-Allow-Origin', '*');
//     res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
//     res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
//     res.header('Allow', 'GET, POST, OPTIONS, PUT, DELETE');
//     next();
// });


app.use(function (req, res, next) { req.headers['if-none-match'] = 'no-match-for-this'; next(); });
app.use(authToken);
app.use('/api/user', require('./routes/user'));
app.use('/api/user/auth', require('./routes/auth'));
app.use('/api/user/profile', require('./routes/profile'));
app.use('/api/user/events', require('./routes/events'));


// app.set('port', process.env.API_PORT || 4000);

module.exports = app;