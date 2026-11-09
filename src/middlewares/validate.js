// Validasi :id harus angka
exports.validateId = (req, res, next) => {
  if (!/^\d+$/.test(req.params.id)) {
    return res.status(400).json({ success: false, message: 'Parameter id harus berupa angka' });
  }
  next();
};

// Validasi body untuk POST & PUT jenis surat
exports.validateJenisSurat = (req, res, next) => {
  const { kode, nama } = req.body || {};
  const errors = [];
  if (!kode || !String(kode).trim()) errors.push('kode wajib diisi');
  if (!nama || !String(nama).trim()) errors.push('nama wajib diisi');
  if (kode && String(kode).length > 20) errors.push('kode maksimal 20 karakter');
  if (nama && String(nama).length > 100) errors.push('nama maksimal 100 karakter');
  if (errors.length) return res.status(400).json({ success: false, message: 'Validasi gagal', errors });
  next();
};
