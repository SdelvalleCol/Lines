//Librerias
const express = require('express')
const bodyParser = require('body-parser');

//Declaración
const app = express()
require('dotenv').config()

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

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