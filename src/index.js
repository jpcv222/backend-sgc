const app = require('./app');
require('./database/database');

async function main() {
    //app.listen es un metodo asincrono
    //eso quiere decir que tomara algo de tiempo
    //ejecutarse, y una vez se ejecute se ejecutara el
    await app.listen(app.get('port'));
    console.log(`Server on port ${app.get('port')}`);
}
main();

