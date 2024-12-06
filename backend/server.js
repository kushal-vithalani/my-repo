const express = require('express');
const mysql = require('mysql2');
const app = express();

app.use(express.json());

const db = mysql.createConnection({
  host: 'your-db-host',
  user: 'your-db-user',
  password: 'your-db-password',
  database: 'your-db-name',
});

app.post('/submit', (req, res) => {
  const { name, email } = req.body;
  db.query('INSERT INTO users (name, email) VALUES (?, ?)', [name, email], (err, result) => {
    if (err) return res.status(500).send('Error inserting data');
    res.send('Data inserted successfully');
  });
});

app.listen(5000, () => console.log('Server running on port 5000'));

