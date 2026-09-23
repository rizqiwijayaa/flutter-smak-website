<?php

declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Methods: GET, OPTIONS, POST');
header('Cache-Control: no-cache, no-store, must-revalidate');
header('Pragma: no-cache');

ini_set('display_errors', '0');
mysqli_report(MYSQLI_REPORT_OFF);

function apiServerError(): void
{
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Terjadi kesalahan server. Silakan coba lagi.']);
    exit;
}

set_error_handler(static function (int $severity, string $message, string $file, int $line): bool {
    error_log('SMAK API PHP error: severity=' . $severity . ' file=' . basename($file) . ' line=' . $line);
    apiServerError();
});
set_exception_handler(static function (Throwable $error): void {
    error_log('SMAK API exception: type=' . get_class($error) . ' code=' . $error->getCode() . ' file=' . basename($error->getFile()) . ' line=' . $error->getLine());
    apiServerError();
});

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

if (isset($_GET['file'])) {
    $filename = basename((string) $_GET['file']);
    $filePath = __DIR__ . '/uploads/' . $filename;
    if (!is_file($filePath)) {
        http_response_code(404);
        echo json_encode(['success' => false, 'message' => 'File tidak ditemukan.']);
        exit;
    }
    $extension = strtolower(pathinfo($filePath, PATHINFO_EXTENSION));
    $mimeTypes = [
        'jpg' => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'gif' => 'image/gif',
        'webp' => 'image/webp',
        'mp4' => 'video/mp4',
        'webm' => 'video/webm',
        'mov' => 'video/quicktime',
        'avi' => 'video/x-msvideo',
        'mkv' => 'video/x-matroska',
        'pdf' => 'application/pdf',
        'doc' => 'application/msword',
        'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    ];
    $mimeType = $mimeTypes[$extension] ?? (function_exists('mime_content_type') ? (@mime_content_type($filePath) ?: 'application/octet-stream') : 'application/octet-stream');
    header('Access-Control-Allow-Origin: *');
    header('Content-Type: ' . $mimeType);
    readfile($filePath);
    exit;
}

require __DIR__ . '/config.php';

$allowedTables = [
    'akademik',
    'kurikulum_utama',
    'kurikulum_hero',
    'kurikulum_pengantar',
    'kurikulum_prinsip',
    'kurikulum_kerangka',
    'kurikulum_mata_pelajaran',
    'kurikulum_pendekatan',
    'kurikulum_program',
    'kurikulum_penilaian',
    'kurikulum_komitmen',
    'kurikulum_cta',
    'kalender_utama',
    'kalender_agenda',
    'akademik_prestasi',
    'akademik_hero',
    'akademik_prestasi_statistik',
    'akademik_prestasi_unggulan',
    'akademik_prestasi_terbaru',
    'akademik_bidang_prestasi',
    'akademik_pembinaan_prestasi',
    'akademik_kutipan_siswa',
    'akademik_perjalanan_prestasi',
    'akademik_prestasi_cta',
    'prestasisiswa_konten',
    'prestasisiswa_prestasi',
    'prestasisiswa_bidang',
    'prestasisiswa_pembinaan',
    'prestasisiswa_perjalanan',
    'prestasisiswa_dokumentasi',
    'ekstrakulikuler_konten',
    'ekstrakulikuler_kegiatan',
    'berita',
    'beranda_tentang',
    'beranda_slider',
    'beranda_keunggulan',
    'beranda_statistik',
    'beranda_program',
    'beranda_kehidupan',
    'beranda_ppdb',
    'beranda_kontak',
    'beranda_testimoni',
    'galeri',
    'guru_karyawan',
    'jadwal_konten',
    'jadwal_pelajaran',
    'kesiswaan',
    'kontak',
    'ppdb',
    'pengaturan_identitas',
    'pengaturan_tampilan',
    'pengaturan_seo',
    'pengaturan_status',
    'pengaturan_footer',
    'pengaturan_login',
    'profil_identitas',
    'sambutan_kepala_sekolah',
    'sejarah_utama',
    'sejarah_timeline',
    'sejarah_era',
    'sejarah_nilai',
    'sejarah_galeri',
    'sejarah_tokoh',
    'sejarah_statistik',
    'sejarah_cta',
    'visi_utama',
    'visi_makna',
    'visi_misi',
    'visi_penerapan',
    'visi_nilai',
    'visi_tindakan',
    'visi_sasaran',
    'visi_cta',
    'struktur_utama',
    'struktur_bagian',
    'struktur_bagan',
    'struktur_pimpinan',
    'struktur_guru',
    'struktur_karyawan',
    'struktur_kategori_guru',
    'struktur_statistik',
    'struktur_cta',
    'tatib_konten',
    'tatib_hero',
    'tatib_ringkasan',
    'tatib_ketentuan_umum',
    'tatib_prinsip',
    'tatib_kategori',
    'tatib_hak_siswa',
    'tatib_kewajiban_siswa',
    'tatib_pembinaan',
    'tatib_pelanggaran',
    'tatib_dokumen',
    'tatib_komitmen',
    'osis_hero',
    'osis_pengenalan',
    'osis_statistik',
    'osis_visi_misi',
    'osis_pengurus',
    'osis_bidang',
    'osis_program',
    'osis_agenda',
    'osis_galeri',
    'osis_kutipan',
    'osis_cta',
    'sarana_utama',
    'sarana_bagian',
    'sarana_poin_intro',
    'sarana_fasilitas_utama',
    'sarana_penunjang',
    'sarana_keagamaan',
    'sarana_keamanan',
    'sarana_galeri',
    'sarana_perawatan',
    'sarana_kutipan',
    'sarana_cta',
    'profil_struktur_organisasi',
    'profil_sarana_prasarana',
    'activity_logs',
    'admin_sessions',
    'login_attempts',
    'security_alerts',
    'users',
];

// Only these content tables allow anonymous generic reads.
$publicReadTables = [
    'beranda_slider',
    'beranda_keunggulan',
    'beranda_tentang',
    'beranda_program',
    'beranda_kehidupan',
    'beranda_statistik',
    'beranda_ppdb',
    'beranda_kontak',
    'beranda_testimoni',
    'berita',
    'galeri',
    'pengaturan_identitas',
    'pengaturan_tampilan',
    'pengaturan_seo',
    'pengaturan_status',
    'pengaturan_footer',
    'pengaturan_login',
    'profil_identitas',
    'sambutan_kepala_sekolah',
    'sejarah_utama',
    'sejarah_timeline',
    'sejarah_era',
    'sejarah_nilai',
    'sejarah_galeri',
    'sejarah_tokoh',
    'sejarah_statistik',
    'sejarah_cta',
    'visi_utama',
    'visi_makna',
    'visi_misi',
    'visi_penerapan',
    'visi_nilai',
    'visi_tindakan',
    'visi_sasaran',
    'visi_cta',
    'struktur_utama',
    'struktur_bagian',
    'struktur_bagan',
    'struktur_pimpinan',
    'struktur_guru',
    'struktur_karyawan',
    'struktur_kategori_guru',
    'struktur_statistik',
    'struktur_cta',
    'sarana_utama',
    'sarana_bagian',
    'sarana_poin_intro',
    'sarana_fasilitas_utama',
    'sarana_penunjang',
    'sarana_keagamaan',
    'sarana_keamanan',
    'sarana_galeri',
    'sarana_perawatan',
    'sarana_kutipan',
    'sarana_cta',
    'kurikulum_hero',
    'kurikulum_pengantar',
    'kurikulum_prinsip',
    'kurikulum_kerangka',
    'kurikulum_mata_pelajaran',
    'kurikulum_pendekatan',
    'kurikulum_program',
    'kurikulum_penilaian',
    'kurikulum_komitmen',
    'kurikulum_cta',
    'kalender_utama',
    'kalender_agenda',
    'jadwal_pelajaran',
    'jadwal_konten',
    'akademik_hero',
    'akademik_prestasi',
    'akademik_bidang_prestasi',
    'akademik_pembinaan_prestasi',
    'prestasisiswa_konten',
    'prestasisiswa_prestasi',
    'prestasisiswa_bidang',
    'prestasisiswa_pembinaan',
    'prestasisiswa_perjalanan',
    'prestasisiswa_dokumentasi',
    'ekstrakulikuler_konten',
    'ekstrakulikuler_kegiatan',
    'tatib_konten',
    'osis_hero',
    'osis_pengenalan',
    'osis_statistik',
    'osis_visi_misi',
    'osis_pengurus',
    'osis_bidang',
    'osis_program',
    'osis_agenda',
    'osis_galeri',
    'osis_kutipan',
    'osis_cta',
    'kontak',
    'ppdb',
];

// Bootstrap definitions are retained for reference; requests must not run them.
function ensurePengaturanFooterTable(mysqli $connection): void
{
    $createQuery = "CREATE TABLE IF NOT EXISTS pengaturan_footer (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        slogan VARCHAR(255) NULL,
        deskripsi TEXT NULL,
        whatsapp VARCHAR(40) NULL,
        instagram VARCHAR(255) NULL,
        alamat TEXT NULL,
        link_maps VARCHAR(255) NULL,
        telepon VARCHAR(80) NULL,
        provinsi VARCHAR(120) NULL,
        hari_operasional VARCHAR(120) NULL,
        jam_operasional VARCHAR(120) NULL,
        motto VARCHAR(180) NULL,
        arti_motto VARCHAR(255) NULL,
        created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
    if (!$connection->query($createQuery)) {
        throw new RuntimeException($connection->error);
    }

    $seedQuery = "INSERT INTO pengaturan_footer (
        slogan, deskripsi, whatsapp, instagram, alamat, link_maps, telepon,
        provinsi, hari_operasional, jam_operasional, motto, arti_motto
    ) SELECT
        'Beriman • Berilmu • Berkarakter',
        'Membentuk generasi muda yang cerdas,\\nberiman, dan siap berkarya bagi\\nmasyarakat.',
        '628155099445',
        'https://www.instagram.com/soegijapranata_lmj/',
        'V68H+JGC, Jogoyudan, Kec. Lumajang,\\nKabupaten Lumajang, Jawa Timur 67315',
        'https://maps.app.goo.gl/4fkeEUXRpV5URvkeA',
        '0815-5099-445',
        'Jawa Timur',
        'Senin - Jumat',
        '07.00 - 15.00 WIB',
        'Ora et Labora',
        'Berdoa dan Bekerja'
    WHERE NOT EXISTS (SELECT 1 FROM pengaturan_footer)";
    if (!$connection->query($seedQuery)) {
        throw new RuntimeException($connection->error);
    }
}


function ensureBerandaLandingTables(mysqli $connection): void
{
    $queries = [
        "CREATE TABLE IF NOT EXISTS beranda_slider (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, nama_singkat VARCHAR(40) NULL DEFAULT 'SMAK', nama_panjang VARCHAR(160) NULL DEFAULT 'Sekolah Menengah Atas Katolik', subjudul TEXT NULL, judul_program VARCHAR(100) NULL, subjudul_program VARCHAR(300) NULL, judul_kehidupan VARCHAR(100) NULL, subjudul_kehidupan VARCHAR(300) NULL, judul_prestasi VARCHAR(100) NULL, subjudul_prestasi VARCHAR(300) NULL, judul_berita VARCHAR(100) NULL, judul_galeri VARCHAR(100) NULL, teks_tombol_tentang VARCHAR(80) NULL, link_tombol_tentang VARCHAR(255) NULL, teks_tombol_sambutan VARCHAR(80) NULL, link_tombol_sambutan VARCHAR(255) NULL, teks_tombol_kesiswaan VARCHAR(80) NULL, link_tombol_kesiswaan VARCHAR(255) NULL, teks_lihat_semua VARCHAR(80) NULL, teks_tombol_lokasi VARCHAR(80) NULL, gambar VARCHAR(255) NULL, teks_tombol_1 VARCHAR(80) NULL, link_tombol_1 VARCHAR(255) NULL, teks_tombol_2 VARCHAR(80) NULL, link_tombol_2 VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS beranda_keunggulan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, warna VARCHAR(20) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS beranda_tentang (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, label VARCHAR(120) NULL, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS beranda_program (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, icon VARCHAR(80) NULL, warna VARCHAR(20) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS beranda_kehidupan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS beranda_statistik (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(120) NOT NULL, nilai VARCHAR(80) NOT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS beranda_ppdb (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, label VARCHAR(120) NULL, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, teks_tombol_1 VARCHAR(80) NULL, link_tombol_1 VARCHAR(255) NULL, teks_tombol_2 VARCHAR(80) NULL, link_tombol_2 VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS beranda_kontak (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(120) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, link VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS beranda_testimoni (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(120) NOT NULL, peran VARCHAR(120) NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "INSERT INTO beranda_ppdb (label, judul, deskripsi, teks_tombol_1, link_tombol_1, teks_tombol_2, link_tombol_2, urutan, status) SELECT 'PPDB 2026/2027', 'Siap Menjadi Bagian dari SMAK?', 'Bergabunglah bersama kami dan raih masa depan gemilang. Pendaftaran peserta didik baru telah dibuka.', 'Daftar Sekarang', '/ppdb', 'Informasi PPDB', '/ppdb', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM beranda_ppdb)",
        "INSERT INTO beranda_kehidupan (judul, deskripsi, urutan, status) SELECT 'Akademik', 'Kegiatan pembelajaran siswa.', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM beranda_kehidupan)",
        "INSERT INTO beranda_kehidupan (judul, deskripsi, urutan, status) SELECT 'Ibadah', 'Kegiatan iman dan pelayanan.', 2, 'aktif' WHERE (SELECT COUNT(*) FROM beranda_kehidupan) < 2",
        "INSERT INTO beranda_kehidupan (judul, deskripsi, urutan, status) SELECT 'Olahraga', 'Kegiatan olahraga siswa.', 3, 'aktif' WHERE (SELECT COUNT(*) FROM beranda_kehidupan) < 3",
        "INSERT INTO beranda_kehidupan (judul, deskripsi, urutan, status) SELECT 'Seni & Budaya', 'Kegiatan seni dan budaya.', 4, 'aktif' WHERE (SELECT COUNT(*) FROM beranda_kehidupan) < 4",
        "INSERT INTO beranda_kehidupan (judul, deskripsi, urutan, status) SELECT 'Organisasi Siswa', 'Kegiatan organisasi siswa.', 5, 'aktif' WHERE (SELECT COUNT(*) FROM beranda_kehidupan) < 5",
        "INSERT INTO beranda_kontak (judul, deskripsi, icon, link, urutan, status) SELECT 'Kunjungi SMAK', 'Jl. Diponegoro No. 63, Lumajang', 'location', 'https://www.google.com/maps/search/?api=1&query=SMAK+Mgr.+Soegijapranata+Lumajang', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM beranda_kontak)",
        "INSERT INTO beranda_kontak (judul, deskripsi, icon, urutan, status) SELECT 'Hubungi Kami', '(0334) 890123', 'phone', 2, 'aktif' WHERE (SELECT COUNT(*) FROM beranda_kontak) < 2",
        "INSERT INTO beranda_kontak (judul, deskripsi, icon, urutan, status) SELECT 'Jam Operasional', 'Senin-Jumat, 07.00-15.00 WIB', 'schedule', 3, 'aktif' WHERE (SELECT COUNT(*) FROM beranda_kontak) < 3",
        "INSERT INTO beranda_testimoni (judul, peran, deskripsi, urutan, status) SELECT 'Angela Putri', 'Alumni 2022', 'SMAK memberi saya banyak pengalaman berharga, guru yang membimbing, dan lingkungan yang mendukung.', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM beranda_testimoni)",
        "INSERT INTO beranda_testimoni (judul, peran, deskripsi, urutan, status) SELECT 'Bapak Yohan', 'Orang Tua Siswa', 'Anak saya berkembang pesat, tidak hanya secara akademik tetapi juga karakter dan imannya.', 2, 'aktif' WHERE (SELECT COUNT(*) FROM beranda_testimoni) < 2",
    ];
    foreach ($queries as $query) {
        if (!$connection->query($query)) {
            throw new RuntimeException($connection->error);
        }
    }

    $legacyMigrations = [
        'slider' => "INSERT INTO beranda_slider (judul, subjudul, gambar, teks_tombol_1, link_tombol_1, teks_tombol_2, link_tombol_2, urutan, status) SELECT judul, subjudul, gambar, teks_tombol_1, link_tombol_1, teks_tombol_2, link_tombol_2, urutan, status FROM slider WHERE NOT EXISTS (SELECT 1 FROM beranda_slider)",
        'keunggulan' => "INSERT INTO beranda_keunggulan (judul, deskripsi, icon, warna, urutan, status) SELECT judul, deskripsi, icon, warna, urutan, status FROM keunggulan WHERE NOT EXISTS (SELECT 1 FROM beranda_keunggulan)",
    ];
    foreach ($legacyMigrations as $legacyTable => $query) {
        $legacyExists = $connection->query("SHOW TABLES LIKE '$legacyTable'");
        if ($legacyExists && $legacyExists->num_rows > 0 && !$connection->query($query)) {
            throw new RuntimeException($connection->error);
        }
    }
}


function ensureSambutanKepalaSekolahTable(mysqli $connection): void
{
    $createQuery = "CREATE TABLE IF NOT EXISTS sambutan_kepala_sekolah (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        judul VARCHAR(180) NOT NULL,
        subtitle TEXT NULL,
        isi LONGTEXT NULL,
        gambar VARCHAR(255) NULL,
        banner VARCHAR(255) NULL,
        nama_kepala VARCHAR(180) NULL,
        jabatan VARCHAR(180) NULL,
        masa_jabatan VARCHAR(120) NULL,
        telepon VARCHAR(80) NULL,
        email VARCHAR(180) NULL,
        alamat TEXT NULL,
        sosial_json LONGTEXT NULL,
        kutipan TEXT NULL,
        sumber_kutipan VARCHAR(180) NULL,
        pesan TEXT NULL,
        motto TEXT NULL,
        komitmen_json LONGTEXT NULL,
        harapan_json LONGTEXT NULL,
        program_prioritas_json LONGTEXT NULL,
        kegiatan_kepala_json LONGTEXT NULL,
        penutup LONGTEXT NULL,
        status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
        created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )";
    if (!$connection->query($createQuery)) {
        throw new RuntimeException($connection->error);
    }

    $legacyExists = $connection->query("SHOW TABLES LIKE 'profil_sambutan'");
    if (!$legacyExists || $legacyExists->num_rows === 0) return;

    $migrateQuery = "INSERT INTO sambutan_kepala_sekolah (
        judul, subtitle, isi, gambar, banner, nama_kepala, jabatan,
        masa_jabatan, telepon, email, alamat, sosial_json, kutipan,
        sumber_kutipan, pesan, motto, komitmen_json, harapan_json,
        program_prioritas_json, kegiatan_kepala_json, penutup, status
    ) SELECT
        judul, subtitle, isi, gambar, banner, nama_kepala, jabatan,
        masa_jabatan, telepon, email, alamat, sosial_json, kutipan,
        sumber_kutipan, pesan, motto, komitmen_json, harapan_json,
        program_prioritas_json, kegiatan_kepala_json, penutup, status
    FROM profil_sambutan
    WHERE NOT EXISTS (SELECT 1 FROM sambutan_kepala_sekolah)";
    if (!$connection->query($migrateQuery)) {
        throw new RuntimeException($connection->error);
    }
}


