const pool = require('../config/db');

// GET /jenis-surat  -> semua data
exports.getAll = async (req, res, next) => {
  try {
    const { rows } = await pool.query('SELECT * FROM jenis_surat ORDER BY id ASC');
    res.json({ success: true, message: 'Berhasil mengambil semua jenis surat', count: rows.length, data: rows });
  } catch (err) { next(err); }
};

// GET /jenis-surat/:id  -> berdasarkan ID (sekaligus daftar persyaratan via tabel pivot)
exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const surat = await pool.query('SELECT * FROM jenis_surat WHERE id = $1', [id]);
    if (surat.rowCount === 0) {
      return res.status(404).json({ success: false, message: `Jenis surat dengan id ${id} tidak ditemukan` });
    }
    const syarat = await pool.query(
      `SELECT p.id, p.nama, p.keterangan, jsp.wajib
         FROM jenis_surat_persyaratan jsp
         JOIN persyaratan p ON p.id = jsp.persyaratan_id
        WHERE jsp.jenis_surat_id = $1
        ORDER BY p.id`, [id]);
    res.json({ success: true, message: 'Berhasil mengambil jenis surat', data: { ...surat.rows[0], persyaratan: syarat.rows } });
  } catch (err) { next(err); }
};

// POST /jenis-surat  -> tambah data
exports.create = async (req, res, next) => {
  try {
    const { kode, nama, deskripsi } = req.body;
    const { rows } = await pool.query(
      'INSERT INTO jenis_surat (kode, nama, deskripsi) VALUES ($1, $2, $3) RETURNING *',
      [kode, nama, deskripsi || null]
    );
    res.status(201).json({ success: true, message: 'Jenis surat berhasil ditambahkan', data: rows[0] });
  } catch (err) { next(err); }
};

// PUT /jenis-surat/:id  -> ubah data
exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { kode, nama, deskripsi } = req.body;
    const { rows, rowCount } = await pool.query(
      `UPDATE jenis_surat
          SET kode = $1, nama = $2, deskripsi = $3, updated_at = NOW()
        WHERE id = $4 RETURNING *`,
      [kode, nama, deskripsi || null, id]
    );
    if (rowCount === 0) {
      return res.status(404).json({ success: false, message: `Jenis surat dengan id ${id} tidak ditemukan` });
    }
    res.json({ success: true, message: 'Jenis surat berhasil diperbarui', data: rows[0] });
  } catch (err) { next(err); }
};

// DELETE /jenis-surat/:id  -> hapus data
exports.remove = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { rows, rowCount } = await pool.query('DELETE FROM jenis_surat WHERE id = $1 RETURNING *', [id]);
    if (rowCount === 0) {
      return res.status(404).json({ success: false, message: `Jenis surat dengan id ${id} tidak ditemukan` });
    }
    res.json({ success: true, message: 'Jenis surat berhasil dihapus', data: rows[0] });
  } catch (err) { next(err); }
};
