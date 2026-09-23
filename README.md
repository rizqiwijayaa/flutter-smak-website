# 🏫 Flutter School Website CMS

Website sekolah dinamis yang dibangun menggunakan **Flutter Web**, **PHP API**, dan **MySQL**.

Project ini dikembangkan untuk menyediakan website informasi sekolah sekaligus **Content Management System (CMS)** melalui Admin Dashboard. Berbagai konten pada website dapat dikelola secara dinamis tanpa harus mengubah source code frontend secara langsung.

## ✨ Fitur Utama

### 🌐 Website Publik

- Beranda dengan banner/slider dinamis
- Profil dan identitas sekolah
- Sambutan kepala sekolah
- Sejarah sekolah
- Visi dan misi
- Struktur organisasi
- Sarana dan prasarana
- Informasi akademik
- Jadwal pelajaran
- Kalender akademik
- Kurikulum
- Prestasi akademik
- Ekstrakurikuler
- OSIS
- Prestasi siswa
- Tata tertib
- Berita sekolah
- Galeri foto dan media
- Informasi PPDB
- Halaman kontak
- Maintenance mode
- Responsive layout untuk berbagai ukuran layar
- Clean URL / routing untuk halaman publik

### 🛠️ Admin Dashboard

Admin Dashboard digunakan untuk mengelola berbagai bagian website secara dinamis.

Fitur yang tersedia:

- Login administrator
- Dashboard pengelolaan website
- Manajemen konten beranda
- Manajemen profil sekolah
- Manajemen informasi akademik
- Manajemen kesiswaan
- Manajemen berita
- Manajemen galeri
- Manajemen PPDB
- Manajemen kontak
- Manajemen pengguna
- Pengelolaan banner dan slider
- Upload gambar dan media
- Preview konten
- Validasi dan pembatasan panjang konten
- Pengaturan Website

### ⚙️ Pengaturan Website

Pengaturan Website menyediakan konfigurasi website melalui Admin Dashboard, meliputi:

- Identitas website
- Pengaturan tampilan
- Pengaturan footer
- Pengaturan halaman login
- Pengaturan SEO
- Pengaturan status website
- Maintenance mode
- Pengaturan keamanan dan aktivitas

## 🔐 Keamanan & Monitoring Login

Sistem administrator dilengkapi dengan pencatatan aktivitas login untuk membantu pemantauan akses ke Admin Dashboard.

Fitur monitoring meliputi:

- Riwayat aktivitas login administrator
- Pencatatan login berhasil
- Pencatatan percobaan login gagal
- Pencatatan alamat IP pada aktivitas login
- Informasi aktivitas akses administrator

Credential database production tidak ditulis langsung di dalam source code. Konfigurasi database mendukung penggunaan **environment variable** sehingga informasi sensitif dapat dipisahkan dari repository.

## 🧰 Teknologi

| Teknologi | Penggunaan |
| --- | --- |
| Flutter / Dart | Frontend website dan Admin Dashboard |
| PHP | Backend / API |
| MySQL | Database |
| HTML | Entry point dan konfigurasi Flutter Web |
| Apache / `.htaccess` | Routing dan konfigurasi deployment |
| LocalStorage | Penyimpanan data tertentu pada browser |
| cPanel | Deployment website |

## 🏗️ Arsitektur

```text
                   ┌──────────────────────┐
                   │     Flutter Web      │
                   │                      │
                   │   Public Website     │
                   │   Admin Dashboard    │
                   └──────────┬───────────┘
                              │
                         HTTP Request
                              │
                              ▼
                   ┌──────────────────────┐
                   │       PHP API        │
                   └──────────┬───────────┘
                              │
                 ┌────────────┴────────────┐
                 │                         │
                 ▼                         ▼
        ┌────────────────┐       ┌────────────────┐
        │     MySQL      │       │ Media Uploads  │
        │    Database    │       │ Images / Files │
        └────────────────┘       └────────────────┘
```

Frontend berkomunikasi dengan backend melalui API. Data yang tersimpan di database kemudian digunakan untuk membangun konten website secara dinamis.

Administrator dapat memperbarui berbagai bagian website melalui Admin Dashboard tanpa perlu melakukan perubahan langsung pada source code frontend.

## 📁 Struktur Project

