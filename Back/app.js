//Librerias
const express = require('express')
const bodyParser = require('body-parser');

//Declaración
const app = express()
require('dotenv').config()

//Declaración de variables de peticiones
app.use(express.json({ limit: '20mb' }));
app.use(express.urlencoded({ limit: '20mb', extended: true }));

//Configuracion rutas
const routes = require('./rutas/rutas');
app.use('/', routes);

//Arranque servidor
app.listen(process.env.puerto, () => 
{
    try{
        console.log("Servidor en el puerto " + 5000);
    }catch(e){
        console.log(e);
    }
});