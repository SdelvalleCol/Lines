//Variables Ocultas
require('dotenv').config();

//Funcionalidades
const fun = require('./funcionalidades');

//Configuracion rutas
const express = require('express');
var rutas = express.Router();

//BD
const pool = require('../BD/config');

//Encriptaciones
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
var saltRounds = parseInt(process.env.hash);

//Otros
const { promisify } = require('util');

//Rutas
//Prueba
rutas.get('/', async (req, res) => {
    res.send("Prueba")
})

//Login
rutas.post('/usuarios/ingresar', async (req, res) => {
    try {
        const cuerpo = req.body
        pool.query(`SELECT * FROM PERSONAS WHERE numero_telefono = ${cuerpo.telefono}`, async (error1, resultado) => {
            if (error1) {
                res.status(404).json({
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
                    res.status(200).json(token)
                } else {
                    res.status(400).json({
                        error: true,
                        descripcion: "Contrasena incorrecta"
                    })
                }
            } else if (resultado.length == 0) {
                res.status(400).json({
                    error: true,
                    descripcion: "No se encontro el usuario"
                })
            } else {
                res.status(400).json({
                    error: true,
                    descripcion: "Usuario doblemente registrado (ERROR CRITICO)"
                })
            }
        })
    } catch (e) {
        res.status(404).json({
            error: true,
            descripcion: e
        })
    }

})

//Insertar Token 
rutas.post('/usuario/registro/token', async (req, res) => {
    try {
        const cuerpo = req.body;
        pool.query(`UPDATE personas
        SET token = '${cuerpo.token}'
        WHERE numero_telefono = '${cuerpo.numero}'`,(error,resultado)=>{
            if(error){
                res.status(404).json({
                    error: true,
                    descripcion: error
                })
            }else{
                res.json({
                    error: false,
                    descripcion: "Se actualizo el token"
                })
            }
        })
    } catch (e) {
        res.status(404).json({
            error: true,
            descripcion: e
        })
    }
})


//Borrar Token 
rutas.post('/usuario/borrar/token', async (req, res) => {
    try {
        const cuerpo = req.body;
        pool.query(`UPDATE personas
        SET token = null
        WHERE numero_telefono = '${cuerpo.numero}'`,(error,resultado)=>{
            if(error){
                res.status(404).json({
                    error: true,
                    descripcion: error
                })
            }else{
                res.json({
                    error: false,
                    descripcion: "Se borro el token"
                })
            }
        })
    } catch (e) {
        res.status(404).json({
            error: true,
            descripcion: e
        })
    }
})

//Obtener Token por persona
rutas.get('/persona/token/:numero', async (req, res) => {
    try {
        const cuerpo = req.params.numero;
        pool.query(`SELECT TOKEN FROM PERSONAS WHERE NUMERO_TELEFONO = ${cuerpo}`,(error,resultado)=>{
            if(error){
                res.status(404).json({
                    error: true,
                    descripcion: error
                }) 
            }else if(resultado[0]["TOKEN"]==null){
                res.status(404).json({
                    error: true,
                    descripcion: "No tiene token"
                })
            }else{
                res.json(resultado[0]["TOKEN"])
            }
        })
    } catch (e) {
        res.status(404).json({
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
                res.status(404).json({
                    error: true,
                    descripcion: error
                })
            } else {
                res.status(200).json({
                    error: false,
                    descripcion: "Se ingreso el usuario"
                })
            }
        })
    } catch (e) {
        res.json(res.status(404).json({
            error: true,
            descripcion: e
        }))
    }
})

//Obtener chats 
rutas.get('/usuarios/chat/:token', async (req, res) => {
    try {
        const cuerpo = req.params.token;
        const token_dec = await promisify(jwt.verify)(cuerpo, process.env.claveJWT);
        if (token_dec["error"] == false) {
            pool.query(`SELECT p.nombre, p.imagen, c.idchats, p.numero_telefono, p.correo
                    FROM chats AS c
                    JOIN chats_has_personas AS chp ON c.idchats = chp.chats_idchats
                    JOIN personas AS p ON chp.personas_numero_telefono = p.numero_telefono
                    WHERE c.idchats IN (
                      SELECT chp.chats_idchats
                      FROM chats_has_personas AS chp
                      WHERE chp.personas_numero_telefono = '${token_dec["numero"]}'
                    )
                    AND p.numero_telefono <> '${token_dec["numero"]}'
                    AND EXISTS (
                      SELECT 1
                      FROM chats_has_personas AS chp2
                      WHERE chp2.chats_idchats = c.idchats
                      AND chp2.personas_numero_telefono = '${token_dec["numero"]}'
                    );`, (errors, resultado) => {
                if (errors) {
                    res.status(404).json({
                        error: true,
                        descripcion: errors
                    });
                } else {
                    res.status(200).json(resultado);
                }
            });
        }
    } catch (e) {
        res.status(404).json({
            error: true,
            descripcion: 'Token no válido'
        });
    }
});

