INSERT INTO warga (nik, nama_lengkap, tempat_lahir, tanggal_lahir, jenis_kelamin, alamat, rt, rw, no_hp) VALUES
('3201010101900001','Siti Aminah','Bogor','1990-01-01','P','Jl. Melati No. 5','001','002','081200000001'),
('3201010202850002','Budi Santoso','Bogor','1985-02-02','L','Jl. Mawar No. 10','002','002','081200000002'),
('3201010303950003','Rina Wulandari','Depok','1995-03-03','P','Jl. Kenanga No. 7','003','001','081200000003');

INSERT INTO akun_warga (warga_id, email, password) VALUES
(1,'siti@example.com','$2b$10$hashcontohsiti'),
(2,'budi@example.com','$2b$10$hashcontohbudi');

INSERT INTO perangkat_desa (nip, nama, jabatan, email, password) VALUES
('198001012005011001','Pak Hendra','Kepala Desa','hendra@desa.id','$2b$10$hashcontoh'),
('198505052010012002','Bu Lestari','Sekretaris Desa','lestari@desa.id','$2b$10$hashcontoh');

INSERT INTO jenis_surat (kode, nama, deskripsi) VALUES
('SKD','Surat Keterangan Domisili','Menerangkan tempat tinggal warga'),
('SPS','Surat Pengantar SKCK','Pengantar pembuatan SKCK ke kepolisian'),
('SKU','Surat Keterangan Usaha','Menerangkan warga memiliki usaha');

INSERT INTO persyaratan (nama, keterangan) VALUES
('Fotokopi KTP','KTP asli yang discan/foto jelas'),
('Fotokopi Kartu Keluarga','KK terbaru'),
('Surat Pengantar RT/RW','Ditandatangani ketua RT dan RW'),
('Pas Foto 4x6','Latar merah/biru'),
('Foto Tempat Usaha','Foto tampak depan usaha');

INSERT INTO jenis_surat_persyaratan (jenis_surat_id, persyaratan_id, wajib) VALUES
(1,1,TRUE),(1,2,TRUE),(1,3,TRUE),
(2,1,TRUE),(2,2,TRUE),(2,3,TRUE),(2,4,TRUE),
(3,1,TRUE),(3,3,TRUE),(3,5,TRUE);

INSERT INTO pengajuan_surat (no_pengajuan, warga_id, jenis_surat_id, keperluan, status) VALUES
('PGJ-20261109-001',1,1,'Persyaratan administrasi bank','terbit'),
('PGJ-20261109-002',2,3,'Pengajuan kredit usaha','diverifikasi');

INSERT INTO dokumen_pengajuan (pengajuan_id, persyaratan_id, nama_file, path_file) VALUES
(1,1,'ktp_siti.jpg','uploads/ktp_siti.jpg'),
(1,2,'kk_siti.jpg','uploads/kk_siti.jpg'),
(1,3,'pengantar_rt_siti.pdf','uploads/pengantar_rt_siti.pdf'),
(2,1,'ktp_budi.jpg','uploads/ktp_budi.jpg'),
(2,3,'pengantar_rt_budi.pdf','uploads/pengantar_rt_budi.pdf'),
(2,5,'usaha_budi.jpg','uploads/usaha_budi.jpg');

INSERT INTO verifikasi_pengajuan (pengajuan_id, perangkat_desa_id, hasil, catatan) VALUES
(1,2,'valid','Dokumen lengkap'),
(2,2,'valid','Dokumen lengkap, menunggu persetujuan kades');

INSERT INTO riwayat_status (pengajuan_id, status, keterangan) VALUES
(1,'diajukan','Pengajuan dibuat warga'),
(1,'diverifikasi','Diverifikasi Sekretaris Desa'),
(1,'disetujui','Disetujui Kepala Desa'),
(1,'terbit','Surat diterbitkan'),
(2,'diajukan','Pengajuan dibuat warga'),
(2,'diverifikasi','Diverifikasi Sekretaris Desa');

INSERT INTO surat_terbit (pengajuan_id, nomor_surat, file_surat, ditandatangani_oleh) VALUES
(1,'470/001/SKD/XI/2026','surat/SKD-001.pdf',1);
