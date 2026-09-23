CREATE TABLE IF NOT EXISTS `jadwal_konten` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `judul` VARCHAR(180) NOT NULL,
    `data_json` LONGTEXT NOT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'aktif',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `jadwal_konten` (`judul`, `data_json`)
SELECT 'Jadwal Pelajaran', '{"breadcrumb":"Beranda  >  Akademik  >  Jadwal Pelajaran","hero_title":"Jadwal Pelajaran","hero_subtitle":"Informasi jadwal kegiatan belajar mengajar SMAK Mgr. Soegijapranata.","hero_image":"assets/images/1030.JPG","page_title":"Jadwal Pelajaran","page_subtitle":"Pilih tahun ajaran, tingkat, dan kelas untuk melihat jadwal pelajaran.","schedule_note":"Catatan: Jadwal dapat berubah sewaktu-waktu sesuai kebijakan sekolah.","timing_title":"Keterangan Jam Pelajaran","information_title":"Informasi Jadwal","information_text":"Perubahan jadwal pelajaran akan diinformasikan oleh wali kelas melalui pengumuman resmi sekolah. Pastikan untuk selalu memeriksa informasi terbaru.","pdf_button_label":"Unduh Jadwal PDF","contact_button_label":"Hubungi Sekolah","reminder_text":"Pastikan selalu memeriksa pembaruan jadwal sebelum kegiatan belajar dimulai.","pdf_url":""}'
WHERE NOT EXISTS (SELECT 1 FROM `jadwal_konten`);
