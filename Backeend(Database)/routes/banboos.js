var express = require('express');
var router = express.Router();

var con = require('./connect')
const bcrypt = require('bcrypt');
var mysql2 = require('mysql2');


var opt = {
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'banboo_store'
  };


router.get('/', function(req, res, next) {
    const query = "SELECT * FROM user"

    con.query(query, (err, result) =>{
    if(err) throw err;
    res.send(result)
    })
});

router.get('/get-user', (req, res) => {
    const UserID = req.query.UserID

    const query = `SELECT * FROM user WHERE UserID = ${UserID}`
    con.query(query, (err, result) => {
        if(err) throw err;
        res.send(result)
    })
})

//Insert User
router.post('/insert-new-user', (req, res) => {
    const data = req.body

    const query =  `INSERT INTO user (Username, Email, Password, Role) VALUES 
    ('${data.Username}','${data.Email}','${data.Password}','0')`

    con.query(query, (err, result) =>{
        if(err) throw err;
        res.send(result)
    })
})

//Update User
router.post('/update-user', (req, res) => {
    const data = req.body

    const query =  `UPDATE user SET 
    Username = ${data.Username}, Email = ${data.Email}, Password = ${data.Password}, Role = ${data.Role}` 

    con.query(query, (err, result) =>{
        if(err) throw err;
        res.send(result)
    })
})

router.delete('/delete-user', (req, res) => {
    const data = req.body

    const query = `DELETE FROM user WHERE UserID = ${data.UserID}`
})

router.post('/insert-new-users', (req, res) => {
    const data = req.body;

    // Check if email already exists
    const checkQuery = `SELECT * FROM user WHERE Email = ?`;
    con.query(checkQuery, [data.Email], (err, result) => {
        if (err) return res.status(500).send(err);

        if (result.length > 0) {
            return res.status(400).json({ message: "Email already exists" });
        }

        // If email does not exist, insert the new user
        const insertQuery = `INSERT INTO user (Username, Email, Password, Role) VALUES (?, ?, ?, ?)`;
        con.query(insertQuery, [data.Username, data.Email, data.Password, 0], (err, result) => {
            if (err) return res.status(500).send(err);

            res.status(200).json({ message: "User created successfully", result });
        });
    });
});

router.get('/:email/:password', function (req, res, next) {
    var email = req.params.email;
    var password = req.params.password;
    var connection = mysql2.createConnection(opt);
  
    connection.connect();
  
    // QUERY
    connection.query("SELECT role FROM user WHERE email = ? AND password = ?", [email, password], function (err, results) {
      connection.end();
  
      if (err) {
        return res.status(500).json(err); //Return Error dengan HTTP status 500
      }
  
      return res.status(200).json(results);
    });
  });

  router.post('/insert-new-banboo-data', (req, res) => {
   const data = req.body;
   //var connection = mysql.createConnection(opt);
   //connection.connect();
    const imageBuffer = data.BanbooImage ? Buffer.from(data.BanbooImage, 'base64') : null;

    const insertQuery = `INSERT INTO banboo (Banbooname, BanbooHP, BanbooATK, BanbooDEF, BanbooImpact, BanbooCRate, BanbooCDmg, BanbooPRatio, 
    BanbooAMastery, BanbooRank, BanbooImage, BanbooDescription) VALUES (?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?)`;
    con.query(insertQuery, [data.BanbooName, data.BanbooHP, data.BanbooATK, data.BanbooDEF, data.BanbooImpact, 
       data.BanbooCRate, data.BanbooCDmg, data.BanbooPRatio, data.BanbooAMastery, 
        data.BanbooRank, imageBuffer, data.BanbooDescription], (err, result) => {
            if (err) {
                console.error('Database error:', err); // Log the error for debugging
                return res.status(500).send({ message: 'Database error', error: err });
            }


        console.log('Banboo created:', result); // Log success
        res.status(200).json({ message: "Banboo created successfully", id: result.insertId });
    });
});

router.get('/display-banboos-data', (req,res) => {
    const data =  req.body;
    const imageBuffer = data.BanbooImage ? Buffer.from(data.BanbooImage, 'base64') : null;

    const insertQuery = "SELECT * FROM banboo"
    con.query(insertQuery, (err, result) => {
    if(err) throw err;

    result.forEach(result => {
        if(result.BanbooImage){
            result.BanbooImage = Buffer.from(result.BanbooImage).toString('base64');
        }
    });
    res.send(result)
    });

});

router.post('/update-banboos-data', (req, res) => {
    const data = req.body;

    const insertQuery = "UPDATE banboo SET Banbooname = ?, BanbooHP = ?, BanbooATK = ?, BanbooDEF = ?, BanbooImpact = ?, BanbooCRate = ?, BanbooCDmg = ? BanbooPRatio = ?, BanbooAMastery = ?, BanbooRank = ?, BanbooImage = ?, BanbooDescription = ? WHERE BanbooID = ?";
    con.query(insertQuery,[data.BanbooName, data.BanbooHP, data.BanbooATK, data.BanbooDEF, data.BanbooImpact, data.BanbooCRate,data.BanbooCDmg,data.BanbooPRatio,data.BanbooAMastery, data.BanbooRank, imageBuffer, data.BanbooDescription, ] ,(err, result) => {
        if(err) throw err;

        res.send(result)
    });
    
});


module.exports = router;
