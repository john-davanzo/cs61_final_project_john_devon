import React from 'react';
import {motion, AnimatePresence} from 'framer-motion';


const LoseModal = ({ lost, movies, metric, score }) => {
  return (
    <AnimatePresence>
      {lost[0] &&
        <motion.div
          className='loseModal'
          initial={{ scale: 0, borderRadius: '1000px' }}
          animate={{ scale: 1, borderRadius: '0px' }}
          exit={{ scale: 0, borderRadius: '1000px' }}
          transition={{ duration: 1 }}
        >
          <div className='gameOver'>Game Over</div>
          <div className='loseMessage'><span>{movies[0].title}</span> has a {lost[1] ? 'higher' : 'lower'} {metric} than <span>{movies[1].title}</span> </div>
          <div className='loseScore'>Your score was: <span className='loseScoreNum'>{score}</span></div>
          <a className='tryAgain' href="/">x</a>
        
        </motion.div>
      }
    </AnimatePresence>
  );
}

export default LoseModal;