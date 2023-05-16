const express = require('express');
const cors = require('cors');

const app = express();
const port = 8080;

app.use(express.json());
app.use(cors()); 

let jsonData = {};


app.get('/patient', (req, res) => {
  res.json(jsonData);
});


app.post('/patient', (req, res) => {
  jsonData = req.body;
  res.send('JSON data received and processed');
});


app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
}); 