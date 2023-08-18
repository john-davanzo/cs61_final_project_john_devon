import './App.css';
import { useState, useEffect } from 'react';
import Movie from './Movie';
import Metrics, { randomMetric } from './metrics';
import { AnimatePresence } from 'framer-motion';
import LoseModal from './LoseModal';





function App() {
  const [score, setScore] = useState(0);
  const [metric, setMetric] = useState(Metrics.BUDGET);
  const [movies, setMovies] = useState([]);
  const [lost, setLost] = useState([false, false]);
  const [highscore, setHighscore] = useState(-1);

  useEffect(() => {
    for (const _ in [0, 1, 2]) {
      fetch('http://localhost:9090/randomMovie')
        .then(res => res.json())
        .then(data => {
          console.log(data);
          setMovies((movies) => [...movies, data]);
        });
    }
    setMetric(randomMetric());
    fetch('http://localhost:9090/highscore', { method: 'GET', credentials: 'include' }).then(res => res.json()).then(data => {
      console.log('HighScore', data);
      setHighscore(data.highscore)
    });
    console.log("useEffect");
  }, []);

  const answer = async (selection, setDone) => {
    // console.log(selection);
    // return;
    if ((selection && movies[0][metric] <= movies[1][metric])
      || (!selection && movies[0][metric] >= movies[1][metric])) {
      // correct answer!
      setScore(score + 1);
      // get a new movie, remove the one at beginning of array, add new to end of array
      const newMovie = await fetch('http://localhost:9090/randomMovie');
      newMovie.json().then(data => { 
        setMovies((movies) => [...movies.slice(1), data]);
        setMetric(randomMetric());
      });
      
      return;
    }
    setDone(true);
    if (score > highscore) {
      fetch('http://localhost:9090/highscore', {
        method: 'POST',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({highscore: score})
      }).then(res => res.json()).then(data => console.log(data));
    }
    setTimeout(() => { 
      setLost([true, selection]);
    }, 1000);



  };
  if (movies.length > 0) console.log("key", movies[0].title);
  return (
    <div className="App">
      {/* {movies.length === 0 && <LoadingScreen />} */}
      {/* {movies.length >= 2 && (
        movies.map((movie, index) => (
          <Movie key={`${score}-${movie.title}`} answer={answer} metric={metric} movie={movie} finished={index !== movies.length - 1} />
        ))
      )} */}
        {movies.length >= 2 && (
          <>
            <Movie answer={answer} metric={metric} movie={movies[0]} finished />
            <Movie answer={answer} metric={metric} movie={movies[1]} />
          </>
        )}
      <div className="score">Score: <span>{score}</span></div>
      <div className="highscore">High Score: <span>{highscore}</span></div>
      <LoseModal score={score} lost={lost} movies={movies} metric={metric} />
    </div>
  );
}

export default App;
