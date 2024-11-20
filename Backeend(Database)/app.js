var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var banboosRouter = require('./routes/banboos');

var app = express();

// const bodyParser = require('body-parser');

// app.use(bodyParser.json({ limit: '10mb' })); // Sesuaikan ukuran
// app.use(bodyParser.urlencoded({ limit: '10mb', extended: true }));


app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/banboos', banboosRouter);


module.exports = app;
