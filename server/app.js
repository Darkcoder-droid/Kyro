const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// API Routes will be mounted here
app.get('/', (req, res) => {
  res.send('Kiro API is running...');
});

module.exports = app;
