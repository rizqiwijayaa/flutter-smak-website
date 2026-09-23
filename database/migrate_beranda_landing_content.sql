-- Konten beranda yang sebelumnya masih ditulis langsung di frontend.
CREATE TABLE IF NOT EXISTS beranda_sambutan (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  label VARCHAR(120) NULL, judul VARCHAR(180) NOT NULL, jabatan VARCHAR(120) NULL,
  deskripsi TEXT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0,
  status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS beranda_ppdb (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  label VARCHAR(120) NULL, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL,
  gambar VARCHAR(255) NULL, teks_tombol_1 VARCHAR(80) NULL, link_tombol_1 VARCHAR(255) NULL,
  teks_tombol_2 VARCHAR(80) NULL, link_tombol_2 VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0,
  status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS beranda_kontak (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(120) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL,
  link VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0,
  status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS beranda_testimoni (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(120) NOT NULL, peran VARCHAR(120) NULL, deskripsi TEXT NULL,
  gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0,
  status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO beranda_sambutan (label, judul, jabatan, deskripsi, urutan, status)
SELECT 'Sambutan Kepala Sekolah', 'Drs. Andreas Prasetyo', 'Kepala Sekolah', 'Selamat datang di SMAK Mgr. Soegijapranata Lumajang. Kami percaya bahwa setiap siswa adalah pribadi unik yang diciptakan Tuhan dengan potensi luar biasa. Melalui pendidikan yang berlandaskan iman, ilmu, dan kasih, kami berkomitmen membimbing mereka menjadi generasi yang cerdas, berintegritas, dan siap berkarya bagi masyarakat.', 1, 'aktif'
WHERE NOT EXISTS (SELECT 1 FROM beranda_sambutan);

INSERT INTO beranda_ppdb (label, judul, deskripsi, teks_tombol_1, link_tombol_1, teks_tombol_2, link_tombol_2, urutan, status)
SELECT 'PPDB 2026/2027', 'Siap Menjadi Bagian dari SMAK?', 'Bergabunglah bersama kami dan raih masa depan gemilang. Pendaftaran peserta didik baru telah dibuka.', 'Daftar Sekarang', '/ppdb', 'Informasi PPDB', '/ppdb', 1, 'aktif'
WHERE NOT EXISTS (SELECT 1 FROM beranda_ppdb);

INSERT INTO beranda_kontak (judul, deskripsi, icon, link, urutan, status)
SELECT 'Kunjungi SMAK', 'Jl. Diponegoro No. 63, Lumajang', 'location', 'https://www.google.com/maps/search/?api=1&query=SMAK+Mgr.+Soegijapranata+Lumajang', 1, 'aktif'
WHERE NOT EXISTS (SELECT 1 FROM beranda_kontak);
INSERT INTO beranda_kontak (judul, deskripsi, icon, urutan, status)
SELECT 'Hubungi Kami', '(0334) 890123', 'phone', 2, 'aktif'
WHERE (SELECT COUNT(*) FROM beranda_kontak) < 2;
INSERT INTO beranda_kontak (judul, deskripsi, icon, urutan, status)
SELECT 'Jam Operasional', 'Senin-Jumat, 07.00-15.00 WIB', 'schedule', 3, 'aktif'
WHERE (SELECT COUNT(*) FROM beranda_kontak) < 3;

INSERT INTO beranda_testimoni (judul, peran, deskripsi, urutan, status)
SELECT 'Angela Putri', 'Alumni 2022', 'SMAK memberi saya banyak pengalaman berharga, guru yang membimbing, dan lingkungan yang mendukung.', 1, 'aktif'
WHERE NOT EXISTS (SELECT 1 FROM beranda_testimoni);
INSERT INTO beranda_testimoni (judul, peran, deskripsi, urutan, status)
SELECT 'Bapak Yohan', 'Orang Tua Siswa', 'Anak saya berkembang pesat, tidak hanya secara akademik tetapi juga karakter dan imannya.', 2, 'aktif'
WHERE (SELECT COUNT(*) FROM beranda_testimoni) < 2;
