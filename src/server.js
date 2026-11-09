require('dotenv').config();
const app = require('./app');
const pool = require('./config/db');

const PORT = process.env.PORT || 3000;

pool.query('SELECT NOW()')
  .then(() => {
    console.log('Terhubung ke PostgreSQL');
    app.listen(PORT, () => console.log(`Server berjalan di http://localhost:${PORT}`));
  })
  .catch((err) => {
    console.error('Gagal terhubung ke database:', err.message);
    process.exit(1);
  });
