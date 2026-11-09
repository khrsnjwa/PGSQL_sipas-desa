exports.notFound = (req, res) => {
  res.status(404).json({ success: false, message: `Route ${req.method} ${req.originalUrl} tidak ditemukan` });
};

exports.errorHandler = (err, req, res, next) => {
  // Kode error PostgreSQL
  if (err.code === '23505') {
    return res.status(409).json({ success: false, message: 'Data duplikat: nilai sudah digunakan', detail: err.detail });
  }
  if (err.code === '23503') {
    return res.status(409).json({
      success: false,
      message: 'Data tidak bisa dihapus/diubah karena masih dipakai data lain (pengajuan surat)',
      detail: err.detail,
    });
  }
  if (err.type === 'entity.parse.failed') {
    return res.status(400).json({ success: false, message: 'Body JSON tidak valid' });
  }
  console.error(err);
  res.status(500).json({ success: false, message: 'Terjadi kesalahan pada server' });
};
