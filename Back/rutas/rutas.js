require('dotenv').config();
const fun = require('./funcionalidades');
const express = require('express');
const pool = require('../BD/config');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
var rutas = express.Router();

//BCRYPT 
var saltRounds = parseInt(process.env.hash);

//Rutas
//Prueba
rutas.get('/',  async (req, res) => {
    res.send("Prueba")
})

//Login
rutas.post('/usuarios/ingresar', async (req, res) => {
    try {
        const cuerpo = req.body
        pool.query(`SELECT * FROM PERSONAS WHERE numero_telefono = ${cuerpo.telefono}`, async (error1, resultado) => {
            if (error1) {
                res.json({
                    error: true,
                    descripcion: error1
                })
            } else if (resultado.length > 0 && resultado.length < 2) {
                const hash = await bcrypt.compare(cuerpo.contra, resultado[0].contrasena)
                if (hash) {
                    data = {
                        error: false,
                        numero: cuerpo.telefono
                    }
                    const token = jwt.sign(data, process.env.claveJWT)
                    res.json(token)
                } else {
                    res.json({
                        error: true,
                        descripcion: "Contrasena incorrecta"
                    })
                }
            } else if (resultado.length == 0) {
                res.json({
                    error: true,
                    descripcion: "No se encontro el usuario"
                })
            } else {
                res.json({
                    error: true,
                    descripcion: "Usuario doblemente registrado (ERROR CRITICO)"
                })
            }
        })
    } catch (e) {
        res.json({
            error: true,
            descripcion: e
        })
    }

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