var express = require('express');
var router = express.Router();
var con = require('./connect')
const bcrypt = require('bcrypt');
var mysql2 = require('mysql2');
const jwt = require('jsonwebtoken');
const jwtSecret = 'SECRET KEY'; // Ganti dengan secret key yang aman

// Fungsi untuk membuat token
// function generateToken(user) {
//     var payload = {
//       UserID: user.UserID,
//       Username: user.Username,
//     };
  
  //   return jwt.sign(payload, 'SECRET KEY');
  // }


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

function authenticateToken(req, res, next){
    var token = req.headers.token;
    console.log(token);
    if(!token){
      return res.status(401).send('Unauthorized access!');
    }
    try {
      jwt.verify(token, 'SECRET KEY');
      next();
    }catch (e) {
      return res.status(401).send('Unauthorized access!');
    }
  }

  router.get('/search/:prefix', function (req, res) {

    var prefix = req.params.prefix
    var connection = mysql2.createConnection(opt);
  
    connection.connect();
  
    // QUERY
    connection.query("SELECT * FROM banboo WHERE BanbooName LIKE ?", [`%${prefix}%`],function (err, results) {
      connection.end();
  
      if (err) {
        return res.status(500).json(err); //Return Error dengan HTTP status 500
      }
  
      results.forEach(result => {
        if(result.BanbooImage){
          result.BanbooImage = Buffer.from(result.BanbooImage).toString('base64');
        }
      });
  
      return res.status(200).json(results);
    });
  });

  router.post('/insert-new-banboo-data',authenticateToken, (req, res) => {
    const data = req.body;
     const imageBuffer = data.BanbooImage ? Buffer.from(data.BanbooImage, 'base64') : null;
 
     const insertQuery = `INSERT INTO banboo (Banbooname, BanbooHP, BanbooATK, BanbooDEF, BanbooImpact, BanbooCRate, BanbooCDmg, BanbooPRatio, 
     BanbooAMastery, BanbooRank, BanbooImage, BanbooDescription, BanbooPrice, BanbooLevel, ElementID) VALUES (?, ?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
     con.query(insertQuery, [data.BanbooName, data.BanbooHP, data.BanbooATK, data.BanbooDEF, data.BanbooImpact, 
        data.BanbooCRate, data.BanbooCDmg, data.BanbooPRatio, data.BanbooAMastery, 
         data.BanbooRank, imageBuffer, data.BanbooDescription, data.BanbooPrice, data.BanbooLevel, data.ElementID], (err, result) => {
             if (err) {
                 console.error('Database error:', err); // Log the error for debugging
                 return res.status(500).send({ message: 'Database error', error: err });
             }
 
 
         console.log('Banboo created:', result); // Log success
         res.status(200).json({ message: "Banboo created successfully", id: result.insertId });
     });
 });
 
 router.get('/display-banboos-data',authenticateToken, (req,res) => {
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
     const imageBuffer = data.BanbooImage ? Buffer.from(data.BanbooImage, 'base64') : null;
 
     const insertsQuery = "UPDATE banboo SET Banbooname = ?, BanbooHP = ?, BanbooATK = ?, BanbooDEF = ?, BanbooImpact = ?, BanbooCRate = ?, BanbooCDmg = ?, BanbooPRatio = ?, BanbooAMastery = ?, BanbooRank = ?, BanbooImage = ?, BanbooDescription = ?, BanbooPrice = ?, BanbooLevel = ?, ElementID = ? WHERE BanbooID = ?";
     con.query(insertsQuery,[data.BanbooName, data.BanbooHP, data.BanbooATK, data.BanbooDEF, data.BanbooImpact, data.BanbooCRate,data.BanbooCDmg,data.BanbooPRatio,data.BanbooAMastery, data.BanbooRank, imageBuffer, data.BanbooDescription,data.BanbooPrice,data.BanbooLevel,data.ElementID, data.BanbooID ] ,(err, result) => {
         if(err) throw err;
 
         res.send(result)
     });
     
 });
 
 router.delete('/delete-banboos', (req, res) => {
     const data = req.body
 
     const query = `DELETE FROM banboo WHERE BanbooID = ${data.BanbooID}`
     con.query(query, (err, result) =>{
         if(err) throw err;
         res.send(result)
     })
 })

 router.post('/get-banboo-detail', (req, res) => {
  const data = req.body

  const query = `SELECT b.*, e.* FROM Banboo b INNER JOIN elements e ON b.ElementID = e.ElementID WHERE b.BanbooID = ${data.BanbooID}`
  con.query(query, (err, result) => {
      if(err) throw err;
      result.forEach(result => {
          if(result.BanbooImage){
            result.BanbooImage = Buffer.from(result.BanbooImage).toString('base64');
          }
       });
      res.send(result)
  })
});

router.post('/checkout-banboo', (req, res) => {
  const data = req.body;

  const insertsQuery = "UPDATE user SET UserMoney = UserMoney - ? WHERE UserID = ?";
  con.query(insertsQuery,[data.price, data.UserID] ,(err, result) => {
      if(err){
          return res.status(500).json(err);
      }

      res.send(result)
  });
  
});


  module.exports = router;

