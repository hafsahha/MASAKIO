const express = require('express');
const cors = require('cors');
const db = require('./db');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

// Example GET
app.get('/', (req, res) => {
  // Fetch
});

// Example POST
app.post('/', (req, res) => {
  // Add
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
