import express from 'express';
import cors from 'cors';
import path from 'path';
import morgan from 'morgan';
import routes from './routes';
import sshTunnelMysqlConnection from './mysql';
// import session from 'express-session';

const appUrl = 'http://localhost:3000';

const cookieParser = require('cookie-parser');

const session = require('express-session');

// initialize
const app = express();
app.use(cookieParser());
app.use(session({ secret: 'iuqgf78g2bc', saveUninitialized: true, resave: true }));

// enable/disable cross origin resource sharing if necessary
app.use(cors({ origin: appUrl, credentials: true }));

// enable/disable http request logging
app.use(morgan('dev'));

// enable only if you want templating
app.set('view engine', 'ejs');

// enable only if you want static assets from folder static
app.use(express.static('static'));

// this just allows us to render ejs from the ../app/views directory
app.set('views', path.join(__dirname, '../src/views'));

// enable json message body for posting data to API
app.use(express.urlencoded({ extended: true }));
app.use(express.json()); // To parse the incoming requests with JSON payloads

// additional init stuff should go before hitting the routing

app.use('', routes);

// START THE SERVER
// =============================================================================
async function startServer() {
    try {
    // connect DB
      const connection = await sshTunnelMysqlConnection();
      app.set('connection', connection);
        const port = process.env.PORT || 9090;
        app.listen(port);

        console.log(`Listening on port ${port}`);
    } catch (error) {
        console.error(error);
    }
}

startServer();
