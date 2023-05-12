const jwt = require('jsonwebtoken');
const pool = require('../BD/config');

async function verficar(token) {
    try {
        const tokenjwb = jwt.verify(token, process.env.claveJWT);
        const resultado = await new Promise((resolve, reject) => {
            pool.query(`SELECT * FROM PERSONAS WHERE numero_telefono = ${tokenjwb.numero}`, (error, resultado) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(resultado);
                }
            });
        });

        if (resultado.length > 0) {
            return true;
        } else {
            return false;
        }
    } catch (e) {
        return false;
    }
}

module.exports = {
    verficar: verficar
};
