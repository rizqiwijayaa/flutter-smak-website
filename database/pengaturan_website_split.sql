-- Pisahkan pengaturan website berdasarkan tanggung jawab setiap tab admin.
-- Data awal disalin dari tabel pengaturan_website agar konfigurasi lama tetap utuh.

CREATE TABLE IF NOT EXISTS `pengaturan_identitas` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama_website` VARCHAR(150) NOT NULL,
  `subtitle_brand` VARCHAR(160) NOT NULL DEFAULT 'Sekolah Menengah Atas Katolik',
  `judul_browser` VARCHAR(180) NOT NULL,
  `tahun_copyright` CHAR(4) NOT NULL,
  `logo` VARCHAR(255) NOT NULL,
  `favicon` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pengaturan_tampilan` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `warna_utama` CHAR(7) NOT NULL DEFAULT '#1463E8',
  `warna_sekunder` CHAR(7) NOT NULL DEFAULT '#082F63',
  `gambar_fallback` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pengaturan_seo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `deskripsi_seo` VARCHAR(180) NOT NULL,
  `kata_kunci_seo` TEXT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pengaturan_status` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `website_active` TINYINT(1) NOT NULL DEFAULT 1,
  `maintenance_mode` TINYINT(1) NOT NULL DEFAULT 0,
  `maintenance_message` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `pengaturan_identitas`
  (`nama_website`, `subtitle_brand`, `judul_browser`, `tahun_copyright`, `logo`, `favicon`)
SELECT
  `nama_website`, 'Sekolah Menengah Atas Katolik', `judul_browser`, `tahun_copyright`, `logo`, `favicon`
FROM `pengaturan_website`
WHERE NOT EXISTS (SELECT 1 FROM `pengaturan_identitas`)
LIMIT 1;

INSERT INTO `pengaturan_tampilan`
  (`warna_utama`, `warna_sekunder`, `gambar_fallback`)
SELECT
  `warna_utama`, `warna_sekunder`, `gambar_fallback`
FROM `pengaturan_website`
WHERE NOT EXISTS (SELECT 1 FROM `pengaturan_tampilan`)
LIMIT 1;

INSERT INTO `pengaturan_seo`
  (`deskripsi_seo`, `kata_kunci_seo`)
SELECT
  `deskripsi_seo`, `kata_kunci_seo`
FROM `pengaturan_website`
WHERE NOT EXISTS (SELECT 1 FROM `pengaturan_seo`)
LIMIT 1;

INSERT INTO `pengaturan_status`
  (`website_active`, `maintenance_mode`, `maintenance_message`)
SELECT
  `website_aktif`, `mode_pemeliharaan`, `pesan_pemeliharaan`
FROM `pengaturan_website`
WHERE NOT EXISTS (SELECT 1 FROM `pengaturan_status`)
LIMIT 1;