```text
website_smak/
├── api/
│   ├── config.php
│   ├── index.php
│   └── uploads/
│
├── assets/
│   └── images/
│
├── database/
│   └── migration SQL
│
├── docs/
│
├── lib/
│   ├── admin/
│   │   ├── akademik/
│   │   ├── berita/
│   │   ├── dashboard/
│   │   ├── galeri/
│   │   ├── kesiswaan/
│   │   ├── kontak/
│   │   ├── pengaturan_website/
│   │   ├── pengguna/
│   │   ├── ppdb/
│   │   ├── profil/
│   │   └── shared/
│   │
│   ├── landing_page/
│   ├── routing/
│   ├── services/
│   └── main.dart
│
├── test/
├── web/
├── android/
├── ios/
├── linux/
├── macos/
├── windows/
├── pubspec.yaml
└── README.md
```

## 🔄 Pengelolaan Konten Dinamis

Salah satu fokus utama project ini adalah mengurangi konten yang bersifat hardcoded pada frontend.

Konten website dikelola melalui alur:

```text
Admin Dashboard
       │
       ▼
    PHP API
       │
       ▼
 MySQL Database
       │
       ▼
Public Website
```

Dengan pendekatan ini, administrator dapat memperbarui informasi website melalui dashboard tanpa perlu membuka atau mengubah source code Flutter.

## 🖼️ Pengelolaan Media

Website mendukung penggunaan media untuk berbagai konten seperti:

- Banner halaman
- Slider beranda
- Galeri
- Berita
- Prestasi
- Ekstrakurikuler
- Profil sekolah
- Konten pendukung halaman lainnya

Media dapat diunggah melalui sistem pengelolaan konten dan kemudian digunakan oleh halaman website.

## 🛣️ Routing

Website menggunakan routing untuk menyediakan URL yang lebih bersih pada halaman publik.

Contoh struktur route:

```text
/
/berita
/galeri
/ppdb
/kontak
/login
```

Routing juga digunakan untuk mengatur navigasi antarhalaman pada Flutter Web.

## 🔧 Konfigurasi Database

Backend PHP menggunakan MySQL sebagai database.

Konfigurasi database mendukung environment variable:

```text
SMAK_DB_HOST
SMAK_DB_USER
SMAK_DB_PASSWORD
SMAK_DB_NAME
SMAK_DB_PORT
```

Dengan pendekatan ini, credential database production tidak perlu disimpan secara langsung di dalam source code repository.

## 🚀 Menjalankan Project

### 1. Clone Repository

```bash
git clone https://github.com/rizqiwijayaa/flutter-smak-website.git
```

Masuk ke folder project:

```bash
cd flutter-smak-website
```

### 2. Install Dependency Flutter

Pastikan Flutter SDK sudah terinstall.

Kemudian jalankan:

```bash
flutter pub get
```

### 3. Jalankan Backend

Backend membutuhkan:

- PHP
- MySQL
- Web server lokal

Untuk development lokal dapat menggunakan **Laragon** atau environment PHP/MySQL lainnya.

Pastikan API dapat diakses sebelum menjalankan frontend.

### 4. Jalankan Flutter Web

```bash
flutter run -d chrome
```

Flutter akan menjalankan website melalui browser Chrome.

## 🌍 Deployment

Frontend Flutter Web dapat dibuat menggunakan:

```bash
flutter build web
```

Hasil build akan tersedia pada:

```text
build/web/
```

Project dapat dideploy pada web server yang mendukung konfigurasi yang dibutuhkan oleh Flutter Web dan PHP API.

Backend PHP dan database MySQL perlu dikonfigurasi sesuai environment server yang digunakan.

## 🎯 Tujuan Pengembangan

Project ini dikembangkan untuk membuat sistem website sekolah yang tidak hanya menampilkan informasi secara statis, tetapi juga memungkinkan administrator mengelola konten website secara mandiri.

Pengembangan project mencakup:

- Perancangan UI website
- Responsive design
- Pengembangan frontend menggunakan Flutter Web
- Pengembangan Admin Dashboard
- Integrasi frontend dengan PHP API
- Pengelolaan database MySQL
- Sistem pengelolaan media
- Authentication administrator
- Monitoring aktivitas login
- Routing halaman
- Pengaturan website
- SEO dasar
- Maintenance mode
- Deployment website

## 👨‍💻 Developer

**Rizqi Wijaya**

D3 Teknologi Informasi  
Politeknik Negeri Malang PSDKU Lumajang

---

Built with 💙💙💙 using **Flutter**.