var express = require('express');
var router = express.Router();
var con = require('./connect')
const bcrypt = require('bcrypt');
var mysql2 = require('mysql2');
const jwt = require('jsonwebtoken');
const jwtSecret = 'banboo_store'; // Ganti dengan secret key yang aman

// Fungsi untuk membuat token
function generateToken(payload) {
    return jwt.sign(payload, jwtSecret, { expiresIn: '1h' }); // Token berlaku 1 jam
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

function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) return res.status(401).json({ message: "Access denied, token missing" });

    jwt.verify(token, jwtSecret, (err, user) => {
        if (err) return res.status(403).json({ message: "Invalid token" });

        req.user = user; // Simpan payload token ke req
        next();
    });
}

router.get('/protected', authenticateToken, (req, res) => {
    res.json({ message: "This is a protected route", user: req.user });
});



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
            if (err) return res.status(500).send(err);

            res.status(200).json({ message: "User created successfully", result });
        });
    });
});

router.get('/:email/:password', function (req, res, next) {
    const email = req.params.email;
    const password = req.params.password;

    const connection = mysql2.createConnection(opt);

    connection.connect();

    connection.query("SELECT UserID FROM user WHERE email = ? AND BINARY password = ?", [email, password], function (err, results) {
        connection.end(); // Tutup koneksi setelah query selesai

        if (err) {
            return res.status(500).json({ message: "Database error", error: err });
        }

        if (results.length === 0) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        const user = results[0];
        const token = jwt.sign({ userId: user.UserID, email: email, role: user.Role }, jwtSecret, { expiresIn: '1h' });

        const updateQuery = `UPDATE user SET userToken = ? WHERE UserID = ?`;
        con.query(updateQuery, [token, user.UserID], (updateErr) => {
            if (updateErr) {
                return res.status(500).json({ message: "Error updating token in database", error: updateErr });
            }

            return res.status(200).json({
                message: "Login successful",
                token: token,
                role: user.Role
            });
        });
    });
});



  router.post('/insert-new-banboo-data', (req, res) => {
   const data = req.body;
   //var connection = mysql.createConnection(opt);
   //connection.connect();
    const imageBuffer = data.BanbooImage ? Buffer.from(data.BanbooImage, 'base64') : null;

    const insertQuery = `INSERT INTO banboo (Banbooname, BanbooHP, BanbooATK, BanbooDEF, BanbooImpact, BanbooCRate, BanbooCDmg, BanbooPRatio, 
    BanbooAMastery, BanbooRank, BanbooImage, BanbooDescription, BanbooPrice, BanbooLevel) VALUES (?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    con.query(insertQuery, [data.BanbooName, data.BanbooHP, data.BanbooATK, data.BanbooDEF, data.BanbooImpact, 
       data.BanbooCRate, data.BanbooCDmg, data.BanbooPRatio, data.BanbooAMastery, 
        data.BanbooRank, imageBuffer, data.BanbooDescription, data.BanbooPrice, data.BanbooLevel], (err, result) => {
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
    const imageBuffer = data.BanbooImage ? Buffer.from(data.BanbooImage, 'base64') : null;

    const insertsQuery = "UPDATE banboo SET Banbooname = ?, BanbooHP = ?, BanbooATK = ?, BanbooDEF = ?, BanbooImpact = ?, BanbooCRate = ?, BanbooCDmg = ?, BanbooPRatio = ?, BanbooAMastery = ?, BanbooRank = ?, BanbooImage = ?, BanbooDescription = ?, BanbooPrice = ?, BanbooLevel = ? WHERE BanbooID = ?";
    con.query(insertsQuery,[data.BanbooName, data.BanbooHP, data.BanbooATK, data.BanbooDEF, data.BanbooImpact, data.BanbooCRate,data.BanbooCDmg,data.BanbooPRatio,data.BanbooAMastery, data.BanbooRank, imageBuffer, data.BanbooDescription,data.BanbooPrice,data.BanbooLevel, data.BanbooID ] ,(err, result) => {
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

router.post('/get-banboo-detail', (req, res) => {
    const data = req.body
    // const imageBuffer = data.BanbooImage ? Buffer.from(data.BanbooImage, 'base64') : null;

    const query = `SELECT * FROM banboo WHERE BanbooID = ${data.BanbooID}`
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
