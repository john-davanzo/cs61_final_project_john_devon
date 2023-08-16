import React from 'react'
import Metrics from './metrics';

const units = {
  [Metrics.RUNTIME]: 'minutes',
  [Metrics.REVENUE]: 'US Dollars',
  [Metrics.POPULARITY]: '',
  [Metrics.BUDGET]: 'US Dollars',

};

const Movie = ({ movie, finished, metric, answer }) => {
  // console.log(units);


  const renderInfo = () => {
    if (finished) return (
      <div className="movieInfo">
        <div className="metricTitle">has a {metric} of</div>
        <div className="metric">{movie[metric]}</div>
        <div className="units">{units[metric]}</div>
      </div>
    );
    return (
      <div className="movieInfo">
        <button onClick={_ => answer(1)}>Higher</button>
        <button onClick={_ => answer(0)}>Lower</button>
      </div>
    );
  }

  return (
    <div className = 'movie'
    style={{
        backgroundImage: `url("${movie.img}")`,
        backgroundSize: 'cover',
        }}
    >
      <div className="movieContent">
        <div className="title">{movie.title}</div>
        {renderInfo()}
      </div>
    </div>
  )
}

export default Movie;