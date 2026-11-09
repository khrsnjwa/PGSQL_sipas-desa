-- =====================================================================
-- Sistem Informasi Pelayanan Administrasi Surat Desa (SIPAS Desa)
-- Database: PostgreSQL
-- =====================================================================

DROP TABLE IF EXISTS surat_terbit CASCADE;
DROP TABLE IF EXISTS riwayat_status CASCADE;
DROP TABLE IF EXISTS verifikasi_pengajuan CASCADE;
DROP TABLE IF EXISTS dokumen_pengajuan CASCADE;
DROP TABLE IF EXISTS pengajuan_surat CASCADE;
DROP TABLE IF EXISTS jenis_surat_persyaratan CASCADE;
DROP TABLE IF EXISTS persyaratan CASCADE;
DROP TABLE IF EXISTS jenis_surat CASCADE;
DROP TABLE IF EXISTS perangkat_desa CASCADE;
DROP TABLE IF EXISTS akun_warga CASCADE;
DROP TABLE IF EXISTS warga CASCADE;

-- 1. warga ------------------------------------------------------------
CREATE TABLE warga (
    id            SERIAL PRIMARY KEY,
    nik           CHAR(16)     NOT NULL UNIQUE,
    nama_lengkap  VARCHAR(100) NOT NULL,
    tempat_lahir  VARCHAR(50),
    tanggal_lahir DATE,
    jenis_kelamin CHAR(1)      CHECK (jenis_kelamin IN ('L','P')),
    alamat        TEXT,
    rt            VARCHAR(3),
    rw            VARCHAR(3),
    no_hp         VARCHAR(20),
    created_at    TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 2. akun_warga (ONE-TO-ONE ke warga) --------------------------------
CREATE TABLE akun_warga (
    id         SERIAL PRIMARY KEY,
    warga_id   INTEGER      NOT NULL UNIQUE          -- UNIQUE => one-to-one
               REFERENCES warga(id) ON DELETE CASCADE,
    email      VARCHAR(100) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    is_active  BOOLEAN      NOT NULL DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 3. perangkat_desa --------------------------------------------------
CREATE TABLE perangkat_desa (
    id         SERIAL PRIMARY KEY,
    nip        VARCHAR(20),
    nama       VARCHAR(100) NOT NULL,
    jabatan    VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 4. jenis_surat (master) -------------------------------------------
CREATE TABLE jenis_surat (
    id         SERIAL PRIMARY KEY,
    kode       VARCHAR(20)  NOT NULL UNIQUE,
    nama       VARCHAR(100) NOT NULL,
    deskripsi  TEXT,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- 5. persyaratan (master) -------------------------------------------
CREATE TABLE persyaratan (
    id         SERIAL PRIMARY KEY,
    nama       VARCHAR(100) NOT NULL UNIQUE,
    keterangan TEXT
);

-- 6. jenis_surat_persyaratan (pivot => MANY-TO-MANY) -----------------
CREATE TABLE jenis_surat_persyaratan (
    jenis_surat_id INTEGER NOT NULL REFERENCES jenis_surat(id) ON DELETE CASCADE,
    persyaratan_id INTEGER NOT NULL REFERENCES persyaratan(id) ON DELETE CASCADE,
    wajib          BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (jenis_surat_id, persyaratan_id)
);

-- 7. pengajuan_surat (ONE-TO-MANY dari warga & jenis_surat) ----------
CREATE TABLE pengajuan_surat (
    id               SERIAL PRIMARY KEY,
    no_pengajuan     VARCHAR(30) NOT NULL UNIQUE,
    warga_id         INTEGER NOT NULL REFERENCES warga(id)       ON DELETE RESTRICT,
    jenis_surat_id   INTEGER NOT NULL REFERENCES jenis_surat(id) ON DELETE RESTRICT,
    keperluan        TEXT,
    status           VARCHAR(20) NOT NULL DEFAULT 'diajukan'
                     CHECK (status IN ('diajukan','diverifikasi','ditolak','disetujui','terbit')),
    tanggal_pengajuan TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 8. dokumen_pengajuan (ONE-TO-MANY dari pengajuan_surat) ------------
CREATE TABLE dokumen_pengajuan (
    id            SERIAL PRIMARY KEY,
    pengajuan_id  INTEGER NOT NULL REFERENCES pengajuan_surat(id) ON DELETE CASCADE,
    persyaratan_id INTEGER NOT NULL REFERENCES persyaratan(id)    ON DELETE RESTRICT,
    nama_file     VARCHAR(255) NOT NULL,
    path_file     VARCHAR(255) NOT NULL,
    uploaded_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 9. verifikasi_pengajuan (ONE-TO-MANY dari pengajuan_surat) ---------
CREATE TABLE verifikasi_pengajuan (
    id               SERIAL PRIMARY KEY,
    pengajuan_id     INTEGER NOT NULL REFERENCES pengajuan_surat(id) ON DELETE CASCADE,
    perangkat_desa_id INTEGER NOT NULL REFERENCES perangkat_desa(id) ON DELETE RESTRICT,
    hasil            VARCHAR(10) NOT NULL CHECK (hasil IN ('valid','tidak_valid')),
    catatan          TEXT,
    verified_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 10. riwayat_status (ONE-TO-MANY dari pengajuan_surat) --------------
CREATE TABLE riwayat_status (
    id           SERIAL PRIMARY KEY,
    pengajuan_id INTEGER NOT NULL REFERENCES pengajuan_surat(id) ON DELETE CASCADE,
    status       VARCHAR(20) NOT NULL,
    keterangan   TEXT,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 11. surat_terbit (ONE-TO-ONE ke pengajuan_surat) -------------------
CREATE TABLE surat_terbit (
    id               SERIAL PRIMARY KEY,
    pengajuan_id     INTEGER NOT NULL UNIQUE                -- UNIQUE => one-to-one
                     REFERENCES pengajuan_surat(id) ON DELETE CASCADE,
    nomor_surat      VARCHAR(50) NOT NULL UNIQUE,
    file_surat       VARCHAR(255) NOT NULL,
    ditandatangani_oleh INTEGER REFERENCES perangkat_desa(id) ON DELETE SET NULL,
    tanggal_terbit   DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Index untuk foreign key yang sering di-query
CREATE INDEX idx_pengajuan_warga   ON pengajuan_surat(warga_id);
CREATE INDEX idx_pengajuan_jenis   ON pengajuan_surat(jenis_surat_id);
CREATE INDEX idx_pengajuan_status  ON pengajuan_surat(status);
CREATE INDEX idx_dokumen_pengajuan ON dokumen_pengajuan(pengajuan_id);
CREATE INDEX idx_riwayat_pengajuan ON riwayat_status(pengajuan_id);
