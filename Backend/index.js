

const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json()); 


// Conexión a la base de datos
const db = mysql.createConnection({
    host: 'localhost',
    user: 'admin',
    password: 'Qwerty', // usa la que elegiste
    database: 'flutter_app'
  });

db.connect(err => {
  if (err) {
    console.error('Error de conexión a la base de datos:', err);
    return;
  }
  console.log('Conectado a la base de datos MySQL');
});

// Ruta de registro de usuario
app.post('/register', (req, res) => {

  console.log("Email recibido:", email);
  console.log("Password recibido:", password);
  
  const { email, password, paymentMethod } = req.body;

  if (!email || !password || !paymentMethod) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  const query = 'INSERT INTO users (email, password, payment_method) VALUES (?, ?, ?)';
  db.query(query, [email, password, paymentMethod], (err, result) => {
    if (err) {
      console.error('Error al insertar usuario:', err);
      return res.status(500).json({ error: 'Error al registrar usuario' });
    }

    res.status(200).json({ message: 'Usuario registrado correctamente' });
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Servidor escuchando en http://0.0.0.0:${port}`);
});


// Ruta para iniciar sesión
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Faltan datos' });
  }

  const query = 'SELECT * FROM users WHERE email = ? AND password = ?';
  db.query(query, [email, password], (err, results) => {
    if (err) {
      console.error('Error al consultar usuario:', err);
      return res.status(500).json({ error: 'Error en el servidor' });
    }

    if (results.length > 0) {
      res.status(200).json({ message: 'Inicio de sesión exitoso' });
    } else {
      res.status(401).json({ error: 'Credenciales incorrectas' });
    }
  });
});