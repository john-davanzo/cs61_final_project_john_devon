import { Router } from 'express';
import sshTunnelMysqlConnection from './mysql';
import getImage from './images';

const router = Router();
// here we set up handling of endpoints
// each route will talk to a controller and return a response

// const connection = sshTunnelMysqlConnection();

// default index route
router.get('/randomMovie', async (req, res) => {
  // if (!connection.execute) return res.status(500).send('No connection to database');
  const connection = req.app.get('connection');
  const [rows] = await connection.execute('SELECT title, runtime, budget, revenue, popularity FROM movies m, outcomes o where m.movie_id = o.movie_id ORDER BY RAND() LIMIT 1;');
  const movie = rows[0];
  const img = await getImage(movie.title);
  movie.img = img;
  res.json(movie);
  // connection.end();
});

router.get('/img', async (req, res) => {
  const img = await getImage('star wars');
  // res.json(img);
  res.redirect(img);
});

export default router;
