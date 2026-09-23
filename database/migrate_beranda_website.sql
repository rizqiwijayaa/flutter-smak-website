-- Sumber data untuk setiap section Beranda Website.
CREATE TABLE IF NOT EXISTS beranda_tentang (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  label VARCHAR(120) NULL, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL,
  gambar VARCHAR(255) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS beranda_statistik (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(100) NOT NULL, nilai VARCHAR(40) NOT NULL, icon VARCHAR(80) NULL,
  urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS beranda_program (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL,
  icon VARCHAR(80) NULL, warna VARCHAR(30) NULL, urutan INT NOT NULL DEFAULT 0,
  status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS beranda_kehidupan (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(120) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL,
  urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO beranda_tentang (label, judul, deskripsi, status)
SELECT 'Mengenal Lebih Dekat', 'Pendidikan yang Bertumbuh dalam Iman dan Ilmu', 'SMAK Mgr. Soegijapranata Lumajang adalah sekolah menengah atas Katolik yang berkomitmen mencetak generasi muda yang unggul secara akademik, berkarakter kuat, dan berwawasan global.', 'aktif'
WHERE NOT EXISTS (SELECT 1 FROM beranda_tentang);
INSERT INTO beranda_statistik (judul, nilai, urutan, status)
SELECT 'Terakreditasi', 'A', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM beranda_statistik);
INSERT INTO beranda_program (judul, deskripsi, urutan, status) VALUES
('Pembelajaran Berbasis Proyek','Mendorong siswa berpikir kritis, kreatif, dan kolaboratif.',1,'aktif'),
('Penguatan Karakter & Iman','Pembinaan karakter melalui nilai Kristiani dan kehidupan bersama.',2,'aktif'),
('Pengembangan Prestasi','Fasilitasi untuk meraih prestasi akademik maupun nonakademik.',3,'aktif'),
('Literasi Digital','Menguasai teknologi informasi untuk menghadapi tantangan era digital.',4,'aktif');
