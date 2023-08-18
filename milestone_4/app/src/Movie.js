import React, {useState} from 'react'
import Metrics from './metrics';
import { AnimatePresence, motion } from 'framer-motion';

const units = {
  [Metrics.RUNTIME]: 'minutes',
  [Metrics.REVENUE]: 'US Dollars',
  [Metrics.POPULARITY]: '',
  [Metrics.BUDGET]: 'US Dollars',

};

function numberWithCommas(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

const Movie = ({ movie, finished, metric, answer }) => {
  
  const [done, setDone] = useState(finished);

  // returns the metric info if the movie is done, otherwise returns the overview and answer buttons
  const renderInfo = () => {
    if (done) return (
      <motion.div  key="finished" initial={{opacity: 1}} exit={{opacity: 0}} className="movieInfo" >
        <div className="metricTitle">has a {metric} of</div>
        <div className="metric">{metric === Metrics.BUDGET || metric === Metrics.REVENUE ? numberWithCommas(movie[metric]) : movie[metric]}</div>
        <div className="units">{units[metric]}</div>
      </motion.div>
    );
    return (
      <motion.div key="notFinished" initial={{opacity: 1}} exit={{opacity: 0}} className="movieInfo">
        <div className="overview">"{movie.overview}"</div>
        <button onClick={_ => answer(1, setDone)}>Higher</button>
        <button onClick={_ => answer(0, setDone)}>Lower</button>
      </motion.div>
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
        <div className="contentHolder">
          <AnimatePresence>
            {renderInfo()}
          </AnimatePresence>
        </div>
      </div>
    </div>
  )
}

export default Movie;