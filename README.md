# SIPAS Desa – Sistem Informasi Pelayanan Administrasi Surat Desa

Backend Database (PostgreSQL) + REST API (Express.js) untuk memudahkan warga mengajukan surat administrasi tanpa harus berkali-kali datang ke kantor desa.

**Nama:** Najwa Khoerunnisa Suherman · **Universitas Pancasila** · Program Web Development & UI/UX Design – Module Backend Development

## 1. Studi Kasus & Kebutuhan Fitur
- Pengajuan surat secara online
- Pilihan jenis surat (domisili, pengantar SKCK, usaha, dll.)
- Upload dokumen persyaratan
- Verifikasi pengajuan oleh perangkat desa
- Pelacakan status permohonan
- Download surat yang sudah disetujui
- Riwayat pengajuan surat

Alur: warga mengajukan → upload dokumen → verifikasi perangkat desa → status berubah → surat terbit.

## 2. Rancangan Database (11 tabel)
| Tabel | Fungsi | Relasi |
|---|---|---|
| warga | Data warga | – |
| akun_warga | Akun login warga | **one-to-one** ke warga (`warga_id UNIQUE`) |
| perangkat_desa | Data petugas desa | – |
| jenis_surat | Master jenis surat | – |
| persyaratan | Master persyaratan | – |
| jenis_surat_persyaratan | Pivot | **many-to-many** jenis_surat ↔ persyaratan |
| pengajuan_surat | Data pengajuan | **one-to-many** dari warga & jenis_surat |
| dokumen_pengajuan | File syarat diupload | one-to-many dari pengajuan_surat |
| verifikasi_pengajuan | Verifikasi perangkat | one-to-many dari pengajuan_surat |
| riwayat_status | Log perubahan status | one-to-many dari pengajuan_surat |
| surat_terbit | Surat final | **one-to-one** ke pengajuan_surat (`pengajuan_id UNIQUE`) |

File: `sql/schema.sql` (struktur), `sql/seed.sql` (data contoh), `sql/schema.dbml` (opsional untuk dbdiagram).

## 3. Langkah Pengerjaan
### A. Database
1. Install PostgreSQL, buat database: `CREATE DATABASE sipas_desa;`
2. Jalankan di terminal VS Code:
   ```bash
   psql -U postgres -d sipas_desa -f sql/schema.sql
   psql -U postgres -d sipas_desa -f sql/seed.sql
   ```
3. Cek: `psql -U postgres -d sipas_desa -c "\dt"` → harus muncul 11 tabel.

### B. dbdiagram.io
1. Login/daftar di https://dbdiagram.io
2. **Import → From SQL → PostgreSQL**, paste isi `sql/schema.sql` (atau paste `sql/schema.dbml` di editor).
3. Simpan, klik **Share → Public**, salin link ke form pengumpulan.

### C. REST API
1. `npm install`
2. Salin `.env.example` menjadi `.env`, isi password PostgreSQL Anda.
3. `npm start` (atau `npm run dev`) → server di http://localhost:3000
4. Import `postman/SIPAS-Desa.postman_collection.json` ke Postman, jalankan 5 request, screenshot hasilnya.

### D. Pengumpulan
- `.gitignore` sudah berisi `node_modules` dan `.env`.
- GitHub: `git init && git add . && git commit -m "SIPAS Desa" ` → buat repo **Public** → `git remote add origin <url> && git push -u origin main`.

## 4. Endpoint (resource `jenis_surat`)
| Method | Route | Fungsi | Status sukses |
|---|---|---|---|
| GET | `/jenis-surat` | Semua data | 200 |
| GET | `/jenis-surat/:id` | Detail + daftar persyaratan (JOIN pivot) | 200 |
| POST | `/jenis-surat` | Tambah | 201 |
| PUT | `/jenis-surat/:id` | Ubah | 200 |
| DELETE | `/jenis-surat/:id` | Hapus | 200 |

Body POST/PUT:
```json
{ "kode": "SKTM", "nama": "Surat Keterangan Tidak Mampu", "deskripsi": "Untuk warga kurang mampu" }
```
Error: 400 (validasi/id bukan angka), 404 (tidak ditemukan), 409 (kode duplikat, atau dihapus saat masih dipakai pengajuan).

## 5. Struktur Project
```
sipas-desa/
├── sql/ (schema.sql, seed.sql, schema.dbml)
├── src/ (config/db.js, controllers, routes, middlewares, app.js, server.js)
├── postman/ (collection)
├── .env.example  .gitignore  package.json  README.md
```