function ensureSejarahTables(mysqli $connection): void
{
    $queries = [
        "CREATE TABLE IF NOT EXISTS sejarah_utama (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, subtitle TEXT NULL, isi LONGTEXT NULL, kutipan TEXT NULL, sumber_kutipan VARCHAR(180) NULL, gambar VARCHAR(255) NULL, banner VARCHAR(255) NULL, judul_perjalanan VARCHAR(180) NULL, peserta_didik VARCHAR(40) NULL, guru_tenaga VARCHAR(40) NULL, fasilitas VARCHAR(40) NULL, prestasi VARCHAR(40) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sejarah_timeline (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, tahun VARCHAR(20) NOT NULL, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sejarah_era (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, tahun VARCHAR(20) NULL, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sejarah_nilai (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sejarah_galeri (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, tahun VARCHAR(20) NULL, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sejarah_tokoh (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, nama VARCHAR(180) NOT NULL, peran VARCHAR(180) NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sejarah_statistik (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(120) NOT NULL, nilai VARCHAR(60) NOT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sejarah_cta (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, teks_tombol_1 VARCHAR(80) NULL, link_tombol_1 VARCHAR(255) NULL, teks_tombol_2 VARCHAR(80) NULL, link_tombol_2 VARCHAR(255) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "INSERT INTO sejarah_timeline (tahun, judul, deskripsi, urutan, status) SELECT '1983','Awal Berdiri','SMAK Mgr. Soegijapranata resmi berdiri sebagai karya pendidikan Katolik yang menanamkan iman dan karakter.',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sejarah_timeline)",
        "INSERT INTO sejarah_timeline (tahun, judul, deskripsi, urutan, status) SELECT '1995','Pengembangan Sekolah','Sekolah bertumbuh dengan penambahan ruang kelas, laboratorium, dan layanan pendukung pembelajaran.',2,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_timeline) < 2",
        "INSERT INTO sejarah_timeline (tahun, judul, deskripsi, urutan, status) SELECT '2008','Transformasi Pendidikan','Penguatan kurikulum berbasis kompetensi dan kegiatan ekstrakurikuler.',3,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_timeline) < 3",
        "INSERT INTO sejarah_timeline (tahun, judul, deskripsi, urutan, status) SELECT '2018','Era Digital','Penguatan teknologi informasi dalam pembelajaran dan komunikasi sekolah.',4,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_timeline) < 4",
        "INSERT INTO sejarah_timeline (tahun, judul, deskripsi, urutan, status) SELECT '2026','Melangkah ke Masa Depan','Inovasi baru untuk membentuk generasi berdaya saing global.',5,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_timeline) < 5",
        "INSERT INTO sejarah_nilai (judul, deskripsi, icon, urutan, status) SELECT 'Iman dan Karakter','Menumbuhkan pribadi beriman, berintegritas, dan peduli sesama.','favorite',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sejarah_nilai)",
        "INSERT INTO sejarah_nilai (judul, deskripsi, icon, urutan, status) SELECT 'Keunggulan Akademik','Mendorong budaya belajar, literasi, dan pencapaian terbaik.','school',2,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_nilai) < 2",
        "INSERT INTO sejarah_nilai (judul, deskripsi, icon, urutan, status) SELECT 'Pelayanan dan Kolaborasi','Bertumbuh bersama dalam semangat pelayanan dan kerja sama.','groups',3,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_nilai) < 3",
        "INSERT INTO sejarah_era (tahun, judul, deskripsi, urutan, status) SELECT '1983-1994','Masa Perintisan','Membangun pondasi pendidikan Katolik yang berkarakter.',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sejarah_era)",
        "INSERT INTO sejarah_era (tahun, judul, deskripsi, urutan, status) SELECT '1995-2017','Masa Pertumbuhan','Pengembangan fasilitas, kurikulum, dan layanan peserta didik.',2,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_era) < 2",
        "INSERT INTO sejarah_era (tahun, judul, deskripsi, urutan, status) SELECT '2018-Sekarang','Masa Transformasi','Penguatan inovasi dan pembelajaran digital.',3,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_era) < 3",
        "INSERT INTO sejarah_galeri (tahun, judul, deskripsi, urutan, status) SELECT '1983','Awal Berdiri','Gedung sekolah pada awal berdiri.',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sejarah_galeri)",
        "INSERT INTO sejarah_galeri (tahun, judul, deskripsi, urutan, status) SELECT '1995','Pengembangan Gedung','Pengembangan gedung kelas baru.',2,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_galeri) < 2",
        "INSERT INTO sejarah_galeri (tahun, judul, deskripsi, urutan, status) SELECT '2008','Kegiatan Laboratorium','Kegiatan belajar di laboratorium.',3,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_galeri) < 3",
        "INSERT INTO sejarah_galeri (tahun, judul, deskripsi, urutan, status) SELECT '2018','Pembelajaran Digital','Pembelajaran berbasis teknologi.',4,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_galeri) < 4",
        "INSERT INTO sejarah_tokoh (nama, peran, deskripsi, urutan, status) SELECT 'Mgr. Soegijapranata','Perintis','Inspirator dan pelopor berdirinya SMAK dengan semangat iman dan pendidikan karakter.',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sejarah_tokoh)",
        "INSERT INTO sejarah_tokoh (nama, peran, deskripsi, urutan, status) SELECT 'Drs. Yohanes Rudi','Kepala Sekolah','Memimpin masa transformasi dengan penguatan kualitas dan pengembangan sekolah.',2,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_tokoh) < 2",
        "INSERT INTO sejarah_statistik (judul, nilai, icon, urutan, status) SELECT 'Peserta Didik','1.256','school',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sejarah_statistik)",
        "INSERT INTO sejarah_statistik (judul, nilai, icon, urutan, status) SELECT 'Guru & Tenaga Pendidik','84','person',2,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_statistik) < 2",
        "INSERT INTO sejarah_statistik (judul, nilai, icon, urutan, status) SELECT 'Fasilitas Pendukung','20+','apartment',3,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_statistik) < 3",
        "INSERT INTO sejarah_statistik (judul, nilai, icon, urutan, status) SELECT 'Prestasi Diraih','150+','emoji_events',4,'aktif' WHERE (SELECT COUNT(*) FROM sejarah_statistik) < 4",
        "INSERT INTO sejarah_cta (judul, deskripsi, teks_tombol_1, link_tombol_1, teks_tombol_2, link_tombol_2, status) SELECT 'Melanjutkan Sejarah Bersama','Mari terus menulis sejarah baru, melahirkan generasi beriman, berilmu, dan berkarakter untuk masa depan bangsa.','Lihat Profil Sekolah','/profil','Hubungi Kami','https://wa.me/628155099445','aktif' WHERE NOT EXISTS (SELECT 1 FROM sejarah_cta)",
    ];
    foreach ($queries as $query) if (!$connection->query($query)) throw new RuntimeException($connection->error);
    $legacy = $connection->query("SHOW TABLES LIKE 'profil_sejarah'");
    if ($legacy && $legacy->num_rows > 0) {
        $migrate = "INSERT INTO sejarah_utama (judul, subtitle, isi, kutipan, sumber_kutipan, gambar, banner, judul_perjalanan, peserta_didik, guru_tenaga, fasilitas, prestasi, status) SELECT judul, subtitle, isi, kutipan, sumber_kutipan, gambar, banner, judul_perjalanan, peserta_didik, guru_tenaga, fasilitas, prestasi, status FROM profil_sejarah WHERE NOT EXISTS (SELECT 1 FROM sejarah_utama)";
        if (!$connection->query($migrate)) throw new RuntimeException($connection->error);
    }
}


function ensureVisiTables(mysqli $connection): void
{
    $queries = [
        "CREATE TABLE IF NOT EXISTS visi_utama (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, banner VARCHAR(255) NULL, arah_judul VARCHAR(180) NULL, arah_deskripsi TEXT NULL, visi TEXT NULL, logo VARCHAR(255) NULL, foto_kehidupan VARCHAR(255) NULL, quote TEXT NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS visi_makna (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS visi_misi (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS visi_penerapan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS visi_nilai LIKE visi_makna",
        "CREATE TABLE IF NOT EXISTS visi_tindakan LIKE visi_makna",
        "CREATE TABLE IF NOT EXISTS visi_sasaran LIKE visi_makna",
        "CREATE TABLE IF NOT EXISTS visi_cta (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, teks_tombol_1 VARCHAR(80) NULL, link_tombol_1 VARCHAR(255) NULL, teks_tombol_2 VARCHAR(80) NULL, link_tombol_2 VARCHAR(255) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "INSERT INTO visi_makna (judul,deskripsi,icon,urutan,status) SELECT 'Beriman','Menjadi pribadi yang beriman dan berkarakter.','favorite',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM visi_makna)",
        "INSERT INTO visi_misi (judul,deskripsi,icon,urutan,status) SELECT 'Pendidikan Berkualitas','Menyelenggarakan pendidikan yang unggul dan berkarakter.','school',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM visi_misi)",
        "INSERT INTO visi_nilai (judul,deskripsi,icon,urutan,status) SELECT 'Integritas','Bertindak jujur dan bertanggung jawab.','verified',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM visi_nilai)",
        "INSERT INTO visi_tindakan (judul,deskripsi,icon,urutan,status) SELECT 'Belajar dan Melayani','Menerapkan nilai sekolah dalam tindakan sehari-hari.','volunteer_activism',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM visi_tindakan)",
        "INSERT INTO visi_sasaran (judul,deskripsi,icon,urutan,status) SELECT 'Generasi Unggul','Membentuk generasi beriman, berilmu, dan berkarakter.','groups',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM visi_sasaran)",
        "INSERT INTO visi_cta (judul,deskripsi,teks_tombol_1,link_tombol_1,teks_tombol_2,link_tombol_2,status) SELECT 'Bersama Mewujudkan Visi SMAK','Bertumbuh dalam iman, ilmu, dan kasih.','Profil Sekolah','/profil','Hubungi Kami','https://wa.me/628155099445','aktif' WHERE NOT EXISTS (SELECT 1 FROM visi_cta)",
    ];
    foreach ($queries as $query) if (!$connection->query($query)) throw new RuntimeException($connection->error);
    $legacy = $connection->query("SHOW TABLES LIKE 'profil_visi_misi'");
    if ($legacy && $legacy->num_rows > 0 && !$connection->query("INSERT INTO visi_utama (judul,deskripsi,visi,logo,status) SELECT judul,isi,isi,gambar,status FROM profil_visi_misi WHERE NOT EXISTS (SELECT 1 FROM visi_utama)")) throw new RuntimeException($connection->error);
}

function ensureStrukturOrganisasiTables(mysqli $connection): void
{
    $queries = [
        "CREATE TABLE IF NOT EXISTS struktur_utama (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, breadcrumb VARCHAR(255) NULL, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, banner VARCHAR(255) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS struktur_bagian (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, kode VARCHAR(80) NOT NULL UNIQUE, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, rata_tengah TINYINT(1) NOT NULL DEFAULT 0, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS struktur_bagan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, nama VARCHAR(180) NULL, jabatan VARCHAR(180) NOT NULL, gambar VARCHAR(255) NULL, icon VARCHAR(80) NULL, level_bagan INT NOT NULL DEFAULT 0, tampil_foto TINYINT(1) NOT NULL DEFAULT 1, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS struktur_pimpinan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, nama VARCHAR(180) NOT NULL, jabatan VARCHAR(180) NOT NULL, keterangan VARCHAR(255) NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS struktur_guru (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, nama VARCHAR(180) NOT NULL, mata_pelajaran VARCHAR(180) NOT NULL, kategori VARCHAR(120) NOT NULL DEFAULT 'Guru Mata Pelajaran', gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS struktur_karyawan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, nama VARCHAR(180) NOT NULL, jabatan VARCHAR(180) NOT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS struktur_kategori_guru (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, nama VARCHAR(120) NOT NULL UNIQUE, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS struktur_statistik (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, label VARCHAR(180) NOT NULL, nilai VARCHAR(60) NOT NULL, icon VARCHAR(80) NULL, warna VARCHAR(20) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS struktur_cta (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, teks_tombol VARCHAR(80) NULL, link_tombol VARCHAR(255) NULL, icon VARCHAR(80) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "INSERT INTO struktur_utama (breadcrumb, judul, deskripsi, banner, status) SELECT 'Beranda > Profil > Struktur Organisasi', 'Struktur Organisasi', 'Mengenal para pendidik dan tenaga kependidikan yang melayani serta membangun SMAK.', 'assets/images/1030.JPG', 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_utama)",
        "INSERT INTO struktur_bagian (kode, judul, deskripsi, rata_tengah, urutan, status) SELECT 'bagan', 'Struktur Organisasi Sekolah', 'Kepemimpinan yang terstruktur dan terkoordinasi untuk pelayanan pendidikan yang unggul.', 1, 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_bagian WHERE kode = 'bagan')",
        "INSERT INTO struktur_bagian (kode, judul, deskripsi, rata_tengah, urutan, status) SELECT 'pimpinan', 'Pimpinan & Koordinator', 'Tim yang mengarahkan program dan pelayanan sekolah.', 0, 2, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_bagian WHERE kode = 'pimpinan')",
        "INSERT INTO struktur_bagian (kode, judul, deskripsi, rata_tengah, urutan, status) SELECT 'guru', 'Guru & Tenaga Pendidik', 'Tenaga pendidik profesional sesuai bidang keahlian.', 0, 3, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_bagian WHERE kode = 'guru')",
        "INSERT INTO struktur_bagian (kode, judul, deskripsi, rata_tengah, urutan, status) SELECT 'karyawan', 'Tenaga Kependidikan & Karyawan', 'Mendukung layanan administrasi dan operasional sekolah.', 0, 4, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_bagian WHERE kode = 'karyawan')",
        "INSERT INTO struktur_bagan (nama, jabatan, gambar, level_bagan, tampil_foto, urutan, status) SELECT 'Drs. Andreas Prasetyo', 'Kepala Sekolah', 'assets/images/staff/kepala_sekolah.jpg', 0, 1, 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_bagan)",
        "INSERT INTO struktur_bagan (nama, jabatan, gambar, level_bagan, tampil_foto, urutan, status) SELECT 'Maria Magdalena, S.Pd.', 'Komite Sekolah', 'assets/images/staff/komite_sekolah.jpg', 1, 1, 2, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 2",
        "INSERT INTO struktur_bagan (nama, jabatan, gambar, level_bagan, tampil_foto, urutan, status) SELECT 'Stefanus Budi, S.E.', 'Kepala Tata Usaha', 'assets/images/staff/kepala_tu.jpg', 1, 1, 3, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 3",
        "INSERT INTO struktur_bagan (nama, jabatan, gambar, level_bagan, tampil_foto, urutan, status) SELECT 'Lucia Handayani, S.Pd.', 'Waka Kurikulum', 'assets/images/staff/waka_kurikulum.jpg', 2, 1, 4, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 4",
        "INSERT INTO struktur_bagan (nama, jabatan, gambar, level_bagan, tampil_foto, urutan, status) SELECT 'Yohanes Ardi, S.Pd.', 'Waka Kesiswaan', 'assets/images/staff/waka_kesiswaan.jpg', 2, 1, 5, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 5",
        "INSERT INTO struktur_bagan (nama, jabatan, gambar, level_bagan, tampil_foto, urutan, status) SELECT 'Agustinus Dwi, S.T.', 'Waka Sarana Prasarana', 'assets/images/staff/waka_sarpras.jpg', 2, 1, 6, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 6",
        "INSERT INTO struktur_bagan (nama, jabatan, gambar, level_bagan, tampil_foto, urutan, status) SELECT 'Veronika Lestari, S.S.', 'Waka Humas', 'assets/images/staff/waka_humas.jpg', 2, 1, 7, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 7",
        "INSERT INTO struktur_bagan (nama, jabatan, icon, level_bagan, tampil_foto, urutan, status) SELECT '', 'Koordinator BK', 'psychology', 3, 0, 8, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 8",
        "INSERT INTO struktur_bagan (nama, jabatan, icon, level_bagan, tampil_foto, urutan, status) SELECT '', 'Koordinator Laboratorium', 'science', 3, 0, 9, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 9",
        "INSERT INTO struktur_bagan (nama, jabatan, icon, level_bagan, tampil_foto, urutan, status) SELECT '', 'Koordinator Perpustakaan', 'menu_book', 3, 0, 10, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 10",
        "INSERT INTO struktur_bagan (nama, jabatan, icon, level_bagan, tampil_foto, urutan, status) SELECT '', 'Pembina OSIS', 'groups', 3, 0, 11, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_bagan) < 11",
        "INSERT INTO struktur_pimpinan (nama, jabatan, keterangan, gambar, urutan, status) SELECT 'Drs. Andreas Prasetyo', 'Kepala Sekolah', 'Manajemen Pendidikan', 'assets/images/staff/kepala_sekolah.jpg', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_pimpinan)",
        "INSERT INTO struktur_pimpinan (nama, jabatan, keterangan, gambar, urutan, status) SELECT 'Maria Magdalena, S.Pd.', 'Komite Sekolah', 'Pendidikan Katolik', 'assets/images/staff/komite_sekolah.jpg', 2, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_pimpinan) < 2",
        "INSERT INTO struktur_pimpinan (nama, jabatan, keterangan, gambar, urutan, status) SELECT 'Stefanus Budi, S.E.', 'Kepala Tata Usaha', 'Manajemen Administrasi', 'assets/images/staff/kepala_tu.jpg', 3, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_pimpinan) < 3",
        "INSERT INTO struktur_pimpinan (nama, jabatan, keterangan, gambar, urutan, status) SELECT 'Lucia Handayani, S.Pd.', 'Waka Kurikulum', 'Kurikulum & Pembelajaran', 'assets/images/staff/waka_kurikulum.jpg', 4, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_pimpinan) < 4",
        "INSERT INTO struktur_pimpinan (nama, jabatan, keterangan, gambar, urutan, status) SELECT 'Yohanes Ardi, S.Pd.', 'Waka Kesiswaan', 'Kesiswaan & Pembinaan', 'assets/images/staff/waka_kesiswaan.jpg', 5, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_pimpinan) < 5",
        "INSERT INTO struktur_pimpinan (nama, jabatan, keterangan, gambar, urutan, status) SELECT 'Veronika Lestari, S.S.', 'Waka Humas', 'Hubungan Masyarakat', 'assets/images/staff/waka_humas.jpg', 6, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_pimpinan) < 6",
        "INSERT INTO struktur_kategori_guru (nama, urutan, status) SELECT 'Semua', 0, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_kategori_guru WHERE nama = 'Semua')",
        "INSERT INTO struktur_kategori_guru (nama, urutan, status) SELECT 'Guru Mata Pelajaran', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_kategori_guru WHERE nama = 'Guru Mata Pelajaran')",
        "INSERT INTO struktur_kategori_guru (nama, urutan, status) SELECT 'Wali Kelas', 2, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_kategori_guru WHERE nama = 'Wali Kelas')",
        "INSERT INTO struktur_kategori_guru (nama, urutan, status) SELECT 'Bimbingan Konseling', 3, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_kategori_guru WHERE nama = 'Bimbingan Konseling')",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Maria Cecilia, S.Pd.', 'Bahasa Indonesia', 'Guru Mata Pelajaran', 'assets/images/staff/guru_01.jpg', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_guru)",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Antonius Wibowo, S.Pd.', 'Matematika', 'Guru Mata Pelajaran', 'assets/images/staff/guru_02.jpg', 2, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 2",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Theresia Indah, S.Pd.', 'Bahasa Inggris', 'Wali Kelas', 'assets/images/staff/guru_03.jpg', 3, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 3",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Fransiskus Dimas, S.Si.', 'Fisika', 'Guru Mata Pelajaran', 'assets/images/staff/guru_04.jpg', 4, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 4",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Bernadeta Ayu, S.Pd.', 'Biologi', 'Guru Mata Pelajaran', 'assets/images/staff/guru_05.jpg', 5, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 5",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Ignatius Rangga, S.Pd.', 'Kimia', 'Guru Mata Pelajaran', 'assets/images/staff/guru_06.jpg', 6, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 6",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Monika Sari, S.Pd.', 'Ekonomi', 'Wali Kelas', 'assets/images/staff/guru_07.jpg', 7, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 7",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Petrus Yudha, S.Pd.', 'Sejarah', 'Guru Mata Pelajaran', 'assets/images/staff/guru_08.jpg', 8, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 8",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Agnes Viviana, S.Kom.', 'Informatika', 'Guru Mata Pelajaran', 'assets/images/staff/guru_09.jpg', 9, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 9",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Paulus Kumino, S.Ag.', 'Pendidikan Agama', 'Guru Mata Pelajaran', 'assets/images/staff/guru_10.jpg', 10, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 10",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Yohanes Daniel, S.Pd.', 'PJOK', 'Bimbingan Konseling', 'assets/images/staff/guru_11.jpg', 11, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 11",
        "INSERT INTO struktur_guru (nama, mata_pelajaran, kategori, gambar, urutan, status) SELECT 'Elisabeth Wulan, S.Sn.', 'Seni Budaya', 'Guru Mata Pelajaran', 'assets/images/staff/guru_12.jpg', 12, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_guru) < 12",
        "INSERT INTO struktur_karyawan (nama, jabatan, gambar, urutan, status) SELECT 'Rina Susanti', 'Tata Usaha', 'assets/images/staff/karyawan_01.jpg', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_karyawan)",
        "INSERT INTO struktur_karyawan (nama, jabatan, gambar, urutan, status) SELECT 'Dewi Lestari, A.Md.', 'Administrasi Akademik', 'assets/images/staff/karyawan_02.jpg', 2, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_karyawan) < 2",
        "INSERT INTO struktur_karyawan (nama, jabatan, gambar, urutan, status) SELECT 'Bagus Prayoga', 'Operator Sekolah', 'assets/images/staff/karyawan_03.jpg', 3, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_karyawan) < 3",
        "INSERT INTO struktur_karyawan (nama, jabatan, gambar, urutan, status) SELECT 'Yohana Fitri, S.I.Pust.', 'Pustakawan', 'assets/images/staff/karyawan_04.jpg', 4, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_karyawan) < 4",
        "INSERT INTO struktur_karyawan (nama, jabatan, gambar, urutan, status) SELECT 'Alfonsus Joko', 'Laboran', 'assets/images/staff/karyawan_05.jpg', 5, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_karyawan) < 5",
        "INSERT INTO struktur_karyawan (nama, jabatan, gambar, urutan, status) SELECT 'Slamet Riyadi', 'Keamanan', 'assets/images/staff/karyawan_06.jpg', 6, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_karyawan) < 6",
        "INSERT INTO struktur_karyawan (nama, jabatan, gambar, urutan, status) SELECT 'Siti Aminah', 'Kebersihan', 'assets/images/staff/karyawan_07.jpg', 7, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_karyawan) < 7",
        "INSERT INTO struktur_karyawan (nama, jabatan, gambar, urutan, status) SELECT 'Eko Budi Santoso', 'Teknisi', 'assets/images/staff/karyawan_08.jpg', 8, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_karyawan) < 8",
        "INSERT INTO struktur_statistik (label, nilai, icon, warna, urutan, status) SELECT 'Guru', '32', 'school', 'gold', 1, 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_statistik)",
        "INSERT INTO struktur_statistik (label, nilai, icon, warna, urutan, status) SELECT 'Tenaga Kependidikan', '8', 'work', 'blue', 2, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_statistik) < 2",
        "INSERT INTO struktur_statistik (label, nilai, icon, warna, urutan, status) SELECT 'Pimpinan', '4', 'workspace_premium', 'gold', 3, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_statistik) < 3",
        "INSERT INTO struktur_statistik (label, nilai, icon, warna, urutan, status) SELECT 'Total Personel', '44', 'groups', 'blue', 4, 'aktif' WHERE (SELECT COUNT(*) FROM struktur_statistik) < 4",
        "INSERT INTO struktur_cta (judul, deskripsi, teks_tombol, link_tombol, icon, status) SELECT 'Bersama Melayani dan Mendidik', 'Setiap peran menjadi bagian penting dalam menciptakan lingkungan belajar yang unggul dan penuh kasih.', 'Hubungi Sekolah', '/kontak', 'diversity_3', 'aktif' WHERE NOT EXISTS (SELECT 1 FROM struktur_cta)",
    ];

    foreach ($queries as $query) {
        if (!$connection->query($query)) {
            throw new RuntimeException($connection->error);
        }
    }
}