//Obtener Datos Personales
rutas.get('/usuarios/datos/personales/:token', async (req, res) => {
    try {
        const cuerpo = req.params.token;
        const token_dec = await promisify(jwt.verify)(cuerpo, process.env.claveJWT);
        pool.query(`SELECT numero_telefono , nombre , correo , imagen , descripcion FROM PERSONAS , CARGO WHERE numero_telefono = '${token_dec["numero"]}' AND Cargo_idCargo = idCargo `, (erors, resultado) => {
            if (erors) {
                res.status(404).json({
                    error: true,
                    descripcion: erors
                });
            } else {
                res.status(200).json(resultado);
            }
        })
    } catch (e) {
        res.status(404).json({
            error: true,
            descripcion: 'Token no válido'
        });
    }
})

//Crear nuevo chat
rutas.post('/usuarios/crear/chat', async (req, res) => {
    try {
        const cuerpo = req.body;
        var numero1 = cuerpo.numero1
        var numero2 = cuerpo.numero2
        pool.query(`SELECT COUNT(*) AS cantidad_relaciones FROM chats_has_personas cp1 JOIN chats_has_personas cp2 ON cp1.chats_idchats = cp2.chats_idchats WHERE cp1.personas_numero_telefono = ${numero1} AND cp2.personas_numero_telefono = ${numero2}`,
            (rs, rst) => {
                if (rs) {
                    res.status(404).json({
                        error: true,
                        descripcion: rs
                    })
                } else {
                    if (rst[0]["cantidad_relaciones"] < 1) {
                        pool.query(`SELECT * FROM PERSONAS WHERE numero_telefono = ${numero1} or numero_telefono = ${numero2}`, (error0, resultado0) => {
                            if (error0) {
                                res.status(404).json({
                                    error: true,
                                    descripcion: error0
                                });
                            } else if (resultado0.length == 2) {
                                const fechaActual = new Date();
                                const fechaFormateada = fechaActual.toISOString();
                                pool.query(`INSERT INTO CHATS (CREACION) VALUES ('${fechaFormateada}')`, (error, resultado) => {
                                    if (error) {
                                        res.status(404).json({
                                            error: true,
                                            descripcion: error
                                        });
                                    } else {
                                        pool.query(`INSERT INTO chats_has_personas (CHATS_IDCHATS, PERSONAS_NUMERO_TELEFONO) VALUES 
                                    (${resultado.insertId}, ${numero1}),
                                    (${resultado.insertId}, ${numero2})`, (error2, resultado2) => {
                                            if (error2) {
                                                res.status(404).json({
                                                    error: true,
                                                    descripcion: error2
                                                });
                                            } else {
                                                res.json({
                                                    error: false,
                                                    descripcion: "Se ingreso el chat"
                                                })
                                            }
                                        })

                                    }
                                })
                            } else {
                                res.status(404).json({
                                    error: true,
                                    descripcion: "No se encontro a la persona"
                                });
                            }
                        })
                    } else {
                        res.status(404).json({
                            error: true,
                            descripcion: "Chat duplicado"
                        })
                    }
                }
            })
    } catch (e) {
        res.status(404).json({
            error: true,
            descripcion: e
        });
    }
})

//Buscar mensajes por chat 
rutas.get('/chats/datos/:chat', async (req, res) => {
    try {
        const cuerpo = req.params.chat;
        pool.query(`SELECT chats_idchats ,descripcion , imagen, hora FROM MENSAJES, PERSONAS WHERE CHATS_IDCHATS = ${cuerpo} AND numero_telefono = personas_numero_telefono`, (error, resultado) => {
            if (error) {
                res.status(404).json({
                    error: true,
                    descripcion: e
                });
            } else {
                res.json(resultado);
            }
        })

    } catch (e) {
        res.status(404).json({
            error: true,
            descripcion: e
        });
    }
})

//Ingresar mensaje 
rutas.post('/chats/ingresar/mensaje', async (req, res) => {
    try {
        var cuerpo = req.body
        const fechaActual = new Date();
        const fechaFormateada = fechaActual.toISOString();
        pool.query(`INSERT INTO MENSAJES(DESCRIPCION,HORA,CHATS_IDCHATS,PERSONAS_NUMERO_TELEFONO) VALUES('${cuerpo.descripcion}','${fechaFormateada}',${cuerpo.id_chat},'${cuerpo.numero}')`, (error, resultado) => {
            if (error) {
                res.status(404).json({
                    error: true,
                    descripcion: error
                });
            } else {
                res.json({
                    error: false,
                    descripcion: "Se ingreso el mensaje"
                });
            }
        })

    } catch (e) {
        res.status(404).json({
            error: true,
            descripcion: e
        });
    }
})

module.exports = rutas