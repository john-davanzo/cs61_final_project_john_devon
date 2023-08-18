import { Router } from 'express';
import sshTunnelMysqlConnection from './mysql';
import getImage from './images';

const router = Router();

// returns random movie with its metrics and overview and title from database using a query seen below.
router.get('/randomMovie', async (req, res) => {
  const connection = req.app.get('connection');
  const [rows] = await connection.execute('SELECT title, overview, runtime, budget, revenue, popularity FROM movies m, outcomes o where m.movie_id = o.movie_id and o.revenue != 0 and o.budget != 0 and o.popularity >= 20 ORDER BY RAND() LIMIT 1;');
  const movie = rows[0];
  const img = await getImage(movie.title); // get image from api image searcher based on the movie title
  movie.img = img;
  res.json(movie);
});

// returns highscore if it exists, otherwise returns 0
router.get('/highscore', (req, res) => { 
  console.dir(req);
  if (req.session.highscore === undefined) {
    req.session.highscore = 0;
    console.log("set highscore to 0");
  } 
  res.json({highscore: req.session.highscore || 0});
});

// sets highscore in cookie, returns success message if highscore is set
router.post('/highscore', async (req, res) => { 
  req.session.highscore = req.body.highscore;
  res.json({message: 'success'});
});


export default router;
