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



module.exports = router;