const express = require('express');
const fs = require('fs');

const app = express();
const port = 8080;

app.use(express.json());

app.post('/patient', (req, res) => {
  const jsonData = req.body;

  const filePath = `./user.json`;
  
  // Write the file
  fs.writeFile(filePath, JSON.stringify(jsonData), (err) => {
    if (err) {
      console.error(`Error writing to file ${filePath}: ${err}`);
      res.status(500).send('Error writing file');
    } else {
      console.log(`JSON data written to file ${filePath}`);
      res.send('JSON data received and processed');
    }
  });
});


app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
}); 