const Metrics = {
  RUNTIME: 'runtime',
  POPULARITY: 'popularity',
  REVENUE: 'revenue',
  BUDGET: 'budget',
};

const randomMetric = () => {
  const metrics = Object.values(Metrics);
  const randomIndex = Math.floor(Math.random() * metrics.length);
  return metrics[randomIndex];
}

export default Metrics;
export { randomMetric }; 