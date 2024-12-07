var express = require('express');
var router = express.Router();
var con = require('./connect')
const bcrypt = require('bcrypt');
var mysql2 = require('mysql2');
const jwt = require('jsonwebtoken');
const jwtSecret = 'SECRET KEY'; // Ganti dengan secret key yang aman

// Fungsi untuk membuat token
function generateToken(user) {
    var payload = {
      UserID: user.UserID,
      Username: user.Username,
    };
  
    return jwt.sign(payload, 'SECRET KEY');
  }


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



//Insert User
router.post('/insert-new-user', (req, res) => {
    const data = req.body

    const query =  `INSERT INTO user (Username, Email, Password, Role) VALUES 
    ('${data.Username}','${data.Email}','${data.Password}','0')`

    con.query(query, (err, results) =>{
        if(err) throw err;
        res.send(results)
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
}
)



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
            if (err) {
                return res.status(500).json({ message: "Database error", error: err });
            }
    
            if (result.length === 0) {
                return res.status(401).json({ message: "Invalid email or password" });
            }
           
            
               
                return res.status(200).json(result);
                
          
        });
    });
});

router.post('/login', function (req, res, next) {
    var Email = req.body.email;
    var Password = req.body.password;
    var connection = mysql.createConnection(opt);
    connection.connect();
  
    // QUERY
    connection.query("SELECT * FROM user WHERE Email = ? AND Password = ?", [Email, Password], function (err, results) {
  
      if (err) throw err;
      if (results.length === 0) {
        return res.status(403).send('Invalid user creds.');
      }
  
      var user = results[0];
      var token = generateToken(user);
  
      connection.query("UPDATE user SET userToken = ? WHERE UserID = ?", [token, user.UserId]);
      connection.end();
      var data = {
        UserID: user.UserID,
        Username: user.Username,
        token: token
      }
      return res.status(200).json(data);
    });
  });

router.get('/:Email/:Password', function (req, res, next) {
    const Email = req.params.Email;
    const Password = req.params.Password;
    const connection = mysql2.createConnection(opt);

    connection.connect();

    connection.query("SELECT * FROM user WHERE Email = ? AND BINARY Password = ?", [Email, Password], function (err, results) {
         // Tutup koneksi setelah query selesai

        if (err) throw err;
        if (results.length === 0) {
            return res.status(403).json("invalid");
        }

        var user = results[0];
        var token = generateToken(user)
        
        connection.query("UPDATE user SET token = ? WHERE UserID = ?", [token, user.UserID]);
        connection.end();
        var data = {
            UserId : user.UserID,
            Username: user.Username,
            Password : user.Password,
            Email : user.Email,
            Role : user.Role,
            UserMoney : user.UserMoney,
            token : token,
        }
            return res.status(200).json(data);

        //     return res.status(200).json(results);
    });
});


  router.post('/insert-new-banboo-data', (req, res) => {
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

  router.post('/get-id', (req, res) => {
    const data = req.body

    const query = `SELECT UserID, UserMoney FROM user WHERE Email = ?`
    con.query(query, [data.Email], (err, result) =>{
        if(err) throw err;
        res.send(result),
        res.send(data.UserID)
    })
})

router.post('/get-role', (req, res) => {
    const data = req.body

    const query = `SELECT Role FROM user WHERE Email = ?`
    con.query(query, [data.Email], (err, result) =>{
        if(err) throw err;
        res.send(result),
        res.send(data.UserID)
    })
})

router.post('/get-user', (req, res) => {
    const data = req.body

    const query = `SELECT * FROM user WHERE UserID = ${data.UserID}`
    con.query(query, (err, result) => {
        if(err) throw err;
        res.send(result)
    })
})

// router.post('/get-banboo-detail', (req, res) => {
//     const data = req.body

//     const query = `SELECT * FROM banboo WHERE BanbooID = ${data.BanbooID}`
//     con.query(query, (err, result) => {
//         if(err) throw err;
//         result.forEach(result => {
//             if(result.BanbooImage){
//               result.BanbooImage = Buffer.from(result.BanbooImage).toString('base64');
//             }
//          });
//         res.send(result)
//     })
// });

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

router.post('/update-user-money', (req, res) => {
    const data = req.body;

    const insertsQuery = "UPDATE user SET UserMoney = UserMoney + ? WHERE UserID = ?";
    con.query(insertsQuery,[data.money, data.UserID] ,(err, result) => {
        if(err) {
            return res.status(500).json(err);
        };

        res.send(result)
    });
    
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