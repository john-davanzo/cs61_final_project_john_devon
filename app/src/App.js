import './App.css';
import { useState, useEffect } from 'react';
import Movie from './Movie';
import Metrics, {randomMetric} from './metrics';





function App() {
  const [score, setScore] = useState(0);
  const [metric, setMetric] = useState(randomMetric());
  const movie1 = {
    title: 'Movie 1',
    img: 'https://picsum.photos/200/300',
    runtime: 100,
    popularity: 10,
    revenue: 5,
    budget: 2,
  };
  const movie2 = {
    title: 'Movie 2',
    img: 'https://picsum.photos/210/310',
    runtime: 90,
    popularity: 11,
    revenue: 4,
    budget: 3,
  };
  const [movies, setMovies] = useState([]);

  useEffect(() => {
    fetch('http://localhost:9090/randomMovie')
      .then(res => res.json())
      .then(data => {
        console.log(data);
        setMovies((movies) => [...movies, data]);
      });
  }, []);

  const answer = async (selection) => {
    // console.log(selection);
    // return;
    if (selection && movies[movies.length - 1][metric] >= movies[movies.length - 2][metric]
      || !selection && movies[movies.length - 1][metric] <= movies[movies.length - 2][metric]) {
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


  };

  return (
    <div className="App">
      {/* {movies.length === 0 && <LoadingScreen />} */}
      {movies.length >= 2 && (
        movies.map((movie, index) => (
          <Movie answer={answer} metric={metric} movie={movie} finished={index !== movies.length - 1} />
        ))
      )}
      <div className="score">Score: <span>{score}</span></div>
    </div>
  );
}

export default App;