function ensureSaranaPrasaranaTables(mysqli $connection): void
{
    $queries = [
        "CREATE TABLE IF NOT EXISTS sarana_utama (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, breadcrumb VARCHAR(255) NULL, deskripsi TEXT NULL, banner VARCHAR(255) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_bagian (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, kode VARCHAR(80) NOT NULL UNIQUE, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_poin_intro (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_fasilitas_utama (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, kategori VARCHAR(120) NOT NULL, gambar VARCHAR(255) NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_penunjang (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_keagamaan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_keamanan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, icon VARCHAR(80) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_galeri (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_perawatan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_kutipan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, kutipan TEXT NOT NULL, sumber VARCHAR(180) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS sarana_cta (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, teks_tombol_1 VARCHAR(100) NULL, link_tombol_1 VARCHAR(255) NULL, teks_tombol_2 VARCHAR(100) NULL, link_tombol_2 VARCHAR(255) NULL, icon VARCHAR(80) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "INSERT INTO sarana_utama (judul,breadcrumb,deskripsi,status) SELECT 'Sarana & Prasarana','Beranda > Profil > Sarana & Prasarana','Fasilitas di SMA Katolik Mgr. Soegijapranata Lumajang kami sediakan secara sederhana dan bertahap untuk mendukung proses belajar serta pembentukan karakter peserta didik.','aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_utama)",
        "INSERT INTO sarana_bagian (kode,judul,deskripsi,gambar,urutan,status) SELECT 'intro','Lingkungan Belajar yang Mendukung','Kami berkomitmen menyediakan fasilitas dasar yang aman, nyaman, dan dirawat bertahap sesuai kemampuan sekolah serta menyesuaikan kebutuhan pembelajaran.','assets/images/logo_sekolah.png',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_bagian WHERE kode='intro')",
        "INSERT INTO sarana_bagian (kode,judul,deskripsi,urutan,status) SELECT 'penunjang','Fasilitas Penunjang Pembelajaran','',2,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_bagian WHERE kode='penunjang')",
        "INSERT INTO sarana_bagian (kode,judul,deskripsi,urutan,status) SELECT 'keagamaan','Fasilitas Keagamaan & Pembentukan Karakter','Kami mendukung pembentukan karakter melalui kegiatan kerohanian dan pembiasaan nilai-nilai Kristiani.',3,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_bagian WHERE kode='keagamaan')",
        "INSERT INTO sarana_bagian (kode,judul,deskripsi,urutan,status) SELECT 'keamanan','Kenyamanan dan Keamanan','',4,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_bagian WHERE kode='keamanan')",
        "INSERT INTO sarana_bagian (kode,judul,deskripsi,urutan,status) SELECT 'galeri','Galeri Sarana & Prasarana','',5,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_bagian WHERE kode='galeri')",
        "INSERT INTO sarana_bagian (kode,judul,deskripsi,urutan,status) SELECT 'perawatan','Upaya Perawatan Fasilitas','',6,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_bagian WHERE kode='perawatan')",
        "INSERT INTO sarana_poin_intro (judul,icon,urutan,status) SELECT 'Ruang Pembelajaran','class',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_poin_intro)",
        "INSERT INTO sarana_poin_intro (judul,icon,urutan,status) SELECT 'Fasilitas Dasar','science',2,'aktif' WHERE (SELECT COUNT(*) FROM sarana_poin_intro)<2",
        "INSERT INTO sarana_poin_intro (judul,icon,urutan,status) SELECT 'Lingkungan Aman','apartment',3,'aktif' WHERE (SELECT COUNT(*) FROM sarana_poin_intro)<3",
        "INSERT INTO sarana_poin_intro (judul,icon,urutan,status) SELECT 'Digunakan Bersama','groups',4,'aktif' WHERE (SELECT COUNT(*) FROM sarana_poin_intro)<4",
        "INSERT INTO sarana_fasilitas_utama (judul,deskripsi,kategori,urutan,status) SELECT 'Ruang Kelas','Ruang belajar utama untuk kegiatan pembelajaran setiap hari.','Akademik',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_fasilitas_utama)",
        "INSERT INTO sarana_fasilitas_utama (judul,deskripsi,kategori,urutan,status) SELECT 'Perpustakaan Sekolah','Koleksi buku pelajaran dan referensi untuk mendukung kegiatan belajar.','Akademik',2,'aktif' WHERE (SELECT COUNT(*) FROM sarana_fasilitas_utama)<2",
        "INSERT INTO sarana_fasilitas_utama (judul,deskripsi,kategori,urutan,status) SELECT 'Ruang Komputer Sederhana','Komputer dasar untuk pembelajaran TIK sesuai kebutuhan.','Pendukung',3,'aktif' WHERE (SELECT COUNT(*) FROM sarana_fasilitas_utama)<3",
        "INSERT INTO sarana_fasilitas_utama (judul,deskripsi,kategori,urutan,status) SELECT 'Ruang Praktik IPA','Ruang praktik dengan peralatan dasar IPA dan media pembelajaran.','Akademik',4,'aktif' WHERE (SELECT COUNT(*) FROM sarana_fasilitas_utama)<4",
        "INSERT INTO sarana_fasilitas_utama (judul,deskripsi,kategori,urutan,status) SELECT 'Halaman/Lapangan Sekolah','Digunakan untuk olahraga, upacara, dan kegiatan luar ruang lainnya.','Pengembangan Diri',5,'aktif' WHERE (SELECT COUNT(*) FROM sarana_fasilitas_utama)<5",
        "INSERT INTO sarana_fasilitas_utama (judul,deskripsi,kategori,urutan,status) SELECT 'Ruang Pertemuan','Digunakan untuk pertemuan, diskusi, dan kegiatan sekolah.','Rohani',6,'aktif' WHERE (SELECT COUNT(*) FROM sarana_fasilitas_utama)<6",
        "INSERT INTO sarana_penunjang (judul,deskripsi,icon,urutan,status) SELECT 'Proyektor Bersama','Digunakan bersama sesuai jadwal dan kebutuhan kelas.','desktop_windows',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_penunjang)",
        "INSERT INTO sarana_penunjang (judul,deskripsi,icon,urutan,status) SELECT 'Papan Tulis','Tersedia di setiap ruang kelas untuk mendukung pembelajaran.','edit',2,'aktif' WHERE (SELECT COUNT(*) FROM sarana_penunjang)<2",
        "INSERT INTO sarana_penunjang (judul,deskripsi,icon,urutan,status) SELECT 'Alat Praktik Dasar','Peralatan praktik sederhana untuk kegiatan belajar IPA dan lain-lain.','science',3,'aktif' WHERE (SELECT COUNT(*) FROM sarana_penunjang)<3",
        "INSERT INTO sarana_penunjang (judul,deskripsi,icon,urutan,status) SELECT 'Koneksi Internet Terbatas','Akses internet digunakan seperlunya untuk pembelajaran dan administrasi.','wifi',4,'aktif' WHERE (SELECT COUNT(*) FROM sarana_penunjang)<4",
        "INSERT INTO sarana_keagamaan (judul,deskripsi,icon,urutan,status) SELECT 'Ruang Doa/Kapel Sederhana','Tempat berdoa bersama dan perayaan Ekaristi pada waktu tertentu.','church',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_keagamaan)",
        "INSERT INTO sarana_keagamaan (judul,deskripsi,icon,urutan,status) SELECT 'Kegiatan Kerohanian','Pembinaan iman, retret, dan kegiatan rohani bersama secara berkala.','groups',2,'aktif' WHERE (SELECT COUNT(*) FROM sarana_keagamaan)<2",
        "INSERT INTO sarana_keamanan (judul,deskripsi,icon,urutan,status) SELECT 'UKS Sederhana','Pertolongan pertama untuk kesehatan siswa.','medical_services',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_keamanan)",
        "INSERT INTO sarana_keamanan (judul,deskripsi,icon,urutan,status) SELECT 'Kantin','Kantin sederhana dengan menu bergizi.','storefront',2,'aktif' WHERE (SELECT COUNT(*) FROM sarana_keamanan)<2",
        "INSERT INTO sarana_keamanan (judul,deskripsi,icon,urutan,status) SELECT 'Toilet','Toilet bersih dan terawat untuk siswa dan guru.','wc',3,'aktif' WHERE (SELECT COUNT(*) FROM sarana_keamanan)<3",
        "INSERT INTO sarana_keamanan (judul,deskripsi,icon,urutan,status) SELECT 'Tempat Parkir','Area parkir untuk kendaraan siswa, guru, dan tamu.','local_parking',4,'aktif' WHERE (SELECT COUNT(*) FROM sarana_keamanan)<4",
        "INSERT INTO sarana_keamanan (judul,deskripsi,icon,urutan,status) SELECT 'Kebersihan Lingkungan','Kebersihan sekolah dijaga bersama-sama.','clean_hands',5,'aktif' WHERE (SELECT COUNT(*) FROM sarana_keamanan)<5",
        "INSERT INTO sarana_galeri (judul,urutan,status) SELECT 'Ruang Kelas',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_galeri)",
        "INSERT INTO sarana_galeri (judul,urutan,status) SELECT 'Perpustakaan Sekolah',2,'aktif' WHERE (SELECT COUNT(*) FROM sarana_galeri)<2",
        "INSERT INTO sarana_galeri (judul,urutan,status) SELECT 'Ruang Komputer Sederhana',3,'aktif' WHERE (SELECT COUNT(*) FROM sarana_galeri)<3",
        "INSERT INTO sarana_galeri (judul,urutan,status) SELECT 'Ruang Praktik IPA',4,'aktif' WHERE (SELECT COUNT(*) FROM sarana_galeri)<4",
        "INSERT INTO sarana_galeri (judul,urutan,status) SELECT 'Halaman/Lapangan Sekolah',5,'aktif' WHERE (SELECT COUNT(*) FROM sarana_galeri)<5",
        "INSERT INTO sarana_galeri (judul,urutan,status) SELECT 'Ruang Pertemuan',6,'aktif' WHERE (SELECT COUNT(*) FROM sarana_galeri)<6",
        "INSERT INTO sarana_perawatan (judul,deskripsi,urutan,status) SELECT 'Pengecekan Rutin','Fasilitas dicek secara berkala agar tetap aman digunakan.',1,'aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_perawatan)",
        "INSERT INTO sarana_perawatan (judul,deskripsi,urutan,status) SELECT 'Kebersihan Harian','Menjaga kebersihan ruang dan lingkungan setiap hari.',2,'aktif' WHERE (SELECT COUNT(*) FROM sarana_perawatan)<2",
        "INSERT INTO sarana_perawatan (judul,deskripsi,urutan,status) SELECT 'Perawatan Bertahap','Perbaikan dilakukan sesuai prioritas dan kemampuan sekolah.',3,'aktif' WHERE (SELECT COUNT(*) FROM sarana_perawatan)<3",
        "INSERT INTO sarana_perawatan (judul,deskripsi,urutan,status) SELECT 'Penggunaan Bertanggung Jawab','Siswa diajak merawat fasilitas bersama-sama.',4,'aktif' WHERE (SELECT COUNT(*) FROM sarana_perawatan)<4",
        "INSERT INTO sarana_kutipan (kutipan,sumber,status) SELECT 'Fasilitas kami mungkin sederhana, tetapi kami merawatnya bersama agar menjadi sarana belajar yang aman dan bermanfaat.','Siswa SMAK','aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_kutipan)",
        "INSERT INTO sarana_cta (judul,deskripsi,teks_tombol_1,link_tombol_1,teks_tombol_2,link_tombol_2,icon,status) SELECT 'Belajar dan Bertumbuh Bersama SMAK','Fasilitas dasar, dirawat bertahap, menyesuaikan kebutuhan pembelajaran.','Lihat Galeri Sekolah','/galeri','Hubungi Kami','https://wa.me/628155099445','shield','aktif' WHERE NOT EXISTS (SELECT 1 FROM sarana_cta)",
    ];
    foreach ($queries as $query) if (!$connection->query($query)) throw new RuntimeException($connection->error);
}


function ensureKontakTable(mysqli $connection): void
{
    $connection->query("CREATE TABLE IF NOT EXISTS kontak (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, nama_sekolah VARCHAR(180) NULL, alamat TEXT NULL, telepon VARCHAR(100) NULL, email VARCHAR(180) NULL, jam_operasional TEXT NULL, instagram VARCHAR(500) NULL, facebook VARCHAR(500) NULL, youtube VARCHAR(500) NULL, maps_embed TEXT NULL)");

    $columns = [
        'breadcrumb' => 'VARCHAR(255) NULL',
        'hero_judul' => 'VARCHAR(180) NULL',
        'hero_deskripsi' => 'TEXT NULL',
        'hero_gambar' => 'VARCHAR(255) NULL',
        'form_judul' => 'VARCHAR(180) NULL',
        'lokasi_judul' => 'VARCHAR(180) NULL',
        'maps_link' => 'VARCHAR(500) NULL',
        'bantuan_judul' => 'VARCHAR(180) NULL',
        'bantuan_deskripsi' => 'TEXT NULL',
        'bantuan_tombol' => 'VARCHAR(100) NULL',
        'bantuan_link' => 'VARCHAR(500) NULL',
        'status' => "ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif'",
    ];
    foreach ($columns as $name => $definition) {
        $exists = $connection->query("SHOW COLUMNS FROM kontak LIKE '$name'");
        if ($exists && $exists->num_rows === 0 && !$connection->query("ALTER TABLE kontak ADD COLUMN `$name` $definition")) {
            throw new RuntimeException($connection->error);
        }
    }

    $legacy = $connection->query("SHOW TABLES LIKE 'kontak_utama'");
    if ($legacy && $legacy->num_rows > 0) {
        $hasMain = (int) ($connection->query('SELECT COUNT(*) AS total FROM kontak')->fetch_assoc()['total'] ?? 0) > 0;
        if (!$hasMain) {
            $query = "INSERT INTO kontak (breadcrumb, hero_judul, hero_deskripsi, hero_gambar, form_judul, nama_sekolah, alamat, telepon, email, jam_operasional, lokasi_judul, maps_embed, maps_link, bantuan_judul, bantuan_deskripsi, bantuan_tombol, bantuan_link, instagram, facebook, youtube, status) SELECT breadcrumb, hero_judul, hero_deskripsi, hero_gambar, form_judul, nama_sekolah, alamat, telepon, email, jam_operasional, lokasi_judul, maps_embed, maps_link, bantuan_judul, bantuan_deskripsi, bantuan_tombol, bantuan_link, instagram, facebook, youtube, status FROM kontak_utama LIMIT 1";
            if (!$connection->query($query)) throw new RuntimeException($connection->error);
        } else {
            $query = "UPDATE kontak c JOIN kontak_utama u ON 1=1 SET c.breadcrumb = COALESCE(NULLIF(c.breadcrumb, ''), u.breadcrumb), c.hero_judul = COALESCE(NULLIF(c.hero_judul, ''), u.hero_judul), c.hero_deskripsi = COALESCE(NULLIF(c.hero_deskripsi, ''), u.hero_deskripsi), c.hero_gambar = COALESCE(NULLIF(c.hero_gambar, ''), u.hero_gambar), c.form_judul = COALESCE(NULLIF(c.form_judul, ''), u.form_judul), c.lokasi_judul = COALESCE(NULLIF(c.lokasi_judul, ''), u.lokasi_judul), c.maps_link = COALESCE(NULLIF(c.maps_link, ''), u.maps_link), c.bantuan_judul = COALESCE(NULLIF(c.bantuan_judul, ''), u.bantuan_judul), c.bantuan_deskripsi = COALESCE(NULLIF(c.bantuan_deskripsi, ''), u.bantuan_deskripsi), c.bantuan_tombol = COALESCE(NULLIF(c.bantuan_tombol, ''), u.bantuan_tombol), c.bantuan_link = COALESCE(NULLIF(c.bantuan_link, ''), u.bantuan_link) WHERE c.id = (SELECT id FROM (SELECT id FROM kontak ORDER BY id LIMIT 1) AS first_kontak)";
            if (!$connection->query($query)) throw new RuntimeException($connection->error);
        }
        if (!$connection->query('DROP TABLE kontak_utama')) throw new RuntimeException($connection->error);
    }

    $connection->query("INSERT INTO kontak (breadcrumb, hero_judul, hero_deskripsi, hero_gambar, form_judul, nama_sekolah, alamat, telepon, email, jam_operasional, lokasi_judul, maps_embed, maps_link, bantuan_judul, bantuan_deskripsi, bantuan_tombol, bantuan_link, status) SELECT 'Beranda   ›   Kontak', 'Hubungi Kami', 'Kami siap membantu menjawab pertanyaan dan kebutuhan informasi Anda.', 'assets/images/1030.JPG', 'Kirim Pesan', 'SMAK Mgr. Soegijapranata', 'Jl. Diponegoro No. 63, Lumajang', '(0334) 890123', 'info@smaklumajang.sch.id', 'Senin - Jumat : 07.00 - 15.00 WIB\nSabtu : 07.00 - 12.00 WIB', 'Lokasi SMAK Mgr. Soegijapranata', 'https://www.openstreetmap.org/export/embed.html?bbox=113.2245%2C-8.1365%2C113.2328%2C-8.1305&layer=mapnik&marker=-8.133488698715732%2C113.22867187116394', 'https://maps.app.goo.gl/4fkeEUXRpV5URvkeA', 'Butuh Jawaban Cepat?', 'Hubungi kami langsung melalui WhatsApp untuk mendapatkan respon lebih cepat.', 'Hubungi via WhatsApp', 'https://wa.me/628155099445', 'aktif' WHERE NOT EXISTS (SELECT 1 FROM kontak)");
}


