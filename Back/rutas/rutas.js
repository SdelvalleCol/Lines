require('dotenv').config();
const express = require('express');
const pool = require('../BD/config');
const bcrypt = require('bcrypt');
var rutas = express.Router();

//BCRYPT 
var saltRounds = parseInt(process.env.hash);

//Rutas

//Prueba
rutas.get('/', (req, res) => {
    res.send("Prueba")
})

//Registrar usuario
rutas.post('/usuarios/registrar', async (req, res) => {
    try {
        const cuerpo = req.body;
        const hash = await bcrypt.hash(cuerpo.contrasena, saltRounds);
        pool.query(`INSERT INTO PERSONAS (numero_telefono,nombre,correo,contrasena,imagen,Cargo_idCargo) VALUES(${cuerpo.numero},'${cuerpo.nombre}','${cuerpo.correo}','${hash}','${cuerpo.imagen}',${cuerpo.cargo})`, (error, resultado) => {
            if (error) {
                res.json({
                    error: true,
                    descripcion: error
                })
            } else {
                res.json({
                    error: false,
                    descripcion: "Se ingreso el usuario"
                })
            }
        })
    } catch (e) {
        res.json(res.json({
            error: true,
            descripcion: e
        }))
    }
})

module.exports = rutas