import './App.css';
import { useState, useEffect } from 'react';
import Movie from './Movie';
import Metrics, { randomMetric } from './metrics';
import LoseModal from './LoseModal';


// const backendUrl = 'http://localhost:9090';
const backendUrl = 'https://cs61johndevonbackend.onrender.com';


function App() {
  const [score, setScore] = useState(0);
  const [metric, setMetric] = useState(Metrics.BUDGET);
  const [movies, setMovies] = useState([]);
  const [lost, setLost] = useState([false, false]);
  const [highscore, setHighscore] = useState(-1);

  // this is run on page load
  useEffect(() => {
    for (const _ in [0, 1, 2]) { // does this 3 times
      fetch(`${backendUrl}/randomMovie`)
        .then(res => res.json())
        .then(data => {
          console.log(data);
          setMovies((movies) => [...movies, data]);
        });
    }

    // set metric to a random one
    setMetric(randomMetric());

    // get highscore
    fetch(`${backendUrl}/highscore`, { method: 'GET', credentials: 'include' }).then(res => res.json()).then(data => {
      console.log('HighScore', data);
      setHighscore(data.highscore)
    });
  }, []);


  // function run when an answer is selected, selection is 1 if higher and 0 if lower, 
  // setDone is a function passed in to set the done state of the movie which reveals the metric for that movie
  const answer = async (selection, setDone) => {
    if ((selection && movies[0][metric] <= movies[1][metric])
      || (!selection && movies[0][metric] >= movies[1][metric])) {
      
      // correct answer, so increment score, get new movie, and set new metric
      setScore(score + 1);
      const newMovie = await fetch(`${backendUrl}/randomMovie`);
      newMovie.json().then(data => { 
        setMovies((movies) => [...movies.slice(1), data]);
        setMetric(randomMetric());
      });
      return;
    }

    // incorrect answer, so set done and lost to true and set the correct answer
    setDone(true);
    if (score > highscore) {
      fetch(`${backendUrl}/highscore`, {
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
  
  return (
    <div className="App">
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
