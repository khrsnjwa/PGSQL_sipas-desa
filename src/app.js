const express = require('express');
const cors = require('cors');
const jenisSuratRoutes = require('./routes/jenisSuratRoutes');
const { notFound, errorHandler } = require('./middlewares/errorHandler');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => res.json({ app: 'SIPAS Desa API', status: 'running' }));
app.use('/jenis-surat', jenisSuratRoutes);

app.use(notFound);
app.use(errorHandler);

module.exports = app;
