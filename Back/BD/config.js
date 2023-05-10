const mysql = require('mysql');
require('dotenv').config();
const { promisify } = require('util');

const pool = mysql.createPool({
  host: process.env.host,
  user: process.env.user,
  password: process.env.password,
  database: process.env.database
});

pool.getConnection((error, connection) => {
  if (error) {
    console.error('Error al conectar a la base de datos: ', error);
    return;
  }
  console.log('Conexión exitosa a la base de datos.');
  connection.query = promisify(connection.query);
});

module.exports = pool;