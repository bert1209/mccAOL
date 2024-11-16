var express = require('express');
var router = express.Router();

const {getAllUser, login} = require('./user.query')


router.get('/', function(req, res, next) {
  res.send('This is mysql endpoint');
});

router.get('/getAllUser', async function(req, res, next){
    try{
        const users = await getAllUser();
        if(users.length > 0){
            res.json(users)
        }
        else{
            res.status(404).send('User data not found');
        }
    } catch (error){
        res.status(500).send('Internal server erros' + error)
    }
})

router.get('/loginAuth', async function(req, res, next){
    const {username,password} = req.query
    try{
        const users = await login(username,password);
        if(users.length > 0){
            res.json(users)
        }
        else{
            res.status(404).send('User data not found');
        }
    } catch (error){
        res.status(500).send('Internal server erros' + error)
    }
})

module.exports = router;