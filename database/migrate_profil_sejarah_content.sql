-- Memperluas modul Sejarah tanpa menghapus tabel atau data yang ada.
ALTER TABLE profil_sejarah
  ADD COLUMN subtitle VARCHAR(255) NULL AFTER judul,
  ADD COLUMN banner VARCHAR(255) NULL AFTER gambar,
  ADD COLUMN judul_perjalanan VARCHAR(255) NULL AFTER banner,
  ADD COLUMN kutipan TEXT NULL AFTER isi,
  ADD COLUMN sumber_kutipan VARCHAR(160) NULL AFTER kutipan,
  ADD COLUMN peserta_didik VARCHAR(30) NULL,
  ADD COLUMN guru_tenaga VARCHAR(30) NULL,
  ADD COLUMN fasilitas VARCHAR(30) NULL,
  ADD COLUMN prestasi VARCHAR(30) NULL;

CREATE TABLE IF NOT EXISTS profil_sejarah_timeline (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  sejarah_id BIGINT UNSIGNED NOT NULL,
  tahun VARCHAR(30) NOT NULL,
  judul VARCHAR(180) NOT NULL,
  deskripsi TEXT NULL,
  gambar VARCHAR(255) NULL,
  urutan INT NOT NULL DEFAULT 0,
  status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS profil_sejarah_era LIKE profil_sejarah_timeline;
CREATE TABLE IF NOT EXISTS profil_sejarah_nilai LIKE profil_sejarah_timeline;
CREATE TABLE IF NOT EXISTS profil_sejarah_galeri LIKE profil_sejarah_timeline;
CREATE TABLE IF NOT EXISTS profil_sejarah_tokoh LIKE profil_sejarah_timeline;