function ensurePpdbFrontendData(mysqli $connection): void
{
    $columns = [
        'tahun_ajaran' => 'VARCHAR(40) NULL',
        'deskripsi' => 'TEXT NULL',
        'status_pendaftaran' => 'VARCHAR(100) NULL',
        'whatsapp' => 'VARCHAR(100) NULL',
        'gelombang' => 'VARCHAR(100) NULL',
        'periode' => 'VARCHAR(180) NULL',
        'kuota' => 'VARCHAR(100) NULL',
        'jenjang' => 'VARCHAR(100) NULL',
        'kontak_ppdb' => 'VARCHAR(100) NULL',
        'frontend_data' => 'LONGTEXT NULL',
    ];
    foreach ($columns as $name => $definition) {
        $exists = $connection->query("SHOW COLUMNS FROM ppdb LIKE '$name'");
        if ($exists && $exists->num_rows === 0 && !$connection->query("ALTER TABLE ppdb ADD COLUMN `$name` $definition")) {
            throw new RuntimeException($connection->error);
        }
    }

    $content = [
        'hero' => ['label' => 'PPDB 2026/2027', 'judul' => 'Penerimaan Peserta Didik Baru', 'breadcrumb' => 'Beranda   >   PPDB', 'deskripsi' => "Bersama SMAK, tumbuh menjadi pribadi beriman,\nberkarakter, dan berprestasi.", 'status' => 'PENDAFTARAN DIBUKA', 'tombol_daftar' => 'Daftar Sekarang', 'tombol_whatsapp' => 'Konsultasi WhatsApp'],
        'ringkasan' => ['judul' => 'PPDB Tahun Ajaran 2026/2027', 'gelombang' => 'Gelombang 1', 'periode' => "1 Mei -\n30 Juni 2026", 'kuota' => '120 Siswa', 'jenjang' => 'SMA', 'kontak' => '(0334) 890123'],
        'teks_bagian' => [
            'mengapa_memilih' => ['judul' => 'Mengapa Memilih SMAK?', 'deskripsi' => 'Lingkungan pendidikan yang mendampingi perkembangan akademik dan karakter putra-putri Anda.'],
            'lingkungan_belajar' => ['judul' => 'Mengenal Lingkungan Belajar SMAK', 'deskripsi' => 'SMAK menghadirkan lingkungan belajar yang aman, inspiratif, dan mendukung setiap siswa untuk berkembang secara utuh.', 'gambar' => 'assets/images/IMG_5196.JPG'],
            'jadwal' => ['judul' => 'Jadwal PPDB', 'catatan' => 'Jadwal dapat berubah sewaktu-waktu. Silakan pantau informasi terbaru di website resmi atau media sosial SMAK.'],
            'biaya' => ['judul' => 'Biaya Pendidikan', 'deskripsi' => 'SMAK berkomitmen untuk memberikan layanan pendidikan berkualitas dengan biaya yang transparan dan dapat dikonsultasikan langsung dengan panitia.', 'catatan' => 'Untuk informasi rinci mengenai biaya pendidikan, silakan hubungi panitia PPDB melalui kontak yang tersedia.'],
            'beasiswa' => ['judul' => 'Beasiswa & Bantuan', 'tombol' => 'Konsultasi Biaya & Beasiswa'],
            'fasilitas' => ['judul' => 'Fasilitas untuk Mendukung Perkembangan Siswa'],
            'testimoni' => ['judul' => 'Cerita dari Keluarga SMAK'],
            'faq' => ['judul' => 'Pertanyaan yang Sering Diajukan'],
            'tanya_panitia' => ['judul' => 'Masih Punya Pertanyaan?', 'deskripsi' => 'Hubungi panitia melalui WhatsApp untuk mendapatkan informasi lebih lanjut seputar PPDB SMAK.', 'tombol' => 'Chat WhatsApp', 'call_center_judul' => 'Call Center PPDB', 'call_center_nomor' => '(0334) 890123', 'jam_layanan' => 'Senin - Jumat, 08.00 - 15.00 WIB'],
            'cta_bawah' => ['label' => 'PPDB 2026/2027', 'judul' => 'Mulai Langkahmu Bersama SMAK', 'deskripsi' => 'Bergabunglah dengan SMAK dan raih masa depan cerah bersama komunitas yang beriman, berkarakter, dan berprestasi.'],
        ],
        'mengapa_memilih' => [
            ['judul' => 'Akreditasi A', 'deskripsi' => 'Terakreditasi BAN-S/M'],
            ['judul' => 'Pembelajaran Berkualitas', 'deskripsi' => 'Pembelajaran aktif dan terarah'],
            ['judul' => 'Pembentukan Karakter', 'deskripsi' => 'Beriman, disiplin, dan bertanggung jawab'],
            ['judul' => 'Lingkungan Nyaman', 'deskripsi' => 'Aman, suportif, dan kekeluargaan'],
        ],
        'lingkungan_belajar' => [
            ['judul' => 'Pendampingan Personal', 'deskripsi' => 'Guru pembimbing mendampingi perkembangan akademik dan karakter.'],
            ['judul' => 'Fasilitas Pendukung', 'deskripsi' => 'Fasilitas lengkap untuk menunjang proses belajar mengajar.'],
            ['judul' => 'Kegiatan Beragam', 'deskripsi' => 'Program ekstrakurikuler dan kegiatan rohani yang membentuk pribadi unggul.'],
            ['judul' => 'Komunitas Beriman', 'deskripsi' => 'Dibentuk dalam nilai kebersamaan, iman Katolik, dan pelayanan.'],
        ],
        'alur_pendaftaran' => [
            ['judul' => 'Isi Formulir', 'deskripsi' => 'Isi formulir pendaftaran secara online dengan data yang benar.'],
            ['judul' => 'Unggah Berkas', 'deskripsi' => 'Unggah dokumen persyaratan dalam format yang ditentukan.'],
            ['judul' => 'Verifikasi', 'deskripsi' => 'Panitia memverifikasi dokumen dan menghubungi jika ada kekurangan.'],
            ['judul' => 'Tes & Wawancara', 'deskripsi' => 'Mengikuti tes akademik dan wawancara sesuai jadwal.'],
            ['judul' => 'Daftar Ulang', 'deskripsi' => 'Calon peserta yang diterima melakukan daftar ulang.'],
        ],
        'persyaratan' => [
            ['kategori' => 'Dokumen Pribadi', 'judul' => 'Fotokopi Kartu Keluarga'], ['kategori' => 'Dokumen Pribadi', 'judul' => 'Fotokopi Akta Kelahiran'], ['kategori' => 'Dokumen Pribadi', 'judul' => 'Pas Foto berwarna 3x4 (2 lembar)'], ['kategori' => 'Dokumen Akademik', 'judul' => 'Fotokopi Rapor Semester 1 - 5'], ['kategori' => 'Dokumen Akademik', 'judul' => 'Fotokopi ijazah/SKL (jika sudah ada)'], ['kategori' => 'Dokumen Pendukung', 'judul' => 'Sertifikat prestasi (jika ada)'], ['kategori' => 'Dokumen Pendukung', 'judul' => 'Surat Keterangan Kelakuan Baik dari Sekolah Asal'],
        ],
        'dokumen_unduhan' => [
            ['judul' => 'Brosur PPDB 2026/2027', 'deskripsi' => 'Informasi lengkap mengenai PPDB SMAK', 'file_url' => ''], ['judul' => 'Formulir Pendaftaran', 'deskripsi' => 'Formulir pendaftaran peserta didik baru', 'file_url' => ''], ['judul' => 'Panduan Pendaftaran', 'deskripsi' => 'Panduan lengkap demi langkah pendaftaran', 'file_url' => ''],
        ],
        'jadwal' => [
            ['tanggal' => '1 Mei - 30 Juni 2026', 'judul' => 'Pendaftaran', 'deskripsi' => 'Pengisian formulir dan unggah berkas pendaftaran.'], ['tanggal' => '4 Juli 2026', 'judul' => 'Tes & Wawancara', 'deskripsi' => 'Tes akademik dan wawancara sesuai jadwal.'], ['tanggal' => '7 Juli 2026', 'judul' => 'Pengumuman', 'deskripsi' => 'Pengumuman hasil seleksi diterbitkan secara online.'], ['tanggal' => '10 - 12 Juli 2026', 'judul' => 'Daftar Ulang', 'deskripsi' => 'Peserta yang diterima melakukan daftar ulang.'],
        ],
        'biaya' => [['judul' => 'Biaya Pendaftaran', 'nilai' => 'Hubungi Panitia'], ['judul' => 'Uang Pangkal', 'nilai' => 'Hubungi Panitia'], ['judul' => 'SPP', 'nilai' => 'Hubungi Panitia']],
        'beasiswa' => [['judul' => 'Beasiswa Prestasi', 'deskripsi' => 'Diberikan bagi siswa berprestasi di bidang akademik maupun non-akademik.'], ['judul' => 'Beasiswa Akademik', 'deskripsi' => 'Berdasarkan pencapaian nilai akademik yang unggul.'], ['judul' => 'Bantuan Pendidikan', 'deskripsi' => 'Bagi keluarga yang membutuhkan dukungan biaya pendidikan.']],
        'fasilitas' => [['judul' => 'Laboratorium', 'deskripsi' => 'Laboratorium IPA yang lengkap mendukung pembelajaran praktikum yang berkualitas.'], ['judul' => 'Perpustakaan', 'deskripsi' => 'Koleksi buku lengkap dan ruang baca nyaman untuk mendukung literasi siswa.'], ['judul' => 'Lapangan Olahraga', 'deskripsi' => 'Fasilitas olahraga memadai untuk mendukung kesehatan dan prestasi siswa.'], ['judul' => 'Ruang Komputer', 'deskripsi' => 'Ruang komputer dengan perangkat modern untuk menunjang pembelajaran digital.']],
        'testimoni' => [['nama' => 'Ibu Maria', 'peran' => 'Orang Tua Siswa Kelas XI', 'kutipan' => 'SMAK membantu anak saya tumbuh menjadi pribadi yang beriman, disiplin, dan berprestasi. Guru-gurunya sangat peduli dan mendampingi.'], ['nama' => 'Bapak Antonius', 'peran' => 'Orang Tua Siswa Kelas X', 'kutipan' => 'Fasilitas lengkap dan kegiatan yang beragam membuat anak saya betah belajar dan berkembang sesuai bakatnya.'], ['nama' => 'Ibu Yuliana', 'peran' => 'Orang Tua Siswa Kelas XII', 'kutipan' => 'Lingkungan yang kekeluargaan dan nilai-nilai iman yang diajarkan sangat membantu karakter anak saya sehari-hari.']],
        'faq' => [['pertanyaan' => 'Apa saja jalur pendaftaran yang tersedia?', 'jawaban' => 'SMAK membuka pendaftaran melalui jalur reguler dan jalur prestasi. Informasi lengkap dapat dilihat pada brosur PPDB.'], ['pertanyaan' => 'Apakah pendaftaran dapat dilakukan secara online?', 'jawaban' => 'Ya, seluruh proses pendaftaran awal dapat dilakukan secara online melalui formulir dan pengunggahan berkas.'], ['pertanyaan' => 'Bagaimana proses tes dan wawancara?', 'jawaban' => 'Calon siswa akan mengikuti tes akademik dan wawancara sesuai jadwal yang diumumkan oleh panitia.'], ['pertanyaan' => 'Apakah tersedia program beasiswa?', 'jawaban' => 'Tersedia program beasiswa prestasi, akademik, dan bantuan pendidikan sesuai kebijakan sekolah.'], ['pertanyaan' => 'Bagaimana jika dokumen belum lengkap?', 'jawaban' => 'Panitia akan menghubungi pendaftar untuk melengkapi dokumen yang masih kurang dalam batas waktu tertentu.'], ['pertanyaan' => 'Siapa yang dapat saya hubungi?', 'jawaban' => 'Anda dapat menghubungi panitia PPDB melalui WhatsApp atau telepon sekolah pada jam operasional.']],
    ];
    $json = $connection->real_escape_string((string) json_encode($content, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
    $connection->query("UPDATE ppdb SET tahun_ajaran = COALESCE(NULLIF(tahun_ajaran, ''), '2026/2027'), deskripsi = COALESCE(NULLIF(deskripsi, ''), 'Bersama SMAK, tumbuh menjadi pribadi beriman, berkarakter, dan berprestasi.'), status_pendaftaran = COALESCE(NULLIF(status_pendaftaran, ''), 'PENDAFTARAN DIBUKA'), whatsapp = COALESCE(NULLIF(whatsapp, ''), '628155099445'), gelombang = COALESCE(NULLIF(gelombang, ''), 'Gelombang 1'), periode = COALESCE(NULLIF(periode, ''), '1 Mei - 30 Juni 2026'), kuota = COALESCE(NULLIF(kuota, ''), '120 Siswa'), jenjang = COALESCE(NULLIF(jenjang, ''), 'SMA'), kontak_ppdb = COALESCE(NULLIF(kontak_ppdb, ''), '(0334) 890123'), frontend_data = COALESCE(NULLIF(frontend_data, ''), '$json') WHERE id = (SELECT id FROM (SELECT id FROM ppdb ORDER BY id LIMIT 1) AS first_ppdb)");
}


function ensureAkademikPrestasiTable(mysqli $connection): void
{
    $connection->query(
        "CREATE TABLE IF NOT EXISTS `akademik_prestasi` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `bagian` VARCHAR(80) NOT NULL,
            `judul` VARCHAR(180) NOT NULL,
            `data_json` LONGTEXT NOT NULL,
            `urutan` INT NOT NULL DEFAULT 0,
            `status` VARCHAR(20) NOT NULL DEFAULT 'aktif',
            `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
            `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `uniq_akademik_prestasi_bagian` (`bagian`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
    );
}

function seedAkademikPrestasiIfEmpty(mysqli $connection): void
{
    $result = $connection->query("SELECT COUNT(*) AS total FROM `akademik_prestasi`");
    if ($result && (int) ($result->fetch_assoc()['total'] ?? 0) > 0) return;

    $sections = [
        ['hero', 'Prestasi Akademik', ['breadcrumb' => 'Beranda > Akademik > Prestasi Akademik', 'judul' => 'Prestasi Akademik', 'deskripsi' => 'Mengukir prestasi melalui semangat belajar, disiplin, dan kerja keras.', 'gambar' => 'assets/images/IMG_5196.JPG']],
        ['pengantar', 'Prestasi yang Membanggakan', ['judul' => 'Prestasi yang Membanggakan', 'deskripsi' => 'Berbagai capaian akademik menjadi bukti semangat belajar, dedikasi siswa, dan pendampingan guru.']],
        ['statistik', 'Statistik Prestasi', [['nilai' => '24', 'label' => 'Prestasi'], ['nilai' => '8', 'label' => 'Tingkat Nasional'], ['nilai' => '12', 'label' => 'Tingkat Provinsi'], ['nilai' => '4', 'label' => 'Tingkat Kabupaten']]],
        ['unggulan', 'Prestasi Unggulan', [
            ['judul' => 'Juara Debat Bahasa Indonesia', 'tingkat' => 'TINGKAT NASIONAL', 'peserta' => 'Tim Debat SMAK Lumajang', 'event' => 'Kompetisi Debat Bahasa Indonesia Tingkat Nasional', 'tanggal' => '2026', 'urutan' => 1],
            ['judul' => 'Olimpiade Sains', 'tingkat' => 'TINGKAT NASIONAL', 'peserta' => 'Tim OSN SMAK Lumajang', 'event' => 'Olimpiade Sains Nasional', 'tanggal' => '2026', 'urutan' => 2],
            ['judul' => 'Lomba Karya Tulis Ilmiah', 'tingkat' => 'TINGKAT PROVINSI', 'peserta' => 'Tim KTI SMAK Lumajang', 'event' => 'LKTI Pelajar Jawa Timur', 'tanggal' => '2026', 'urutan' => 3],
        ]],
        ['capaian_terbaru', 'Capaian Prestasi Terbaru', [
            ['judul' => 'Juara I Debat Bahasa Indonesia', 'peserta' => 'Tim Debat SMAK', 'tingkat' => 'TINGKAT NASIONAL', 'tanggal' => '20 April 2026'],
            ['judul' => 'Medali Perak Olimpiade Matematika', 'peserta' => 'Andreas Wijaya', 'tingkat' => 'TINGKAT NASIONAL', 'tanggal' => '15 Maret 2025'],
            ['judul' => 'Juara II Karya Tulis Ilmiah', 'peserta' => 'Tim KTI SMAK', 'tingkat' => 'TINGKAT PROVINSI', 'tanggal' => '10 Februari 2024'],
            ['judul' => 'Finalis Olimpiade Biologi', 'peserta' => 'Clara Angelina', 'tingkat' => 'TINGKAT PROVINSI', 'tanggal' => '5 Februari 2025'],
            ['judul' => 'Juara III Cerdas Cermat', 'peserta' => 'Tim Cerdas Cermat', 'tingkat' => 'TINGKAT KABUPATEN', 'tanggal' => '28 Januari 2024'],
            ['judul' => 'Best Presentation', 'peserta' => 'Gabriel Santoso', 'tingkat' => 'TINGKAT NASIONAL', 'tanggal' => '18 Januari 2026'],
        ]],
        ['bidang', 'Bidang Prestasi', [
            ['judul' => 'Sains & Matematika', 'deskripsi' => 'Olimpiade, penelitian, dan kompetisi sains.'],
            ['judul' => 'Bahasa & Literasi', 'deskripsi' => 'Debat, karya tulis, pidato, dan literasi.'],
            ['judul' => 'Teknologi & Inovasi', 'deskripsi' => 'Robotika, coding, dan inovasi digital.'],
            ['judul' => 'Seni & Kreativitas', 'deskripsi' => 'Seni rupa, musik, dan kreativitas siswa.'],
        ]],
        ['pembinaan', 'Pembinaan Prestasi Berkelanjutan', ['judul' => 'Pembinaan Prestasi Berkelanjutan', 'deskripsi' => 'Prestasi lahir dari proses yang terarah, dukungan yang konsisten, dan keberanian untuk terus belajar.', 'poin' => [
            ['judul' => 'Pendampingan Guru', 'deskripsi' => 'Guru pembimbing mendampingi siswa secara intensif.'],
            ['judul' => 'Program Latihan', 'deskripsi' => 'Jadwal latihan rutin dan terstruktur sesuai bidang lomba.'],
            ['judul' => 'Evaluasi Berkala', 'deskripsi' => 'Monitoring untuk meningkatkan kualitas dan hasil.'],
            ['judul' => 'Dukungan Sekolah', 'deskripsi' => 'Fasilitas dan dukungan moral untuk setiap peserta.'],
        ]]],
        ['kutipan_siswa', 'Kutipan Siswa', ['kutipan' => 'Belajar dengan sungguh-sungguh, disiplin, dan tidak mudah menyerah adalah kunci untuk meraih prestasi.', 'nama' => 'Clara Angelina', 'kelas' => 'XI IPA 2']],
        ['perjalanan', 'Perjalanan Prestasi', [['tahun' => '2023', 'jumlah' => '15'], ['tahun' => '2024', 'jumlah' => '18'], ['tahun' => '2025', 'jumlah' => '21'], ['tahun' => '2026', 'jumlah' => '24']]],
        ['cta', 'Bersama Meraih Prestasi', ['judul' => 'Bersama Meraih Prestasi', 'deskripsi' => 'Mari terus belajar, menginspirasi, dan membawa nama baik SMAK.', 'tombol_utama' => 'Lihat Kegiatan Akademik', 'tombol_sekunder' => 'Hubungi Sekolah', 'whatsapp' => '628155099445']],
    ];

    foreach ($sections as $index => [$bagian, $judul, $data]) {
        $json = $connection->real_escape_string((string) json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
        $safeBagian = $connection->real_escape_string($bagian);
        $safeJudul = $connection->real_escape_string($judul);
        $connection->query("INSERT INTO `akademik_prestasi` (`bagian`, `judul`, `data_json`, `urutan`) VALUES ('$safeBagian', '$safeJudul', '$json', $index)");
    }
}


function ensureAkademikPrestasiSectionTables(mysqli $connection): void
{
    $tables = [
        'akademik_hero',
        'akademik_prestasi_statistik',
        'akademik_prestasi_unggulan',
        'akademik_prestasi_terbaru',
        'akademik_bidang_prestasi',
        'akademik_pembinaan_prestasi',
        'akademik_kutipan_siswa',
        'akademik_perjalanan_prestasi',
        'akademik_prestasi_cta',
    ];
    foreach ($tables as $table) {
        $connection->query(
            "CREATE TABLE IF NOT EXISTS `$table` (
                `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
                `bagian` VARCHAR(80) NOT NULL,
                `judul` VARCHAR(180) NOT NULL DEFAULT '',
                `data_json` LONGTEXT NOT NULL,
                `urutan` INT NOT NULL DEFAULT 0,
                `status` VARCHAR(20) NOT NULL DEFAULT 'aktif',
                `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
                `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );
    }
}

function seedAkademikPrestasiSectionTables(mysqli $connection): void
{
    $mapping = [
        'hero' => 'akademik_hero',
        'pengantar' => 'akademik_hero',
        'statistik' => 'akademik_prestasi_statistik',
        'unggulan' => 'akademik_prestasi_unggulan',
        'capaian_terbaru' => 'akademik_prestasi_terbaru',
        'bidang' => 'akademik_bidang_prestasi',
        'pembinaan' => 'akademik_pembinaan_prestasi',
        'kutipan_siswa' => 'akademik_kutipan_siswa',
        'perjalanan' => 'akademik_perjalanan_prestasi',
        'cta' => 'akademik_prestasi_cta',
    ];
    $source = $connection->query("SELECT bagian, judul, data_json, urutan FROM akademik_prestasi ORDER BY urutan ASC");
    if (!$source) return;
    while ($row = $source->fetch_assoc()) {
        $table = $mapping[$row['bagian']] ?? null;
        if ($table === null) continue;
        $safeBagian = $connection->real_escape_string((string) $row['bagian']);
        $check = $connection->query("SELECT COUNT(*) AS total FROM `$table` WHERE bagian = '$safeBagian'");
        if ($check && (int) ($check->fetch_assoc()['total'] ?? 0) > 0) continue;
        $data = json_decode((string) $row['data_json'], true);
        $items = is_array($data) && array_is_list($data) ? $data : [$data];
        foreach ($items as $index => $item) {
            $json = $connection->real_escape_string((string) json_encode($item, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
            $judul = is_array($item) ? ($item['judul'] ?? $row['judul']) : $row['judul'];
            $safeJudul = $connection->real_escape_string((string) $judul);
            $order = (int) $row['urutan'] * 100 + $index;
            $connection->query("INSERT INTO `$table` (`bagian`, `judul`, `data_json`, `urutan`) VALUES ('$safeBagian', '$safeJudul', '$json', $order)");
        }
    }
}


function ensureAkademikPrestasiAdminSchema(mysqli $connection): void
{
    $columns = [
        'akademik_hero' => [
            'subjudul' => 'TEXT NULL', 'gambar' => 'VARCHAR(255) NULL',
            'intro_judul' => 'VARCHAR(180) NULL', 'intro_deskripsi' => 'TEXT NULL',
            'pembinaan_judul' => 'VARCHAR(180) NULL', 'pembinaan_deskripsi' => 'TEXT NULL', 'pembinaan_gambar' => 'VARCHAR(255) NULL',
            'kutipan' => 'TEXT NULL', 'kutipan_nama' => 'VARCHAR(180) NULL', 'kutipan_kelas' => 'VARCHAR(80) NULL', 'kutipan_foto' => 'VARCHAR(255) NULL',
            'cta_judul' => 'VARCHAR(180) NULL', 'cta_deskripsi' => 'TEXT NULL', 'cta_whatsapp' => 'VARCHAR(80) NULL',
        ],
        'akademik_prestasi' => [
            'peserta' => 'VARCHAR(180) NULL', 'event' => 'VARCHAR(255) NULL', 'tingkat' => 'VARCHAR(80) NULL',
            'tanggal' => 'VARCHAR(80) NULL', 'tahun' => 'VARCHAR(10) NULL', 'gambar' => 'VARCHAR(255) NULL',
            'unggulan' => 'TINYINT(1) NOT NULL DEFAULT 0', 'urutan_unggulan' => 'INT NOT NULL DEFAULT 0',
        ],
        'akademik_bidang_prestasi' => ['deskripsi' => 'TEXT NULL'],
        'akademik_pembinaan_prestasi' => ['deskripsi' => 'TEXT NULL'],
    ];
    foreach ($columns as $table => $tableColumns) {
        foreach ($tableColumns as $name => $definition) {
            $exists = $connection->query("SHOW COLUMNS FROM `$table` LIKE '$name'");
            if ($exists && $exists->num_rows === 0) $connection->query("ALTER TABLE `$table` ADD COLUMN `$name` $definition");
        }
    }

    $hero = $connection->query("SELECT id FROM akademik_hero WHERE bagian = 'hero' ORDER BY id LIMIT 1");
    if ($hero && ($row = $hero->fetch_assoc())) {
        $connection->query("UPDATE akademik_hero SET subjudul = COALESCE(NULLIF(subjudul, ''), 'Mengukir prestasi melalui semangat belajar, disiplin, dan kerja keras.'), gambar = COALESCE(NULLIF(gambar, ''), 'assets/images/IMG_5196.JPG'), intro_judul = COALESCE(NULLIF(intro_judul, ''), 'Prestasi yang Membanggakan'), intro_deskripsi = COALESCE(NULLIF(intro_deskripsi, ''), 'Berbagai capaian akademik menjadi bukti semangat belajar, dedikasi siswa, dan pendampingan guru.'), pembinaan_judul = COALESCE(NULLIF(pembinaan_judul, ''), 'Pembinaan Prestasi Berkelanjutan'), pembinaan_deskripsi = COALESCE(NULLIF(pembinaan_deskripsi, ''), 'Prestasi lahir dari proses yang terarah, dukungan yang konsisten, dan keberanian untuk terus belajar.'), kutipan = COALESCE(NULLIF(kutipan, ''), 'Belajar dengan sungguh-sungguh, disiplin, dan tidak mudah menyerah adalah kunci untuk meraih prestasi.'), kutipan_nama = COALESCE(NULLIF(kutipan_nama, ''), 'Clara Angelina'), kutipan_kelas = COALESCE(NULLIF(kutipan_kelas, ''), 'XI IPA 2'), cta_judul = COALESCE(NULLIF(cta_judul, ''), 'Bersama Meraih Prestasi'), cta_deskripsi = COALESCE(NULLIF(cta_deskripsi, ''), 'Mari terus belajar, menginspirasi, dan membawa nama baik SMAK.'), cta_whatsapp = COALESCE(NULLIF(cta_whatsapp, ''), '628155099445') WHERE id = " . (int) $row['id']);
    }
}

function seedAkademikPrestasiAdminRows(mysqli $connection): void
{
    $hasAchievements = $connection->query("SELECT COUNT(*) AS total FROM akademik_prestasi WHERE peserta IS NOT NULL AND peserta <> ''");
    if ($hasAchievements && (int) ($hasAchievements->fetch_assoc()['total'] ?? 0) === 0) {
        $source = $connection->query("SELECT bagian, data_json FROM akademik_prestasi WHERE bagian IN ('unggulan', 'capaian_terbaru')");
        while ($source && ($row = $source->fetch_assoc())) {
            $items = json_decode((string) $row['data_json'], true);
            if (!is_array($items)) continue;
            foreach ($items as $index => $item) {
                if (!is_array($item)) continue;
                $title = $connection->real_escape_string((string) ($item['judul'] ?? ''));
                $person = $connection->real_escape_string((string) ($item['peserta'] ?? ''));
                $event = $connection->real_escape_string((string) ($item['event'] ?? 'Kompetisi Akademik SMA'));
                $level = $connection->real_escape_string(str_replace('TINGKAT ', '', (string) ($item['tingkat'] ?? '')));
                $date = $connection->real_escape_string((string) ($item['tanggal'] ?? ''));
                preg_match('/(20\\d{2})/', $date, $match);
                $year = $connection->real_escape_string($match[1] ?? '');
                $featured = $row['bagian'] === 'unggulan' ? 1 : 0;
                $featuredOrder = $featured ? $index + 1 : 0;
                $json = $connection->real_escape_string((string) json_encode($item, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
                $connection->query("INSERT INTO akademik_prestasi (bagian, judul, data_json, urutan, peserta, event, tingkat, tanggal, tahun, unggulan, urutan_unggulan) VALUES ('item', '$title', '$json', $index, '$person', '$event', '$level', '$date', '$year', $featured, $featuredOrder)");
            }
        }
    }

    $simpleTables = [
        'akademik_bidang_prestasi' => 'bidang',
        'akademik_pembinaan_prestasi' => 'pembinaan',
    ];
    foreach ($simpleTables as $table => $sourceBagian) {
        $hasRows = $connection->query("SELECT COUNT(*) AS total FROM `$table` WHERE deskripsi IS NOT NULL AND deskripsi <> ''");
        if (!$hasRows || (int) ($hasRows->fetch_assoc()['total'] ?? 0) > 0) continue;
        $source = $connection->query("SELECT data_json FROM `$table` WHERE bagian = '$sourceBagian' LIMIT 1");
        $raw = $source ? $source->fetch_assoc() : null;
        $data = json_decode((string) ($raw['data_json'] ?? ''), true);
        $items = $sourceBagian === 'pembinaan' ? ($data['poin'] ?? []) : $data;
        if (!is_array($items)) continue;
        foreach ($items as $index => $item) {
            if (!is_array($item)) continue;
            $title = $connection->real_escape_string((string) ($item['judul'] ?? ''));
            $description = $connection->real_escape_string((string) ($item['deskripsi'] ?? ''));
            $json = $connection->real_escape_string((string) json_encode($item, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
            $connection->query("INSERT INTO `$table` (bagian, judul, data_json, deskripsi, urutan) VALUES ('item', '$title', '$json', '$description', $index)");
        }
    }
}


function ensureKurikulumTable(mysqli $connection): void
{
    $connection->query("CREATE TABLE IF NOT EXISTS kurikulum_utama (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        judul VARCHAR(180) NOT NULL DEFAULT 'Kurikulum',
        frontend_data LONGTEXT NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'aktif',
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
}

function seedKurikulumIfEmpty(mysqli $connection): void
{
    $result = $connection->query("SELECT COUNT(*) AS total FROM kurikulum_utama");
    if ($result && (int) ($result->fetch_assoc()['total'] ?? 0) > 0) return;
    $data = [
        'hero' => ['judul' => 'Kurikulum', 'deskripsi' => 'Pendidikan yang mengembangkan pengetahuan, karakter, iman, dan keterampilan untuk masa depan yang lebih baik.', 'gambar' => 'assets/images/1030.JPG'],
        'pengantar' => ['judul' => 'Kurikulum SMAK', 'deskripsi' => 'SMAK Mgr. Soegijapranata menerapkan kurikulum yang berpusat pada peserta didik dengan mengintegrasikan Kurikulum Nasional, nilai-nilai Katolik, serta program pengembangan sekolah untuk membentuk insan yang cerdas, beriman, berkarakter, dan siap menghadapi perubahan zaman.', 'tagline' => 'Beriman • Berilmu • Berkarakter', 'tagline_deskripsi' => 'Kurikulum yang menumbuhkan kompetensi sekaligus membentuk kepribadian.'],
        'prinsip' => [['judul' => 'Kurikulum Nasional', 'deskripsi' => 'Mengacu pada kurikulum yang ditetapkan pemerintah dan kebutuhan peserta didik.'], ['judul' => 'Pembelajaran Aktif', 'deskripsi' => 'Mendorong siswa aktif, kritis, kreatif, dan kolaboratif dalam pembelajaran.'], ['judul' => 'Penguatan Karakter', 'deskripsi' => 'Menanamkan tanggung jawab, disiplin, kepedulian, dan keteladanan.'], ['judul' => 'Nilai Katolik', 'deskripsi' => 'Mengintegrasikan iman, kasih, pelayanan, dan penghargaan kepada sesama.']],
        'kerangka' => [['judul' => 'Intrakurikuler', 'deskripsi' => 'Pembelajaran inti yang terstruktur sesuai capaian dan standar pendidikan.'], ['judul' => 'Kokurikuler', 'deskripsi' => 'Kegiatan pendukung untuk memperkuat pemahaman dan penerapan materi.'], ['judul' => 'Ekstrakurikuler', 'deskripsi' => 'Pengembangan minat, bakat, potensi, dan prestasi dalam berbagai bidang.'], ['judul' => 'Pembiasaan & Karakter', 'deskripsi' => 'Pembentukan kebiasaan positif melalui budaya dan kehidupan sekolah.']],
        'mata_pelajaran' => [['judul' => 'Mata Pelajaran Umum', 'items' => ['Pendidikan Agama dan Budi Pekerti', 'Pendidikan Pancasila', 'Bahasa Indonesia', 'Matematika', 'Bahasa Inggris', 'Sejarah Indonesia', 'PJOK', 'Prakarya dan Kewirausahaan', 'Informatika', 'Bahasa Jawa']], ['judul' => 'Mata Pelajaran Peminatan', 'items' => ['Matematika Lanjutan', 'Fisika', 'Kimia', 'Biologi', 'Sosiologi', 'Geografi', 'Ekonomi', 'Bahasa dan Sastra', 'Bahasa Asing']], ['judul' => 'Muatan Khas Sekolah', 'items' => ['Pendalaman Iman Katolik', 'Pendidikan Karakter', 'Desain dan Teknologi', 'Kewirausahaan', 'Komunikasi dan Presentasi', 'Projek Penguatan Profil Pelajar', 'Bimbingan dan Konseling']]],
        'pendekatan' => ['judul' => 'Pendekatan Pembelajaran', 'gambar' => '', 'items' => [['judul' => 'Berpusat pada Siswa', 'deskripsi' => 'Menempatkan siswa sebagai subjek aktif dalam proses pembelajaran.'], ['judul' => 'Kontekstual', 'deskripsi' => 'Mengaitkan materi dengan kehidupan nyata agar lebih bermakna.'], ['judul' => 'Kolaboratif', 'deskripsi' => 'Mendorong kerja sama, diskusi, dan saling berbagi gagasan.'], ['judul' => 'Berbasis Proyek', 'deskripsi' => 'Mengembangkan keterampilan abad 21 melalui proyek nyata.']]],
        'program' => [['judul' => 'Literasi & Numerasi', 'deskripsi' => 'Penguatan kemampuan dasar melalui kegiatan yang terarah dan konsisten.'], ['judul' => 'Pendampingan Belajar', 'deskripsi' => 'Bimbingan akademik untuk membantu siswa mencapai potensi terbaiknya.'], ['judul' => 'Persiapan Perguruan Tinggi', 'deskripsi' => 'Pendampingan karier, studi lanjut, dan persiapan seleksi perguruan tinggi.'], ['judul' => 'Projek Penguatan Profil Pelajar', 'deskripsi' => 'Projek tematik lintas disiplin untuk menguatkan karakter dan kompetensi.'], ['judul' => 'Pembelajaran Digital', 'deskripsi' => 'Pemanfaatan teknologi dan platform digital untuk pembelajaran interaktif.'], ['judul' => 'Remedial & Pengayaan', 'deskripsi' => 'Tindak lanjut sesuai kebutuhan pemahaman dan perkembangan setiap siswa.']],
        'penilaian' => [['judul' => '1. Diagnostik', 'deskripsi' => 'Mengenali kemampuan awal dan kebutuhan belajar siswa.'], ['judul' => '2. Formatif', 'deskripsi' => 'Memantau proses pembelajaran dan memberikan umpan balik.'], ['judul' => '3. Sumatif', 'deskripsi' => 'Mengukur ketercapaian kompetensi pada akhir periode.'], ['judul' => '4. Tindak Lanjut', 'deskripsi' => 'Menentukan remedial, pengayaan, dan pendampingan berikutnya.']],
        'komitmen' => 'Kami berkomitmen menyeimbangkan prestasi akademik, iman yang mendalam, dan karakter mulia untuk melahirkan generasi yang cerdas, berkarakter, dan siap melayani.',
        'cta' => ['judul' => 'Siap Bertumbuh Bersama SMAK?', 'deskripsi' => 'Mari menjadi bagian dari lingkungan belajar yang beriman, berkarakter, dan unggul.', 'whatsapp' => 'https://wa.me/628155099445'],
    ];
    $json = $connection->real_escape_string((string) json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
    $connection->query("INSERT INTO kurikulum_utama (judul, frontend_data) VALUES ('Kurikulum', '$json')");
}


function ensureKurikulumSectionTables(mysqli $connection): void
{
    $tables = ['kurikulum_hero', 'kurikulum_pengantar', 'kurikulum_prinsip', 'kurikulum_kerangka', 'kurikulum_mata_pelajaran', 'kurikulum_pendekatan', 'kurikulum_program', 'kurikulum_penilaian', 'kurikulum_komitmen', 'kurikulum_cta'];
    foreach ($tables as $table) {
        $connection->query("CREATE TABLE IF NOT EXISTS `$table` (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            judul VARCHAR(180) NOT NULL DEFAULT '',
            data_json LONGTEXT NOT NULL,
            urutan INT NOT NULL DEFAULT 0,
            status VARCHAR(20) NOT NULL DEFAULT 'aktif',
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    }
}

function seedKurikulumSectionTables(mysqli $connection): void
{
    $source = $connection->query("SELECT frontend_data FROM kurikulum_utama ORDER BY id LIMIT 1");
    $row = $source ? $source->fetch_assoc() : null;
    $data = json_decode((string) ($row['frontend_data'] ?? ''), true);
    if (!is_array($data)) return;
    $map = ['hero' => 'kurikulum_hero', 'pengantar' => 'kurikulum_pengantar', 'prinsip' => 'kurikulum_prinsip', 'kerangka' => 'kurikulum_kerangka', 'mata_pelajaran' => 'kurikulum_mata_pelajaran', 'pendekatan' => 'kurikulum_pendekatan', 'program' => 'kurikulum_program', 'penilaian' => 'kurikulum_penilaian', 'komitmen' => 'kurikulum_komitmen', 'cta' => 'kurikulum_cta'];
    foreach ($map as $key => $table) {
        $exists = $connection->query("SELECT COUNT(*) AS total FROM `$table`");
        if ($exists && (int) ($exists->fetch_assoc()['total'] ?? 0) > 0) continue;
        $value = $data[$key] ?? null;
        $items = is_array($value) && array_is_list($value) ? $value : [$value];
        foreach ($items as $index => $item) {
            $json = $connection->real_escape_string((string) json_encode($item, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
            $title = is_array($item) ? (string) ($item['judul'] ?? '') : ucfirst($key);
            $safeTitle = $connection->real_escape_string($title);
            $connection->query("INSERT INTO `$table` (judul, data_json, urutan) VALUES ('$safeTitle', '$json', $index)");
        }
    }
}


function ensureKalenderTables(mysqli $connection): void
{
    $connection->query("CREATE TABLE IF NOT EXISTS kalender_utama (id INT UNSIGNED NOT NULL AUTO_INCREMENT, judul VARCHAR(180) NOT NULL, data_json LONGTEXT NOT NULL, status VARCHAR(20) NOT NULL DEFAULT 'aktif', created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    $connection->query("CREATE TABLE IF NOT EXISTS kalender_agenda (id INT UNSIGNED NOT NULL AUTO_INCREMENT, tanggal VARCHAR(20) NOT NULL, judul VARCHAR(255) NOT NULL, judul_pendek VARCHAR(180) NOT NULL DEFAULT '', lokasi VARCHAR(180) NOT NULL DEFAULT '', kategori VARCHAR(80) NOT NULL DEFAULT 'Akademik', urutan INT NOT NULL DEFAULT 0, status VARCHAR(20) NOT NULL DEFAULT 'aktif', created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
}

function seedKalenderIfEmpty(mysqli $connection): void
{
    $check = $connection->query("SELECT COUNT(*) AS total FROM kalender_utama");
    if ($check && (int) ($check->fetch_assoc()['total'] ?? 0) > 0) return;
    $main = ['hero' => ['judul' => 'Kalender Akademik', 'deskripsi' => 'Agenda dan kegiatan penting SMAK selama tahun ajaran.', 'gambar' => 'assets/images/1030.JPG'], 'pengantar' => ['judul' => 'Kalender Akademik', 'deskripsi' => 'Temukan jadwal kegiatan sekolah, ujian, libur, dan agenda penting lainnya.'], 'diperbarui' => '10 Agustus 2026', 'informasi' => 'Tanggal dan jadwal dapat berubah sewaktu-waktu sesuai kebijakan sekolah atau kondisi tertentu. Pastikan selalu memantau pembaruan resmi dari pihak sekolah.', 'pengingat' => 'Pantau pembaruan kalender secara berkala agar tidak melewatkan kegiatan penting.', 'pdf_url' => ''];
    $json = $connection->real_escape_string((string) json_encode($main, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
    $connection->query("INSERT INTO kalender_utama (judul, data_json) VALUES ('Kalender Akademik', '$json')");
    $events = [['2026-07-13','Masa Pengenalan Lingkungan Sekolah (MPLS)','MPLS','Lingkungan sekolah','Akademik'],['2026-08-03','Awal Tahun Ajaran','Awal Tahun Ajaran','Kegiatan Sekolah','Akademik'],['2026-08-08','Pertemuan Orang Tua','Pertemuan Orang Tua','Aula','Kegiatan Sekolah'],['2026-08-17','Upacara Kemerdekaan','Hari Kemerdekaan','Lapangan','Libur Nasional'],['2026-08-24','Penilaian Tengah Semester','PTS','Kelas','Ujian/Penilaian'],['2026-08-31','Rekoleksi Siswa','Rekoleksi','Aula','Kegiatan Sekolah'],['2026-09-14','Penilaian Tengah Semester (PTS)','PTS Ganjil','Ruang kelas','Ujian/Penilaian'],['2026-10-26','Retret dan Rekoleksi Siswa','Retret','Rumah retret','Kegiatan Sekolah'],['2026-11-10','Upacara Hari Pahlawan','Hari Pahlawan','Lapangan','Kegiatan Sekolah'],['2026-12-07','Penilaian Akhir Semester (PAS)','PAS','Ruang kelas','Ujian/Penilaian'],['2026-12-18','Pembagian Rapor Semester Ganjil','Pembagian Rapor','Ruang kelas','Akademik'],['2027-01-04','Awal Semester Genap','Semester Genap','Sekolah','Akademik'],['2027-02-13','Kegiatan Bakti Sosial','Bakti Sosial','Masyarakat','Kegiatan Sekolah'],['2027-03-08','Penilaian Tengah Semester Genap','PTS Genap','Ruang kelas','Ujian/Penilaian'],['2027-04-02','Libur Jumat Agung','Jumat Agung','Libur sekolah','Libur Nasional'],['2027-05-10','Ujian Sekolah Kelas XII','Ujian Sekolah','Ruang kelas','Ujian/Penilaian'],['2027-06-14','Penilaian Akhir Tahun','PAT','Ruang kelas','Ujian/Penilaian']];
    foreach ($events as $i => $event) { [$date,$title,$short,$location,$category] = $event; $values = array_map([$connection, 'real_escape_string'], $event); $connection->query("INSERT INTO kalender_agenda (tanggal, judul, judul_pendek, lokasi, kategori, urutan) VALUES ('{$values[0]}','{$values[1]}','{$values[2]}','{$values[3]}','{$values[4]}',$i)"); }
}


function ensureJadwalPelajaranTable(mysqli $connection): void
{
    $connection->query(
        "CREATE TABLE IF NOT EXISTS `jadwal_pelajaran` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `tahun_ajaran` VARCHAR(20) NOT NULL,
            `tingkat` VARCHAR(20) NOT NULL,
            `kelas` VARCHAR(10) NOT NULL,
            `semester` VARCHAR(30) NOT NULL,
            `hari` VARCHAR(20) NOT NULL,
            `urutan_hari` TINYINT NOT NULL,
            `jam_ke` VARCHAR(20) NOT NULL,
            `urutan_jam` TINYINT NOT NULL,
            `waktu` VARCHAR(30) NOT NULL,
            `mata_pelajaran` VARCHAR(120) NOT NULL,
            `guru` VARCHAR(120) NOT NULL,
            `ruang` VARCHAR(80) NOT NULL,
            `is_break` TINYINT(1) NOT NULL DEFAULT 0,
            `wali_kelas` VARCHAR(120) NOT NULL,
            `diperbarui_pada` VARCHAR(40) NOT NULL,
            `jam_masuk` VARCHAR(20) NOT NULL DEFAULT '07.00 WIB',
            `istirahat_1` VARCHAR(20) NOT NULL DEFAULT '09.15 WIB',
            `istirahat_2` VARCHAR(20) NOT NULL DEFAULT '11.45 WIB',
            `selesai` VARCHAR(20) NOT NULL DEFAULT '13.00 WIB',
            `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
            `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            KEY `idx_jadwal_filter` (`tahun_ajaran`, `tingkat`, `kelas`, `urutan_hari`, `urutan_jam`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
    );
}

function jadwalPelajaranSeedRows(): array
{
    $templates = [
        'Kelas X' => [
            'Senin' => [
                ['1', '07.00-07.45', 'Pendidikan Agama', 'Y. Daniel, S.Pd.', '{kelas}', 0],
                ['2', '07.45-08.30', 'Matematika', 'Antonius W., S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'Bahasa Indonesia', 'Maria Cecilia, S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Fisika', 'Fransiskus D., S.Si.', 'Lab IPA', 0],
                ['5', '10.15-11.00', 'Bahasa Inggris', 'Theresia Indah, S.Pd.', '{kelas}', 0],
                ['6', '11.00-11.45', 'Informatika', 'Agnes Viviana, S.Kom.', 'Lab Komputer', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'PJOK', 'Yohanes Daniel, S.Pd.', 'Lapangan', 0],
            ],
            'Selasa' => [
                ['1', '07.00-07.45', 'Biologi', 'Sr. Natalia, S.Pd.', 'Lab IPA', 0],
                ['2', '07.45-08.30', 'Matematika', 'Antonius W., S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'Sejarah Indonesia', 'Petrus Bima, S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Seni Budaya', 'Lidya Angel, S.Sn.', 'Ruang Seni', 0],
                ['5', '10.15-11.00', 'Bahasa Inggris', 'Theresia Indah, S.Pd.', '{kelas}', 0],
                ['6', '11.00-11.45', 'Pendidikan Pancasila', 'Cecilia M., S.Pd.', '{kelas}', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'BK', 'Martha Dian, S.Psi.', 'Ruang BK', 0],
            ],
            'Rabu' => [
                ['1', '07.00-07.45', 'Kimia', 'Paulus K., S.Si.', 'Lab IPA', 0],
                ['2', '07.45-08.30', 'Geografi', 'Albertus Y., S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'Matematika', 'Antonius W., S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Bahasa Jawa', 'Siska N., S.Pd.', '{kelas}', 0],
                ['5', '10.15-11.00', 'Informatika', 'Agnes Viviana, S.Kom.', 'Lab Komputer', 0],
                ['6', '11.00-11.45', 'Bahasa Indonesia', 'Maria Cecilia, S.Pd.', '{kelas}', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Prakarya', 'Santo R., S.Pd.', 'Workshop', 0],
            ],
            'Kamis' => [
                ['1', '07.00-07.45', 'Bahasa Inggris', 'Theresia Indah, S.Pd.', '{kelas}', 0],
                ['2', '07.45-08.30', 'Fisika', 'Fransiskus D., S.Si.', 'Lab IPA', 0],
                ['3', '08.30-09.15', 'Pendidikan Agama', 'Y. Daniel, S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Sosiologi', 'Benedikta S., S.Pd.', '{kelas}', 0],
                ['5', '10.15-11.00', 'Matematika', 'Antonius W., S.Pd.', '{kelas}', 0],
                ['6', '11.00-11.45', 'Biologi', 'Sr. Natalia, S.Pd.', 'Lab IPA', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Literasi', 'Tim Perpustakaan', 'Perpustakaan', 0],
            ],
            'Jumat' => [
                ['1', '07.00-07.45', 'Doa Pagi dan Refleksi', 'Wali Kelas', '{kelas}', 0],
                ['2', '07.45-08.30', 'Bahasa Indonesia', 'Maria Cecilia, S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'PPKn', 'Cecilia M., S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Ekstrakurikuler Kelas', 'Pendamping Kelas', 'Aula', 0],
                ['5', '10.15-11.00', 'Pembinaan Karakter', 'Tim Kesiswaan', 'Aula', 0],
                ['6', '11.00-11.45', 'Rapat Kelas', 'Wali Kelas', '{kelas}', 0],
            ],
        ],
        'Kelas XI' => [
            'Senin' => [
                ['1', '07.00-07.45', 'Ekonomi', 'Veronika M., S.Pd.', '{kelas}', 0],
                ['2', '07.45-08.30', 'Bahasa Inggris', 'Theresia Indah, S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'Matematika Lanjut', 'Antonius W., S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Biologi', 'Sr. Natalia, S.Pd.', 'Lab IPA', 0],
                ['5', '10.15-11.00', 'Kimia', 'Paulus K., S.Si.', 'Lab IPA', 0],
                ['6', '11.00-11.45', 'Bahasa Indonesia', 'Maria Cecilia, S.Pd.', '{kelas}', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Sosiologi', 'Benedikta S., S.Pd.', '{kelas}', 0],
            ],
            'Selasa' => [
                ['1', '07.00-07.45', 'Fisika', 'Fransiskus D., S.Si.', 'Lab IPA', 0],
                ['2', '07.45-08.30', 'Informatika', 'Agnes Viviana, S.Kom.', 'Lab Komputer', 0],
                ['3', '08.30-09.15', 'Sejarah', 'Petrus Bima, S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Pendidikan Agama', 'Y. Daniel, S.Pd.', '{kelas}', 0],
                ['5', '10.15-11.00', 'Matematika Lanjut', 'Antonius W., S.Pd.', '{kelas}', 0],
                ['6', '11.00-11.45', 'Geografi', 'Albertus Y., S.Pd.', '{kelas}', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Bahasa Inggris', 'Theresia Indah, S.Pd.', '{kelas}', 0],
            ],
            'Rabu' => [
                ['1', '07.00-07.45', 'Kimia', 'Paulus K., S.Si.', 'Lab IPA', 0],
                ['2', '07.45-08.30', 'Biologi', 'Sr. Natalia, S.Pd.', 'Lab IPA', 0],
                ['3', '08.30-09.15', 'Ekonomi', 'Veronika M., S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Bahasa Indonesia', 'Maria Cecilia, S.Pd.', '{kelas}', 0],
                ['5', '10.15-11.00', 'PPKn', 'Cecilia M., S.Pd.', '{kelas}', 0],
                ['6', '11.00-11.45', 'Informatika', 'Agnes Viviana, S.Kom.', 'Lab Komputer', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Pendalaman Materi', 'Tim Akademik', 'Aula', 0],
            ],
            'Kamis' => [
                ['1', '07.00-07.45', 'Bahasa Inggris', 'Theresia Indah, S.Pd.', '{kelas}', 0],
                ['2', '07.45-08.30', 'Sosiologi', 'Benedikta S., S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'Pendidikan Agama', 'Y. Daniel, S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Fisika', 'Fransiskus D., S.Si.', 'Lab IPA', 0],
                ['5', '10.15-11.00', 'Matematika Lanjut', 'Antonius W., S.Pd.', '{kelas}', 0],
                ['6', '11.00-11.45', 'BK', 'Martha Dian, S.Psi.', 'Ruang BK', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Literasi', 'Tim Perpustakaan', 'Perpustakaan', 0],
            ],
            'Jumat' => [
                ['1', '07.00-07.45', 'Doa dan Refleksi', 'Wali Kelas', '{kelas}', 0],
                ['2', '07.45-08.30', 'Pelayanan Sosial', 'Tim Kesiswaan', 'Aula', 0],
                ['3', '08.30-09.15', 'Proyek Kelas', 'Pendamping Kelas', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Ekstrakurikuler', 'Pembina Ekskul', 'Lapangan', 0],
                ['5', '10.15-11.00', 'Pembinaan Karakter', 'Tim Rohani', 'Kapel', 0],
                ['6', '11.00-11.45', 'Rapat Kelas', 'Wali Kelas', '{kelas}', 0],
            ],
        ],
        'Kelas XII' => [
            'Senin' => [
                ['1', '07.00-07.45', 'Bahasa Indonesia', 'Maria Cecilia, S.Pd.', '{kelas}', 0],
                ['2', '07.45-08.30', 'Matematika', 'Antonius W., S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'Bahasa Inggris', 'Theresia Indah, S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Try Out Sekolah', 'Tim Akademik', 'Aula', 0],
                ['5', '10.15-11.00', 'Fisika', 'Fransiskus D., S.Si.', 'Lab IPA', 0],
                ['6', '11.00-11.45', 'Kimia', 'Paulus K., S.Si.', 'Lab IPA', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Pendalaman SNBT', 'Tim BK', 'Ruang BK', 0],
            ],
            'Selasa' => [
                ['1', '07.00-07.45', 'Biologi', 'Sr. Natalia, S.Pd.', 'Lab IPA', 0],
                ['2', '07.45-08.30', 'Sejarah', 'Petrus Bima, S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'PPKn', 'Cecilia M., S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Informatika', 'Agnes Viviana, S.Kom.', 'Lab Komputer', 0],
                ['5', '10.15-11.00', 'Literasi', 'Tim Perpustakaan', 'Perpustakaan', 0],
                ['6', '11.00-11.45', 'BK Karier', 'Martha Dian, S.Psi.', 'Ruang BK', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Pendalaman Materi', 'Tim Akademik', 'Aula', 0],
            ],
            'Rabu' => [
                ['1', '07.00-07.45', 'Pendidikan Agama', 'Y. Daniel, S.Pd.', '{kelas}', 0],
                ['2', '07.45-08.30', 'Matematika', 'Antonius W., S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'Bahasa Indonesia', 'Maria Cecilia, S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Simulasi Ujian', 'Tim Akademik', 'Aula', 0],
                ['5', '10.15-11.00', 'Bahasa Inggris', 'Theresia Indah, S.Pd.', '{kelas}', 0],
                ['6', '11.00-11.45', 'Konseling Kelas', 'Guru BK', 'Ruang BK', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Refleksi', 'Wali Kelas', '{kelas}', 0],
            ],
            'Kamis' => [
                ['1', '07.00-07.45', 'Geografi', 'Albertus Y., S.Pd.', '{kelas}', 0],
                ['2', '07.45-08.30', 'Sosiologi', 'Benedikta S., S.Pd.', '{kelas}', 0],
                ['3', '08.30-09.15', 'Bahasa Inggris', 'Theresia Indah, S.Pd.', '{kelas}', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Pendampingan PTN', 'Tim BK', 'Ruang BK', 0],
                ['5', '10.15-11.00', 'Try Out SNBT', 'Tim Akademik', 'Aula', 0],
                ['6', '11.00-11.45', 'Pendidikan Agama', 'Y. Daniel, S.Pd.', '{kelas}', 0],
                ['Istirahat', '11.45-12.15', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['7', '12.15-13.00', 'Literasi', 'Tim Perpustakaan', 'Perpustakaan', 0],
            ],
            'Jumat' => [
                ['1', '07.00-07.45', 'Doa Pagi', 'Wali Kelas', '{kelas}', 0],
                ['2', '07.45-08.30', 'Pembinaan Karakter', 'Tim Rohani', 'Kapel', 0],
                ['3', '08.30-09.15', 'Rapat Angkatan', 'Wakasek Kesiswaan', 'Aula', 0],
                ['Istirahat', '09.15-09.30', 'Waktu istirahat peserta didik', '-', '-', 1],
                ['4', '09.30-10.15', 'Informasi Alumni', 'Tim Alumni', 'Aula', 0],
                ['5', '10.15-11.00', 'Refleksi Pekanan', 'Wali Kelas', '{kelas}', 0],
                ['6', '11.00-11.45', 'Persiapan Kelulusan', 'Tim Sekolah', 'Aula', 0],
            ],
        ],
    ];

    $profiles = [
        ['tahun' => '2026/2027', 'semester' => 'Semester Ganjil', 'diperbarui' => '10 Agustus 2026'],
        ['tahun' => '2025/2026', 'semester' => 'Semester Genap', 'diperbarui' => '2 Mei 2026'],
        ['tahun' => '2024/2025', 'semester' => 'Semester Ganjil', 'diperbarui' => '15 Januari 2025'],
    ];

    $classes = [
        ['tingkat' => 'Kelas X', 'kelas' => 'X-A', 'wali' => 'Maria Magdalena, S.Pd.'],
        ['tingkat' => 'Kelas X', 'kelas' => 'X-B', 'wali' => 'Antonia Lusia, S.Pd.'],
        ['tingkat' => 'Kelas XI', 'kelas' => 'XI-A', 'wali' => 'Paulus Joni, S.Pd.'],
        ['tingkat' => 'Kelas XI', 'kelas' => 'XI-B', 'wali' => 'Veronika Mulyani, S.Pd.'],
        ['tingkat' => 'Kelas XII', 'kelas' => 'XII-A', 'wali' => 'Bonaventura Agus, S.Pd.'],
        ['tingkat' => 'Kelas XII', 'kelas' => 'XII-B', 'wali' => 'Yohana Kartika, S.Pd.'],
    ];

    $dayOrder = ['Senin' => 1, 'Selasa' => 2, 'Rabu' => 3, 'Kamis' => 4, 'Jumat' => 5];
    $rows = [];

    foreach ($profiles as $profile) {
        foreach ($classes as $class) {
            $template = $templates[$class['tingkat']] ?? [];
            foreach ($template as $hari => $lessons) {
                foreach ($lessons as $index => $lesson) {
                    $rows[] = [
                        'tahun_ajaran' => $profile['tahun'],
                        'tingkat' => $class['tingkat'],
                        'kelas' => $class['kelas'],
                        'semester' => $profile['semester'],
                        'hari' => $hari,
                        'urutan_hari' => $dayOrder[$hari] ?? 9,
                        'jam_ke' => $lesson[0],
                        'urutan_jam' => $index + 1,
                        'waktu' => $lesson[1],
                        'mata_pelajaran' => $lesson[2],
                        'guru' => str_replace('{kelas}', $class['kelas'], $lesson[3]),
                        'ruang' => str_replace('{kelas}', $class['kelas'], $lesson[4]),
                        'is_break' => $lesson[5],
                        'wali_kelas' => $class['wali'],
                        'diperbarui_pada' => $profile['diperbarui'],
                        'jam_masuk' => '07.00 WIB',
                        'istirahat_1' => '09.15 WIB',
                        'istirahat_2' => '11.45 WIB',
                        'selesai' => '13.00 WIB',
                    ];
                }
            }
        }
    }

    return $rows;
}

function seedJadwalPelajaranIfEmpty(mysqli $connection): void
{
    $result = $connection->query("SELECT COUNT(*) AS total FROM `jadwal_pelajaran`");
    $count = $result ? (int) ($result->fetch_assoc()['total'] ?? 0) : 0;
    if ($count > 0) {
        return;
    }

    $rows = jadwalPelajaranSeedRows();
    foreach ($rows as $row) {
        $columns = [];
        $values = [];
        foreach ($row as $key => $value) {
            $columns[] = "`$key`";
            $values[] = "'" . $connection->real_escape_string((string) $value) . "'";
        }
        $query = "INSERT INTO `jadwal_pelajaran` (" . implode(', ', $columns) . ") VALUES (" . implode(', ', $values) . ")";
        $connection->query($query);
    }
}


function ensureJadwalKontenTable(mysqli $connection): void
{
    $connection->query(
        "CREATE TABLE IF NOT EXISTS `jadwal_konten` (
            `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `judul` VARCHAR(180) NOT NULL,
            `data_json` LONGTEXT NOT NULL,
            `status` VARCHAR(20) NOT NULL DEFAULT 'aktif',
            `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
            `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
    );
}

function seedJadwalKontenIfEmpty(mysqli $connection): void
{
    $result = $connection->query("SELECT COUNT(*) AS total FROM `jadwal_konten`");
    $count = $result ? (int) ($result->fetch_assoc()['total'] ?? 0) : 0;
    if ($count > 0) {
        return;
    }

    $content = [
        'breadcrumb' => 'Beranda  >  Akademik  >  Jadwal Pelajaran',
        'hero_title' => 'Jadwal Pelajaran',
        'hero_subtitle' => 'Informasi jadwal kegiatan belajar mengajar SMAK Mgr. Soegijapranata.',
        'hero_image' => 'assets/images/1030.JPG',
        'page_title' => 'Jadwal Pelajaran',
        'page_subtitle' => 'Pilih tahun ajaran, tingkat, dan kelas untuk melihat jadwal pelajaran.',
        'schedule_note' => 'Catatan: Jadwal dapat berubah sewaktu-waktu sesuai kebijakan sekolah.',
        'timing_title' => 'Keterangan Jam Pelajaran',
        'information_title' => 'Informasi Jadwal',
        'information_text' => 'Perubahan jadwal pelajaran akan diinformasikan oleh wali kelas melalui pengumuman resmi sekolah. Pastikan untuk selalu memeriksa informasi terbaru.',
        'pdf_button_label' => 'Unduh Jadwal PDF',
        'contact_button_label' => 'Hubungi Sekolah',
        'reminder_text' => 'Pastikan selalu memeriksa pembaruan jadwal sebelum kegiatan belajar dimulai.',
        'pdf_url' => '',
    ];
    $json = $connection->real_escape_string((string) json_encode($content, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
    $connection->query("INSERT INTO `jadwal_konten` (`judul`, `data_json`) VALUES ('Jadwal Pelajaran', '$json')");
}


function ensureTatibKontenTable(mysqli $connection): void
{
    $connection->query("CREATE TABLE IF NOT EXISTS `tatib_konten` (id INT UNSIGNED NOT NULL AUTO_INCREMENT, judul VARCHAR(180) NOT NULL, data_json LONGTEXT NOT NULL, status VARCHAR(20) NOT NULL DEFAULT 'aktif', created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
}

function seedTatibKontenIfEmpty(mysqli $connection): void
{
    $check = $connection->query("SELECT COUNT(*) AS total FROM `tatib_konten`");
    if ($check && (int) ($check->fetch_assoc()['total'] ?? 0) > 0) return;
    $data = [
        'hero_title' => 'Tata Tertib Siswa', 'hero_subtitle' => 'Pedoman untuk membangun lingkungan belajar yang tertib, aman, disiplin, dan berkarakter.', 'hero_image' => 'assets/images/IMG_5196.JPG',
        'intro_title' => 'Tata Tertib Siswa', 'intro' => 'Tata tertib sekolah merupakan pedoman bersama untuk membentuk pribadi yang bertanggung jawab, saling menghormati, dan siap menjadi pembelajar sepanjang hayat.',
        'year' => '2026/2027', 'applies' => 'Seluruh Siswa', 'updated' => '10 Agustus 2026', 'status' => 'Sekolah',
        'principle' => "Disiplin • Tanggung Jawab\nHormat • Peduli", 'principle_desc' => 'Nilai yang menjadi dasar perilaku dan keputusan warga sekolah dalam mewujudkan karakter unggul.',
        'guidance_note' => 'Pendekatan sekolah bersifat edukatif dan restoratif untuk membantu siswa bertumbuh menjadi pribadi yang lebih baik.', 'violation_desc' => 'Pelanggaran serius ditangani sesuai peraturan sekolah dan ketentuan yang berlaku.',
        'pdf' => 'Tata_Tertib_Siswa_2026.pdf', 'pdf_url' => '', 'help' => 'Jika ada hal yang belum jelas, silakan hubungi wali kelas atau guru BK untuk memperoleh penjelasan lebih lanjut.', 'contact' => 'https://wa.me/628155099445',
        'commitment' => 'Mari menciptakan lingkungan sekolah yang tertib, aman, nyaman, dan saling menghargai.', 'commitment_sub' => 'Bersama, kita membentuk generasi berkarakter dan berprestasi.',
        'general' => ['Hadir tepat waktu sesuai jadwal kegiatan sekolah.', 'Memakai seragam sesuai ketentuan yang berlaku.', 'Menjaga kesopanan, sopan santun, dan menghormati sesama.', 'Mengikuti pembelajaran dengan tertib dan penuh tanggung jawab.', 'Menjaga kebersihan, kerapian, dan kelestarian fasilitas sekolah.', 'Membawa perlengkapan belajar sesuai kebutuhan.'],
        'rights' => ['Memperoleh pembelajaran yang berkualitas.', 'Mendapat rasa aman dan nyaman di sekolah.', 'Memperoleh bimbingan dan konseling.', 'Menggunakan fasilitas sekolah dengan layak.', 'Menyampaikan pendapat dengan santun.'],
        'duties' => ['Menaati semua peraturan sekolah.', 'Menjaga nama baik diri, keluarga, dan sekolah.', 'Mengikuti kegiatan sekolah dengan sungguh-sungguh.', 'Merawat fasilitas sekolah dengan tanggung jawab.', 'Menghargai seluruh warga sekolah.'],
        'violations' => ['Perundungan dalam bentuk apa pun.', 'Kekerasan fisik maupun verbal.', 'Merokok, narkoba, dan minuman beralkohol.', 'Membawa benda berbahaya.', 'Merusak fasilitas sekolah.', 'Tindakan yang mencemarkan nama sekolah.'],
        'categories' => [], 'guidance' => [['title' => 'Pengingat', 'desc' => 'Nasihat persuasif oleh guru atau piket.'], ['title' => 'Pembinaan Wali Kelas', 'desc' => 'Pendampingan untuk memahami dan memperbaiki diri.'], ['title' => 'Pendampingan BK', 'desc' => 'Mencari solusi serta menguatkan karakter siswa.'], ['title' => 'Koordinasi Orang Tua', 'desc' => 'Kerja sama demi perkembangan siswa yang optimal.']],
    ];
    $json = $connection->real_escape_string((string) json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
    $connection->query("INSERT INTO `tatib_konten` (judul, data_json) VALUES ('Tata Tertib Siswa', '$json')");
}


function ensureTatibSectionTables(mysqli $connection): void
{
    $tables = ['tatib_hero', 'tatib_ringkasan', 'tatib_ketentuan_umum', 'tatib_prinsip', 'tatib_kategori', 'tatib_hak_siswa', 'tatib_kewajiban_siswa', 'tatib_pembinaan', 'tatib_pelanggaran', 'tatib_dokumen', 'tatib_komitmen'];
    foreach ($tables as $table) {
        $connection->query("CREATE TABLE IF NOT EXISTS `$table` (id INT UNSIGNED NOT NULL AUTO_INCREMENT, judul VARCHAR(180) NOT NULL DEFAULT '', data_json LONGTEXT NOT NULL, urutan INT NOT NULL DEFAULT 0, status VARCHAR(20) NOT NULL DEFAULT 'aktif', created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    }
}

function seedTatibSectionTables(mysqli $connection): void
{
    $source = $connection->query("SELECT data_json FROM tatib_konten ORDER BY id LIMIT 1");
    $row = $source ? $source->fetch_assoc() : null;
    $data = json_decode((string) ($row['data_json'] ?? '{}'), true);
    if (!is_array($data)) return;
    $map = [
        'tatib_hero' => ['hero_title', 'hero_subtitle', 'hero_image', 'intro_title', 'intro'],
        'tatib_ringkasan' => ['year', 'applies', 'updated', 'status'],
        'tatib_ketentuan_umum' => ['general'], 'tatib_prinsip' => ['principle', 'principle_desc'],
        'tatib_kategori' => ['categories'], 'tatib_hak_siswa' => ['rights'], 'tatib_kewajiban_siswa' => ['duties'],
        'tatib_pembinaan' => ['guidance_note', 'guidance'], 'tatib_pelanggaran' => ['violation_desc', 'violations'],
        'tatib_dokumen' => ['pdf', 'pdf_url', 'help', 'contact'], 'tatib_komitmen' => ['commitment', 'commitment_sub'],
    ];
    foreach ($map as $table => $keys) {
        $check = $connection->query("SELECT COUNT(*) AS total FROM `$table`");
        if ($check && (int) ($check->fetch_assoc()['total'] ?? 0) > 0) continue;
        $section = [];
        foreach ($keys as $key) $section[$key] = $data[$key] ?? null;
        $title = (string) ($section['hero_title'] ?? $section['intro_title'] ?? $keys[0]);
        $safeTitle = $connection->real_escape_string($title);
        $json = $connection->real_escape_string((string) json_encode($section, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
        $connection->query("INSERT INTO `$table` (judul, data_json) VALUES ('$safeTitle', '$json')");
    }
}


function ensureOsisTables(mysqli $connection): void
{
    $tables = ['osis_hero', 'osis_pengenalan', 'osis_statistik', 'osis_visi_misi', 'osis_pengurus', 'osis_bidang', 'osis_program', 'osis_agenda', 'osis_galeri', 'osis_kutipan', 'osis_cta'];
    foreach ($tables as $table) {
        $connection->query("CREATE TABLE IF NOT EXISTS `$table` (id INT UNSIGNED NOT NULL AUTO_INCREMENT, judul VARCHAR(180) NOT NULL DEFAULT '', deskripsi TEXT NULL, gambar VARCHAR(255) NULL, data_json LONGTEXT NULL, urutan INT NOT NULL DEFAULT 0, status VARCHAR(20) NOT NULL DEFAULT 'aktif', created_at DATETIME DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    }
    $seed = [
        'osis_hero' => [['judul' => 'Organisasi Siswa Intra Sekolah', 'deskripsi' => 'Wadah siswa untuk belajar memimpin, melayani, dan bertumbuh bersama.', 'gambar' => 'assets/images/1030.JPG']],
        'osis_pengenalan' => [['judul' => 'Mengenal OSIS SMAK', 'deskripsi' => 'OSIS SMAK Mgr. Soegijapranata adalah organisasi siswa yang hangat dan kompak. Kami berkomitmen menjadi sahabat bagi seluruh siswa dan berkontribusi positif bagi sekolah dan lingkungan sekitar.', 'lanjutan' => 'Melalui kebersamaan, kami belajar memimpin, berkarya, dan melayani dengan hati.', 'nama' => 'OSIS SMAK', 'sekolah' => 'Mgr. Soegijapranata', 'masa_bakti' => 'Masa Bakti 2026/2027', 'motto' => 'Berkarya • Melayani • Menginspirasi', 'logo' => 'assets/images/logo_sekolah.png']],
        'osis_statistik' => [['judul' => 'Pengurus', 'nilai' => '8'], ['judul' => 'Bidang', 'nilai' => '4'], ['judul' => 'Program', 'nilai' => '6'], ['judul' => 'Masa Bakti', 'nilai' => '1']],
        'osis_visi_misi' => [['judul' => 'Visi OSIS', 'deskripsi' => 'Menjadi OSIS yang berkarakter, peduli, dan berkontribusi positif demi terwujudnya lingkungan sekolah yang nyaman dan bermakna.'], ['judul' => 'Kepemimpinan', 'deskripsi' => 'Mengembangkan jiwa kepemimpinan serta tanggung jawab dalam diri setiap siswa.'], ['judul' => 'Kepedulian', 'deskripsi' => 'Menumbuhkan kepedulian sosial dan semangat melayani kepada sesama.'], ['judul' => 'Kerja Sama', 'deskripsi' => 'Membangun kerja sama yang baik dalam setiap kegiatan OSIS.']],
        'osis_pengurus' => [['judul' => 'Ketua OSIS', 'nama' => 'Nama Ketua', 'kelas' => 'Kelas XI'], ['judul' => 'Wakil Ketua', 'nama' => 'Nama Wakil', 'kelas' => 'Kelas XI'], ['judul' => 'Sekretaris', 'nama' => 'Nama Sekretaris', 'kelas' => 'Kelas X'], ['judul' => 'Bendahara', 'nama' => 'Nama Bendahara', 'kelas' => 'Kelas X'], ['judul' => 'Koordinator Kegiatan', 'nama' => 'Nama Koordinator', 'kelas' => 'Kelas XI']],
        'osis_bidang' => [['judul' => 'Kerohanian & Karakter', 'deskripsi' => 'Menguatkan nilai iman, karakter, dan kedisiplinan siswa.'], ['judul' => 'Akademik & Kreativitas', 'deskripsi' => 'Mendukung kegiatan belajar dan mengembangkan kreativitas siswa.'], ['judul' => 'Olahraga & Kebersamaan', 'deskripsi' => 'Mendorong gaya hidup sehat dan mempererat kebersamaan siswa.'], ['judul' => 'Sosial & Lingkungan', 'deskripsi' => 'Menumbuhkan kepedulian sosial dan menjaga lingkungan sekolah.']],
        'osis_program' => [['judul' => 'Masa Pengenalan Siswa', 'deskripsi' => 'Menyambut siswa baru agar cepat beradaptasi dengan lingkungan sekolah.'], ['judul' => 'Perayaan Hari Besar Sekolah', 'deskripsi' => 'Memperingati hari besar untuk menumbuhkan nilai kebersamaan dan iman.'], ['judul' => 'Class Meeting', 'deskripsi' => 'Kegiatan olahraga dan lomba untuk menyalurkan bakat dan sportivitas.'], ['judul' => 'Bakti Sosial', 'deskripsi' => 'Berbagi dan melayani sebagai wujud kepedulian terhadap sesama.']],
        'osis_agenda' => [['judul' => 'Agustus', 'kegiatan' => 'Pelantikan Pengurus'], ['judul' => 'Desember', 'kegiatan' => 'Class Meeting'], ['judul' => 'Februari', 'kegiatan' => 'Bakti Sosial'], ['judul' => 'Juni', 'kegiatan' => 'Evaluasi & Regenerasi']],
        'osis_galeri' => [['judul' => 'Dokumentasi 1'], ['judul' => 'Dokumentasi 2'], ['judul' => 'Dokumentasi 3']],
        'osis_kutipan' => [['judul' => 'Kutipan Siswa', 'deskripsi' => 'OSIS mengajarkan saya arti tanggung jawab, kerja sama, dan pelayanan. Di sini saya belajar memimpin dengan hati dan menghadirkan perubahan kecil yang berdampak besar.', 'penulis' => 'Siswa SMAK']],
        'osis_cta' => [['judul' => 'Ingin Menjadi Bagian dari OSIS?', 'deskripsi' => 'Tunjukkan minatmu untuk bergabung dan berkontribusi di OSIS.', 'kontak' => 'https://wa.me/628155099445', 'langkah' => [['judul' => 'Sampaikan Minat', 'deskripsi' => 'Tunjukkan minatmu untuk bergabung dan berkontribusi di OSIS.'], ['judul' => 'Berdiskusi dengan Pembina', 'deskripsi' => 'Berdiskusilah dengan pembina untuk mengetahui informasi lebih lanjut.']]]],
    ];
    foreach ($seed as $table => $rows) {
        $check = $connection->query("SELECT COUNT(*) AS total FROM `$table`");
        if ($check && (int) ($check->fetch_assoc()['total'] ?? 0) > 0) continue;
        foreach ($rows as $index => $row) {
            $judul = $connection->real_escape_string((string) ($row['judul'] ?? ''));
            $deskripsi = $connection->real_escape_string((string) ($row['deskripsi'] ?? ''));
            $gambar = $connection->real_escape_string((string) ($row['gambar'] ?? ''));
            $json = $connection->real_escape_string((string) json_encode($row, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
            $connection->query("INSERT INTO `$table` (judul, deskripsi, gambar, data_json, urutan) VALUES ('$judul', '$deskripsi', '$gambar', '$json', $index)");
        }
    }
}


function ensurePrestasiSiswaTables(mysqli $connection): void
{
    $queries = [
        "CREATE TABLE IF NOT EXISTS prestasisiswa_konten (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, hero_judul VARCHAR(180) NOT NULL, hero_subjudul TEXT NULL, hero_gambar VARCHAR(255) NULL, intro_judul VARCHAR(180) NULL, intro_deskripsi TEXT NULL, nama_sekolah VARCHAR(180) NULL, motto_sekolah VARCHAR(180) NULL, logo VARCHAR(255) NULL, statistik_total VARCHAR(30) NULL, statistik_olahraga VARCHAR(30) NULL, statistik_seni VARCHAR(30) NULL, statistik_sosial VARCHAR(30) NULL, cerita_judul VARCHAR(180) NULL, cerita_kutipan TEXT NULL, cerita_siswa VARCHAR(180) NULL, cerita_prestasi VARCHAR(180) NULL, cerita_gambar VARCHAR(255) NULL, cta_judul VARCHAR(180) NULL, cta_deskripsi TEXT NULL, cta_tombol_1 VARCHAR(100) NULL, cta_tombol_2 VARCHAR(100) NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS prestasisiswa_prestasi (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, siswa VARCHAR(180) NULL, kategori VARCHAR(100) NULL, tanggal VARCHAR(100) NULL, tingkat VARCHAR(180) NULL, gambar VARCHAR(255) NULL, unggulan TINYINT(1) NOT NULL DEFAULT 0, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS prestasisiswa_bidang (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS prestasisiswa_pembinaan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, deskripsi TEXT NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS prestasisiswa_perjalanan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, tahun VARCHAR(10) NOT NULL, jumlah VARCHAR(30) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS prestasisiswa_dokumentasi (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, judul VARCHAR(180) NOT NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
    ];
    foreach ($queries as $query) {
        if (!$connection->query($query)) throw new RuntimeException($connection->error);
    }

    $connection->query("INSERT INTO prestasisiswa_konten (hero_judul, hero_subjudul, hero_gambar, intro_judul, intro_deskripsi, nama_sekolah, motto_sekolah, logo, statistik_total, statistik_olahraga, statistik_seni, statistik_sosial, cerita_judul, cerita_kutipan, cerita_siswa, cerita_prestasi, cerita_gambar, cta_judul, cta_deskripsi, cta_tombol_1, cta_tombol_2) SELECT 'Prestasi Siswa', 'Apresiasi atas bakat, kerja keras, dan pencapaian siswa di berbagai bidang.', 'assets/images/1030.JPG', 'Setiap Siswa Punya Potensi', 'SMAK mendampingi siswa mengembangkan kemampuan olahraga, seni dan budaya, kepemimpinan, serta kerohanian dan sosial. Setiap pencapaian adalah hasil latihan, pembinaan, dan dukungan seluruh komunitas sekolah.', 'SMAK Mgr. Soegijapranata', 'Beriman - Berilmu - Berkarakter', 'assets/images/logo_sekolah.png', '12', '5', '4', '3', 'Cerita Siswa Berprestasi', 'Prestasi bukan hanya tentang menang, tetapi tentang proses, disiplin, dan tidak mudah menyerah.', 'Nama Siswa - Kelas XI', 'Juara II Basket Tingkat Kabupaten', 'assets/images/prestasi_siswa/siswa_berprestasi.jpg', 'Terus Berkarya dan Menginspirasi', 'Mari mengembangkan potensi dan membawa nama baik SMAK.', 'Lihat Kegiatan Siswa', 'Hubungi Sekolah' WHERE NOT EXISTS (SELECT 1 FROM prestasisiswa_konten)");

    $seed = [
        'prestasisiswa_prestasi' => [
            ['Juara II Basket Tingkat Kabupaten', 'Nama Siswa', 'Olahraga', 'Mei 2026', 'Kabupaten Lumajang', 'assets/images/prestasi_siswa/basket.jpg', 1],
            ['Juara III Solo Vokal', 'Nama Siswa', 'Seni & Budaya', 'April 2026', 'Kabupaten Lumajang', 'assets/images/prestasi_siswa/solo_vokal.jpg', 1],
            ['Penghargaan Paskibra', 'Nama Siswa', 'Organisasi', 'Agustus 2026', 'Kabupaten Lumajang', 'assets/images/prestasi_siswa/paskibra.jpg', 1],
            ['Juara I Futsal Putra', 'Nama Siswa', 'Olahraga', 'Maret 2026', 'Kabupaten', 'assets/images/prestasi_siswa/futsal.jpg', 0],
            ['Juara II Tenis Meja', 'Nama Siswa', 'Olahraga', 'Juni 2026', 'Kabupaten', 'assets/images/prestasi_siswa/tenis_meja.jpg', 0],
            ['Juara Harapan I Tari', 'Nama Siswa', 'Seni & Budaya', 'Mei 2026', 'Kabupaten', 'assets/images/prestasi_siswa/tari.jpg', 0],
            ['Juara II Band Pelajar', 'Nama Siswa', 'Seni & Budaya', 'Juni 2026', 'Kabupaten', 'assets/images/prestasi_siswa/band.jpg', 0],
            ['Juara II Lomba PMR', 'Nama Siswa', 'Organisasi', 'April 2026', 'Kabupaten', 'assets/images/prestasi_siswa/pmr.jpg', 0],
            ['Juara I Paduan Suara Rohani', 'Nama Siswa', 'Kerohanian & Sosial', 'Maret 2026', 'Kabupaten', 'assets/images/prestasi_siswa/paduan_suara.jpg', 0],
        ],
        'prestasisiswa_bidang' => [['Olahraga', 'Sportivitas dan semangat juang'], ['Seni & Budaya', 'Kreativitas dan pelestarian budaya'], ['Kepemimpinan', 'Karakter pemimpin yang bertanggung jawab'], ['Kerohanian & Sosial', 'Iman dan kepedulian kepada sesama']],
        'prestasisiswa_pembinaan' => [['Pendampingan Guru', 'Guru membimbing dan mengarahkan potensi siswa.'], ['Latihan Terarah', 'Latihan rutin sesuai minat dan kemampuan.'], ['Mengikuti Kegiatan', 'Siswa didorong mengikuti lomba dan kompetisi.'], ['Apresiasi Sekolah', 'Sekolah memberikan penghargaan dan dukungan.']],
        'prestasisiswa_perjalanan' => [['2023', '5'], ['2024', '7'], ['2025', '9'], ['2026', '12']],
        'prestasisiswa_dokumentasi' => [['Latihan Basket', 'assets/images/prestasi_siswa/dokumentasi_basket.jpg'], ['Lomba Paduan Suara', 'assets/images/prestasi_siswa/dokumentasi_paduan_suara.jpg'], ['Kegiatan Paskibra', 'assets/images/prestasi_siswa/dokumentasi_paskibra.jpg']],
    ];
    foreach ($seed as $table => $rows) {
        $count = $connection->query("SELECT COUNT(*) AS total FROM `$table`");
        if ($count && (int) ($count->fetch_assoc()['total'] ?? 0) > 0) continue;
        foreach ($rows as $index => $row) {
            $values = array_map(fn ($value) => "'" . $connection->real_escape_string((string) $value) . "'", $row);
            if ($table === 'prestasisiswa_prestasi') {
                $connection->query("INSERT INTO `$table` (judul, siswa, kategori, tanggal, tingkat, gambar, unggulan, urutan) VALUES (" . implode(',', $values) . ", $index)");
            } elseif ($table === 'prestasisiswa_perjalanan') {
                $connection->query("INSERT INTO `$table` (tahun, jumlah, urutan) VALUES (" . implode(',', $values) . ", $index)");
            } elseif ($table === 'prestasisiswa_dokumentasi') {
                $connection->query("INSERT INTO `$table` (judul, gambar, urutan) VALUES (" . implode(',', $values) . ", $index)");
            } else {
                $connection->query("INSERT INTO `$table` (judul, deskripsi, urutan) VALUES (" . implode(',', $values) . ", $index)");
            }
        }
    }
}


function ensureEkstrakulikulerTables(mysqli $connection): void
{
    $queries = [
        "CREATE TABLE IF NOT EXISTS ekstrakulikuler_konten (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, hero_judul VARCHAR(180) NOT NULL, hero_subjudul TEXT NULL, hero_gambar VARCHAR(255) NULL, intro_judul VARCHAR(180) NULL, intro_teks_1 TEXT NULL, intro_teks_2 TEXT NULL, gambar_pembinaan VARCHAR(255) NULL, cta_judul VARCHAR(180) NULL, cta_deskripsi TEXT NULL, cta_tombol VARCHAR(100) NULL, cta_link VARCHAR(255) NULL, frontend_json LONGTEXT NULL, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "CREATE TABLE IF NOT EXISTS ekstrakulikuler_kegiatan (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, nama VARCHAR(180) NOT NULL, kategori VARCHAR(100) NULL, deskripsi TEXT NULL, jadwal VARCHAR(180) NULL, lokasi VARCHAR(180) NULL, pembina VARCHAR(180) NULL, peserta VARCHAR(180) NULL, gambar VARCHAR(255) NULL, urutan INT NOT NULL DEFAULT 0, status ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif', created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)",
        "INSERT INTO ekstrakulikuler_konten (hero_judul, hero_subjudul, hero_gambar, intro_judul, intro_teks_1, intro_teks_2, gambar_pembinaan, cta_judul, cta_deskripsi, cta_tombol, cta_link, frontend_json) SELECT 'Ekstrakurikuler', 'Ruang untuk bertumbuh, berkarya, dan menemukan potensi terbaikmu.', 'assets/images/IMG_5196.JPG', 'Temukan Minat dan Bakatmu', 'Melalui kegiatan ekstrakurikuler, siswa dapat mengembangkan minat, belajar bekerja sama, berani tampil, dan bertumbuh menjadi pribadi yang berkarakter.', 'Pilih kegiatan yang sesuai dengan minatmu dan nikmati prosesnya bersama teman serta pembina yang mendukung.', 'assets/images/IMG_5196.JPG', 'Ayo Temukan Kegiatan yang Kamu Sukai', 'Informasi ekstrakurikuler dapat ditanyakan langsung kepada pihak sekolah.', 'Tanya Sekolah', 'https://wa.me/628155099445', '{}' WHERE NOT EXISTS (SELECT 1 FROM ekstrakulikuler_konten)",
    ];
    foreach ($queries as $query) if (!$connection->query($query)) throw new RuntimeException($connection->error);
    $count = $connection->query("SELECT COUNT(*) AS total FROM ekstrakulikuler_kegiatan");
    if ($count && (int) ($count->fetch_assoc()['total'] ?? 0) === 0) {
        $rows = [
            ['Basket','Olahraga','Mengembangkan kerja sama, strategi, sportivitas, dan keterampilan bermain di lapangan.','Selasa & Kamis, 15.30 WIB','Lapangan sekolah','Bapak Andi (data dummy)','Siswa kelas X-XII','assets/images/ekstrakurikuler/basket.jpg'],
            ['Voli','Olahraga','Melatih kekompakan, teknik dasar, ketangkasan, dan semangat tim.','Senin & Rabu, 15.30 WIB','Lapangan sekolah','Ibu Maria (data dummy)','Siswa kelas X-XII','assets/images/ekstrakurikuler/voli.jpg'],
            ['Band Sekolah','Seni','Ruang untuk menyalurkan kreativitas musik dan belajar tampil percaya diri.','Rabu, 15.30 WIB','Ruang musik','Bapak Rudi (data dummy)','Siswa kelas X-XII','assets/images/ekstrakurikuler/band_sekolah.jpg'],
            ['Paduan Suara','Seni','Melatih olah vokal, harmoni, kedisiplinan, dan kebersamaan.','Kamis, 15.30 WIB','Aula sekolah','Ibu Agatha (data dummy)','Siswa kelas X-XII','assets/images/ekstrakurikuler/paduan_suara.jpg'],
            ['Pramuka','Kepramukaan','Membentuk pribadi mandiri, peduli, disiplin, dan siap bekerja sama.','Sabtu, 07.30 WIB','Halaman sekolah','Kak Dimas (data dummy)','Siswa kelas X-XII','assets/images/ekstrakurikuler/pramuka.jpg'],
        ];
        foreach ($rows as $index => $row) {
            $values = implode(',', array_map(fn ($value) => "'" . $connection->real_escape_string($value) . "'", $row));
            $connection->query("INSERT INTO ekstrakulikuler_kegiatan (nama,kategori,deskripsi,jadwal,lokasi,pembina,peserta,gambar,urutan) VALUES ($values,$index)");
        }
    }
}


function requestPayload(): array
{
    $payload = json_decode(file_get_contents('php://input'), true);
    return is_array($payload) ? $payload : [];
}

function requestIp(): string
{
    return substr((string) ($_SERVER['REMOTE_ADDR'] ?? 'unknown'), 0, 45);
}

function requestBearerToken(): string
{
    $authorization = (string) ($_SERVER['HTTP_AUTHORIZATION'] ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? '');
    if ($authorization === '' && function_exists('getallheaders')) {
        foreach (getallheaders() as $name => $value) {
            if (strcasecmp((string) $name, 'Authorization') === 0) {
                $authorization = (string) $value;
                break;
            }
        }
    }
    return preg_match('/^Bearer[ \t]+(\S+)$/i', trim($authorization), $matches) === 1 ? $matches[1] : '';
}

function validSession(mysqli $connection, string $token): ?array
{
    if ($token === '') return null;
    $hash = hash('sha256', $token);
    $statement = $connection->prepare(
        "SELECT s.*, u.nama, u.username, u.email, u.role
         FROM admin_sessions s
         JOIN users u ON u.id = s.user_id
         WHERE s.session_hash = ? AND s.logout_at IS NULL AND s.revoked_at IS NULL
           AND s.expires_at > NOW() LIMIT 1"
    );
    $statement->bind_param('s', $hash);
    $statement->execute();
    $session = $statement->get_result()->fetch_assoc();
    if (!$session || ($session['role'] ?? '') !== 'admin') return null;
    $connection->query("UPDATE admin_sessions SET last_seen_at = NOW() WHERE id = " . (int) $session['id']);
    return $session;
}

if ($_SERVER['REQUEST_METHOD'] === 'GET' && ($_GET['action'] ?? '') === 'security_dashboard') {
    $session = validSession($connection, requestBearerToken());
    if (!$session) {
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'Sesi login tidak valid atau sudah berakhir.']);
        exit;
    }

    $summary = $connection->query(
        "SELECT
          (SELECT COUNT(*) FROM admin_sessions WHERE logout_at IS NULL AND revoked_at IS NULL AND expires_at > NOW()) AS active_sessions,
          (SELECT COUNT(*) FROM login_attempts WHERE status = 'failed' AND DATE(attempted_at) = CURDATE()) AS failed_today,
          ((SELECT COUNT(*) FROM activity_logs WHERE DATE(created_at) = CURDATE()) +
           (SELECT COUNT(*) FROM login_attempts WHERE status <> 'success' AND DATE(attempted_at) = CURDATE())) AS activities_today,
          (SELECT COUNT(*) FROM security_alerts WHERE is_read = 0) AS unread_alerts"
    )->fetch_assoc();

    $activities = [];
    $result = $connection->query(
        "(SELECT CONCAT('activity-', a.id) AS event_id, a.action, a.module,
                 a.description, a.ip_address, a.created_at, u.nama,
                 NULL AS browser, NULL AS operating_system, 'activity' AS source
          FROM activity_logs a LEFT JOIN users u ON u.id = a.user_id)
         UNION ALL
         (SELECT CONCAT('attempt-', l.id) AS event_id,
                 IF(l.status = 'success', 'login', 'login_failed') AS action,
                 'autentikasi' AS module,
                 IF(l.status = 'success', CONCAT(l.username, ' berhasil masuk'), CONCAT('Login ', l.username, ' gagal')) AS description,
                 l.ip_address, l.attempted_at AS created_at, l.username AS nama,
                 l.browser, l.operating_system, 'login_attempt' AS source
          FROM login_attempts l WHERE l.status <> 'success')
         ORDER BY created_at DESC LIMIT 15"
    );
    while ($row = $result->fetch_assoc()) $activities[] = $row;

    $sessions = [];
    $result = $connection->query(
        "SELECT s.id, s.user_id, s.browser, s.browser_version, s.operating_system,
                s.device_type, s.device_name, s.city, s.region, s.country,
                s.ip_address, s.login_at, s.last_seen_at, s.expires_at, u.nama
         FROM admin_sessions s JOIN users u ON u.id = s.user_id
         WHERE s.logout_at IS NULL AND s.revoked_at IS NULL AND s.expires_at > NOW()
         ORDER BY s.last_seen_at DESC LIMIT 10"
    );
    while ($row = $result->fetch_assoc()) {
        $row['current'] = (int) $row['id'] === (int) $session['id'];
        $sessions[] = $row;
    }

    $alerts = [];
    $result = $connection->query(
        "SELECT * FROM security_alerts WHERE is_read = 0 ORDER BY created_at DESC LIMIT 5"
    );
    while ($row = $result->fetch_assoc()) $alerts[] = $row;

    $attempts = [];
    $result = $connection->query(
        "SELECT id, username, status, failure_reason, ip_address, browser,
                operating_system, device_type, city, region, country, attempted_at
         FROM login_attempts ORDER BY attempted_at DESC LIMIT 10"
    );
    while ($row = $result->fetch_assoc()) $attempts[] = $row;

    echo json_encode([
        'success' => true,
        'summary' => $summary,
        'activities' => $activities,
        'sessions' => $sessions,
        'alerts' => $alerts,
        'attempts' => $attempts,
    ]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_FILES['file'])) {
        $table = $_POST['table'] ?? '';
        if (!in_array($table, $allowedTables, true)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Tabel upload tidak diizinkan.']);
            exit;
        }

        $session = validSession($connection, requestBearerToken() ?: trim((string) ($_POST['session_token'] ?? '')));
        if (!$session) {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Sesi admin tidak valid atau sudah berakhir.']);
            exit;
        }

        $extension = strtolower(pathinfo($_FILES['file']['name'], PATHINFO_EXTENSION));
        $allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'gif', 'pdf', 'doc', 'docx', 'mp4', 'webm', 'mov', 'avi', 'mkv'];
        if (!in_array($extension, $allowedExtensions, true)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Format file tidak didukung.']);
            exit;
        }

        $uploadDirectory = __DIR__ . '/uploads';
        if (!is_dir($uploadDirectory)) mkdir($uploadDirectory, 0775, true);
        $filename = uniqid('smak_', true) . '.' . $extension;
        if (!move_uploaded_file($_FILES['file']['tmp_name'], $uploadDirectory . '/' . $filename)) {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => 'File gagal diunggah.']);
            exit;
        }
        if ($session) {
            $userId = (int) $session['user_id'];
            $sessionId = (int) $session['id'];
            $ip = requestIp();
            $userAgent = substr((string) ($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 1000);
            $description = 'Mengunggah file untuk ' . str_replace('_', ' ', $table);
            $activity = $connection->prepare(
                "INSERT INTO activity_logs (user_id, session_id, action, module, description, ip_address, user_agent)
                 VALUES (?, ?, 'upload', ?, ?, ?, ?)"
            );
            $activity->bind_param('iissss', $userId, $sessionId, $table, $description, $ip, $userAgent);
            $activity->execute();
        }
        echo json_encode(['success' => true, 'filename' => $filename, 'url' => 'uploads/' . $filename]);
        exit;
    }

    $payload = requestPayload();
    $action = $payload['action'] ?? '';
    $table = $payload['table'] ?? '';

    if ($action === 'login') {
        $username = trim((string) ($payload['username'] ?? ''));
        $password = (string) ($payload['password'] ?? '');
        $userAgent = substr((string) ($payload['user_agent'] ?? ($_SERVER['HTTP_USER_AGENT'] ?? '')), 0, 1000);
        $browser = substr((string) ($payload['browser'] ?? 'Browser'), 0, 80);
        $os = substr((string) ($payload['operating_system'] ?? 'Tidak diketahui'), 0, 80);
        $deviceType = (string) ($payload['device_type'] ?? 'unknown');
        if (!in_array($deviceType, ['desktop', 'mobile', 'tablet', 'unknown'], true)) $deviceType = 'unknown';
        $ip = requestIp();

        $statement = $connection->prepare(
            'SELECT id, nama, username, email, password, role FROM users WHERE username = ? OR email = ? LIMIT 1'
        );
        $statement->bind_param('ss', $username, $username);
        $statement->execute();
        $user = $statement->get_result()->fetch_assoc();
        $storedPassword = (string) ($user['password'] ?? '');
        $passwordValid = $user && $user['role'] === 'admin'
            && password_get_info($storedPassword)['algoName'] !== 'unknown'
            && password_verify($password, $storedPassword);
        $status = $passwordValid ? 'success' : 'failed';
        $reason = $user ? 'Password tidak sesuai.' : 'Akun tidak ditemukan.';
        $userId = $user ? (int) $user['id'] : null;
        $attempt = $connection->prepare(
            'INSERT INTO login_attempts (user_id, username, status, failure_reason, ip_address, user_agent, browser, operating_system, device_type)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
        );
        $failureReason = $passwordValid ? null : $reason;
        $attempt->bind_param('issssssss', $userId, $username, $status, $failureReason, $ip, $userAgent, $browser, $os, $deviceType);
        $attempt->execute();

        if (!$passwordValid) {
            $failed = $connection->prepare(
                "SELECT COUNT(*) AS total FROM login_attempts
                 WHERE username = ? AND status = 'failed' AND attempted_at >= DATE_SUB(NOW(), INTERVAL 15 MINUTE)"
            );
            $failed->bind_param('s', $username);
            $failed->execute();
            $failedCount = (int) ($failed->get_result()->fetch_assoc()['total'] ?? 0);
            $title = $failedCount >= 3
                ? 'Percobaan login gagal berulang'
                : 'Percobaan login gagal';
            $description = $failedCount >= 3
                ? "$failedCount percobaan gagal untuk akun $username dalam 15 menit terakhir."
                : "Login gagal untuk akun $username: $reason";
            $severity = $failedCount >= 3 ? 'critical' : 'warning';
            $alert = $connection->prepare(
                "INSERT INTO security_alerts (user_id, alert_type, severity, title, description, ip_address)
                 VALUES (?, 'repeated_login_failure', ?, ?, ?, ?)"
            );
            $alert->bind_param('issss', $userId, $severity, $title, $description, $ip);
            $alert->execute();
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Username/email atau password salah.']);
            exit;
        }

        $token = bin2hex(random_bytes(32));
        $hash = hash('sha256', $token);
        $deviceName = trim("$browser di $os");
        $expiresDays = !empty($payload['remember_me']) ? 30 : 1;
        $sessionStatement = $connection->prepare(
            "INSERT INTO admin_sessions
             (user_id, session_hash, ip_address, user_agent, browser, operating_system, device_type, device_name, expires_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, DATE_ADD(NOW(), INTERVAL ? DAY))"
        );
        $sessionStatement->bind_param('isssssssi', $userId, $hash, $ip, $userAgent, $browser, $os, $deviceType, $deviceName, $expiresDays);
        $sessionStatement->execute();
        $sessionId = (int) $connection->insert_id;
        $description = ((string) $user['nama']) . ' berhasil masuk';
        $activity = $connection->prepare(
            "INSERT INTO activity_logs (user_id, session_id, action, module, description, ip_address, user_agent)
             VALUES (?, ?, 'login', 'autentikasi', ?, ?, ?)"
        );
        $activity->bind_param('iisss', $userId, $sessionId, $description, $ip, $userAgent);
        $activity->execute();

        unset($user['password']);
        echo json_encode(['success' => true, 'session_token' => $token, 'user' => $user]);
        exit;
    }

    if ($action === 'logout') {
        $session = validSession($connection, requestBearerToken() ?: trim((string) ($payload['session_token'] ?? '')));
        if ($session) {
            $sessionId = (int) $session['id'];
            $userId = (int) $session['user_id'];
            $connection->query("UPDATE admin_sessions SET logout_at = NOW() WHERE id = $sessionId");
            $description = ((string) $session['nama']) . ' keluar dari dashboard';
            $ip = requestIp();
            $userAgent = substr((string) ($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 1000);
            $activity = $connection->prepare(
                "INSERT INTO activity_logs (user_id, session_id, action, module, description, ip_address, user_agent)
                 VALUES (?, ?, 'logout', 'autentikasi', ?, ?, ?)"
            );
            $activity->bind_param('iisss', $userId, $sessionId, $description, $ip, $userAgent);
            $activity->execute();
        }
        echo json_encode(['success' => true]);
        exit;
    }

    if ($action === 'revoke_session') {
        $currentSession = validSession($connection, requestBearerToken() ?: trim((string) ($payload['session_token'] ?? '')));
        if (!$currentSession) {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Sesi admin tidak valid.']);
            exit;
        }
        $targetId = (int) ($payload['session_id'] ?? 0);
        if ($targetId === (int) $currentSession['id']) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Gunakan menu logout untuk sesi saat ini.']);
            exit;
        }
        $adminId = (int) $currentSession['user_id'];
        $statement = $connection->prepare(
            "UPDATE admin_sessions SET revoked_at = NOW(), revoked_by = ?, revoke_reason = 'Dikeluarkan dari panel keamanan'
             WHERE id = ? AND logout_at IS NULL AND revoked_at IS NULL"
        );
        $statement->bind_param('ii', $adminId, $targetId);
        $statement->execute();
        echo json_encode(['success' => true]);
        exit;
    }

    if ($action === 'read_alert') {
        $currentSession = validSession($connection, requestBearerToken() ?: trim((string) ($payload['session_token'] ?? '')));
        if (!$currentSession) {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Sesi admin tidak valid.']);
            exit;
        }
        $alertId = (int) ($payload['alert_id'] ?? 0);
        $adminId = (int) $currentSession['user_id'];
        $statement = $connection->prepare(
            'UPDATE security_alerts SET is_read = 1, read_at = NOW(), read_by = ? WHERE id = ?'
        );
        $statement->bind_param('ii', $adminId, $alertId);
        $statement->execute();
        echo json_encode(['success' => true]);
        exit;
    }

    if (!in_array($table, $allowedTables, true) || !in_array($action, ['save', 'delete'], true)) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Permintaan tidak valid.']);
        exit;
    }

    $session = validSession($connection, requestBearerToken() ?: trim((string) ($payload['session_token'] ?? '')));
    if (!$session) {
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'Sesi admin tidak valid atau sudah berakhir.']);
        exit;
    }

    $columnsResult = $connection->query("SHOW COLUMNS FROM `$table`");
    if ($columnsResult === false) {
        http_response_code(500);
        error_log('SMAK API database error: operation=save_columns code=' . $connection->errno);
        apiServerError();
    }
    $columns = [];
    while ($column = $columnsResult->fetch_assoc()) {
        $columns[] = $column['Field'];
    }

    if ($action === 'delete') {
        $id = (int) ($payload['id'] ?? 0);
        if ($table === 'users' && $id === 1) {
            http_response_code(403);
            echo json_encode(['success' => false, 'message' => 'Akun Administrator utama tidak dapat dihapus.']);
            exit;
        }
        $statement = $connection->prepare("DELETE FROM `$table` WHERE id = ?");
        $statement->bind_param('i', $id);
        if (!$statement->execute()) {
            http_response_code(500);
            error_log('SMAK API database error: operation=delete code=' . $statement->errno);
            apiServerError();
        }
        if ($session) {
            $userId = (int) $session['user_id'];
            $sessionId = (int) $session['id'];
            $ip = requestIp();
            $userAgent = substr((string) ($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 1000);
            $description = 'Menghapus data ' . str_replace('_', ' ', $table);
            $activity = $connection->prepare(
                "INSERT INTO activity_logs (user_id, session_id, action, module, description, ip_address, user_agent)
                 VALUES (?, ?, 'delete', ?, ?, ?, ?)"
            );
            $activity->bind_param('iissss', $userId, $sessionId, $table, $description, $ip, $userAgent);
            $activity->execute();
        }
        echo json_encode(['success' => true, 'message' => 'Data berhasil dihapus.']);
        exit;
    }

    $data = is_array($payload['data'] ?? null) ? $payload['data'] : [];
    $data = array_filter($data, static function ($value, $key) use ($columns) {
        return in_array($key, $columns, true) && $key !== 'id' && $key !== 'created_at' && $key !== 'updated_at';
    }, ARRAY_FILTER_USE_BOTH);

    if ($table === 'users') {
        $rejectUserSave = static function (int $status, string $message): void {
            http_response_code($status);
            echo json_encode(['success' => false, 'message' => $message]);
            exit;
        };
        if (($session['role'] ?? '') !== 'admin') {
            $rejectUserSave(403, 'Akses hanya untuk admin.');
        }
        $isUserUpdate = array_key_exists('id', $payload);
        if ($isUserUpdate) {
            $rawId = $payload['id'];
            $userId = (is_int($rawId) || is_string($rawId))
                ? filter_var($rawId, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]) : false;
            if ($userId === false) $rejectUserSave(400, 'ID pengguna tidak valid.');
            $target = $connection->prepare('SELECT id FROM users WHERE id = ?');
            $target->bind_param('i', $userId);
            $target->execute();
            if (!$target->get_result()->fetch_assoc()) $rejectUserSave(404, 'Pengguna tidak ditemukan.');
        }
        $data = array_intersect_key($data, array_flip(['nama', 'username', 'email', 'foto', 'password']));
        foreach (['nama', 'username'] as $field) {
            if (!$isUserUpdate || array_key_exists($field, $data)) {
                if (!is_string($data[$field] ?? null) || trim($data[$field]) === '') {
                    $rejectUserSave(400, $field === 'nama' ? 'Nama wajib diisi.' : 'Username wajib diisi.');
                }
                $data[$field] = trim($data[$field]);
            }
        }
        foreach (['email', 'foto'] as $field) {
            if (array_key_exists($field, $data) && !is_string($data[$field])) {
                $rejectUserSave(400, 'Format data pengguna tidak valid.');
            }
        }
        if (array_key_exists('password', $data) && !is_string($data['password'])) {
            $rejectUserSave(400, 'Format password tidak valid.');
        }
        if (!$isUserUpdate && ($data['password'] ?? '') === '') {
            $rejectUserSave(400, 'Password wajib diisi untuk admin baru.');
        }
        if (array_key_exists('password', $data)) {
            if ($data['password'] === '') {
                unset($data['password']);
            } else {
                $data['password'] = password_hash($data['password'], PASSWORD_ARGON2ID);
            }
        }
        $data['role'] = 'admin';
    }

    if (count($data) === 0) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Tidak ada data untuk disimpan.']);
        exit;
    }

    $escaped = [];
    foreach ($data as $key => $value) {
        $escaped[$key] = "'" . $connection->real_escape_string((string) $value) . "'";
    }

    $id = (int) ($payload['id'] ?? 0);
    if ($id > 0) {
        $updates = [];
        foreach ($escaped as $key => $value) {
            $updates[] = "`$key` = $value";
        }
        if (in_array('updated_at', $columns, true)) {
            $updates[] = "`updated_at` = NOW()";
        }
        $query = "UPDATE `$table` SET " . implode(', ', $updates) . " WHERE id = $id";
    } else {
        if (in_array('created_at', $columns, true) && !isset($escaped['created_at'])) {
            $escaped['created_at'] = "NOW()";
        }
        if (in_array('updated_at', $columns, true) && !isset($escaped['updated_at'])) {
            $escaped['updated_at'] = "NOW()";
        }
        $query = "INSERT INTO `$table` (`" . implode('`,`', array_keys($escaped)) . "`) VALUES (" . implode(',', array_values($escaped)) . ")";
    }

    if (!$connection->query($query)) {
        http_response_code(500);
        error_log('SMAK API database error: operation=save code=' . $connection->errno);
        apiServerError();
    }

    $savedId = $id > 0 ? $id : $connection->insert_id;

    if ($session) {
        $userId = (int) $session['user_id'];
        $sessionId = (int) $session['id'];
        $ip = requestIp();
        $userAgent = substr((string) ($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 1000);
        $logAction = $id > 0 ? 'update' : 'create';
        $description = ($id > 0 ? 'Memperbarui ' : 'Menambahkan ') . str_replace('_', ' ', $table);
        if ($table === 'users' && array_key_exists('password', $data)) {
            $logAction = 'change_password';
            $description = 'Mengubah password pengguna';
        }
        $activity = $connection->prepare(
            "INSERT INTO activity_logs (user_id, session_id, action, module, description, ip_address, user_agent)
             VALUES (?, ?, ?, ?, ?, ?, ?)"
        );
        $activity->bind_param('iisssss', $userId, $sessionId, $logAction, $table, $description, $ip, $userAgent);
        $activity->execute();
    }

    echo json_encode(['success' => true, 'message' => 'Data berhasil disimpan.', 'id' => $savedId]);
    exit;
}

$table = $_GET['table'] ?? '';
$limit = max(1, min((int) ($_GET['limit'] ?? 50), 100));
$offset = max(0, (int) ($_GET['offset'] ?? 0));

if (!in_array($table, $allowedTables, true)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'Nama tabel tidak diizinkan.',
    ]);
    exit;
}

if (!in_array($table, $publicReadTables, true)) {
    $session = validSession($connection, requestBearerToken());
    if (!$session) {
        http_response_code(401);
        echo json_encode(['success' => false, 'message' => 'Sesi admin tidak valid atau sudah berakhir.']);
        exit;
    }
    if (($session['role'] ?? '') !== 'admin') {
        http_response_code(403);
        echo json_encode(['success' => false, 'message' => 'Akses hanya untuk admin.']);
        exit;
    }
}

$columnsResult = $connection->query("SHOW COLUMNS FROM `$table`");
$columns = [];
if ($columnsResult) {
    while ($col = $columnsResult->fetch_assoc()) {
        $columns[] = $col['Field'];
    }
}

$orderBy = "id DESC";
if (in_array('urutan', $columns, true)) {
    $orderBy = "`urutan` ASC, `id` DESC";
} elseif (in_array('updated_at', $columns, true)) {
    $orderBy = "`updated_at` DESC, `id` DESC";
} elseif (in_array('created_at', $columns, true)) {
    $orderBy = "`created_at` DESC, `id` DESC";
}

$isPublicBeritaRequest = $table === 'berita' && !validSession($connection, requestBearerToken());

// Fetch berita without a SQL status predicate. Older SMAK databases have used
// different status column definitions/labels; public visibility is normalized
// below in PHP so a valid published row is not accidentally discarded by SQL.
$query = "SELECT * FROM `$table` ORDER BY $orderBy LIMIT ? OFFSET ?";
$statement = $connection->prepare($query);

if ($statement === false) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Query tidak dapat diproses.']);
    exit;
}

$statement->bind_param('ii', $limit, $offset);
$statement->execute();
$result = $statement->get_result();
$rows = [];

while ($row = $result->fetch_assoc()) {
    if ($isPublicBeritaRequest) {
        $status = strtolower(trim((string) ($row['status'] ?? '')));
        if (in_array($status, ['draft', 'nonaktif', 'unpublished', '0'], true)) {
            continue;
        }
    }
    if ($table === 'users') unset($row['password']);
    if ($table === 'admin_sessions') unset($row['session_hash']);
    if ($table === 'berita') {
        // Keep public clients compatible with both the original news schema
        // (deskripsi/gambar/tanggal) and the CMS schema
        // (ringkasan/isi/thumbnail/tanggal_publikasi).
        if (empty($row['deskripsi'])) {
            $row['deskripsi'] = $row['ringkasan'] ?? $row['isi'] ?? '';
        }
        if (empty($row['gambar'])) {
            $row['gambar'] = $row['thumbnail'] ?? $row['foto'] ?? '';
        }
        if (empty($row['tanggal'])) {
            $row['tanggal'] = $row['tanggal_publikasi'] ?? $row['created_at'] ?? '';
        }
    }
    $rows[] = $row;
}

echo json_encode([
    'success' => true,
    'table' => $table,
    'data' => $rows,
]);
