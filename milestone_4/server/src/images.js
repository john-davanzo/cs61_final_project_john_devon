const apiPath = 'https://api.pexels.com/v1/search'; // this api is used to get images based on a query
const apiKey = 'Dvl1NF0oTMVTw1drc0yaJv4Qdgo5djJEya1sYGMJ69VR6pllXfBRjOUI';

const getImage = async (movieTitle) => { 
  const response = await fetch(`${apiPath}?query=${movieTitle}&per_page=1`, {
    headers: {
      Authorization: apiKey
    }
  });
  const json = await response.json();
  if (!json.photos || !json.photos[0]) return 'https://picsum.photos/200/300'; // if no image is found, return a random image
  return json.photos[0].src.medium;
};

export default getImage;

