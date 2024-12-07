const mysql = require('mysql2')
//const jwtSecret = 'banboo_store'; // Ganti dengan secret key yang aman


const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'banboo_store'
})

connection.connect()




module.exports = connection;