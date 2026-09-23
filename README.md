# 🏫 Flutter School Website CMS

Website sekolah dinamis yang dibangun menggunakan **Flutter Web**, **PHP**, dan **MySQL**.

Project ini dikembangkan untuk menyediakan website informasi sekolah sekaligus **Content Management System (CMS)** melalui Admin Dashboard. Berbagai konten pada website dapat dikelola secara dinamis tanpa harus mengubah source code frontend secara langsung.

---

## ✨ Fitur Utama

### 🌐 Website Publik

Website publik menyediakan berbagai informasi sekolah yang dapat diakses oleh pengunjung.

Fitur yang tersedia meliputi:

- Beranda dengan banner/slider dinamis
- Profil sekolah
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

---

### 🛠️ Admin Dashboard

Admin Dashboard berfungsi sebagai pusat pengelolaan konten website.

Administrator dapat mengelola berbagai bagian website tanpa perlu melakukan perubahan langsung pada source code Flutter.

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

---

## ⚙️ Pengaturan Website

Menu **Pengaturan Website** digunakan untuk mengatur berbagai konfigurasi website melalui Admin Dashboard.

Pengaturan meliputi:

- Identitas website
- Pengaturan tampilan website
- Pengaturan footer
- Pengaturan halaman login
- Pengaturan SEO
- Pengaturan status website
- Maintenance mode
- Pengaturan keamanan
- Informasi aktivitas administrator

Dengan sistem ini, berbagai konfigurasi website dapat dikelola tanpa harus melakukan perubahan langsung pada source code.

---

## 🔐 Keamanan & Monitoring Login

Sistem administrator dilengkapi dengan fitur pencatatan aktivitas login untuk membantu memantau akses ke Admin Dashboard.

Fitur monitoring meliputi:

- Riwayat aktivitas login administrator
- Pencatatan login berhasil
- Pencatatan percobaan login gagal
- Pencatatan alamat IP pada aktivitas login
- Informasi waktu aktivitas login
- Monitoring aktivitas akses administrator

Credential database production tidak ditulis langsung di dalam source code.

Konfigurasi backend mendukung penggunaan **environment variable**, sehingga informasi sensitif dapat dipisahkan dari repository.

---

## 🧰 Teknologi

| Teknologi | Penggunaan |
| --- | --- |
| Flutter / Dart | Frontend website dan Admin Dashboard |
| PHP | Backend dan API |
| MySQL | Database |
| HTML | Entry point dan konfigurasi Flutter Web |
| Apache / `.htaccess` | Routing dan konfigurasi deployment |
| LocalStorage | Penyimpanan data tertentu pada browser |
| cPanel | Deployment dan hosting website |
| Git & GitHub | Version control dan repository project |

---

## 🏗️ Arsitektur Sistem

Project menggunakan arsitektur frontend dan backend yang terpisah.

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

Flutter Web bertindak sebagai frontend untuk website publik sekaligus Admin Dashboard.

Frontend berkomunikasi dengan backend melalui HTTP request. Backend PHP kemudian menangani proses pengambilan, penyimpanan, dan perubahan data pada database MySQL.

---

## 📁 Struktur Project

Project dipisahkan berdasarkan fungsi frontend, backend, database, dan dokumentasi agar proses pengembangan serta pemeliharaan lebih terorganisir.

```text
website_smak/
│
├── api/                     # Backend PHP dan API
│   ├── config.php           # Konfigurasi koneksi database
│   ├── index.php            # Endpoint utama API
│   └── uploads/             # Penyimpanan media yang diunggah
│
├── assets/                  # Asset statis aplikasi
│
├── database/                # SQL dan migration database
│
├── docs/                    # Dokumentasi pendukung project
│
├── lib/                     # Source code utama Flutter
│   │
│   ├── admin/               # Seluruh halaman Admin Dashboard
│   │   ├── akademik/        # Pengelolaan konten akademik
│   │   ├── berita/          # Pengelolaan berita
│   │   ├── dashboard/       # Halaman utama administrator
│   │   ├── galeri/          # Pengelolaan galeri dan media
│   │   ├── kesiswaan/       # Pengelolaan konten kesiswaan
│   │   ├── kontak/          # Pengelolaan informasi kontak
│   │   ├── pengaturan_website/
│   │   │                    # Konfigurasi dan pengaturan website
│   │   ├── pengguna/        # Pengelolaan pengguna/admin
│   │   ├── ppdb/            # Pengelolaan informasi PPDB
│   │   ├── profil/          # Pengelolaan profil sekolah
│   │   └── shared/          # Komponen bersama Admin Dashboard
│   │
│   ├── landing_page/        # Halaman website publik
│   ├── routing/             # Navigasi dan konfigurasi URL
│   ├── services/            # Komunikasi frontend dengan API
│   └── main.dart            # Entry point aplikasi Flutter
│
├── test/                    # Automated testing Flutter
├── web/                     # Konfigurasi Flutter Web
├── android/                 # Konfigurasi platform Android
├── ios/                     # Konfigurasi platform iOS
├── linux/                   # Konfigurasi platform Linux
├── macos/                   # Konfigurasi platform macOS
├── windows/                 # Konfigurasi platform Windows
│
├── pubspec.yaml             # Dependency dan konfigurasi Flutter
└── README.md                # Dokumentasi repository
```

### Penjelasan Bagian Utama

#### `lib/` — Flutter Frontend

Berisi source code utama aplikasi Flutter.

Di dalamnya terdapat website publik yang digunakan oleh pengunjung dan Admin Dashboard yang digunakan administrator untuk mengelola website.

#### `lib/admin/` — Admin Dashboard

Berisi halaman dan fitur CMS untuk administrator.

Setiap modul dipisahkan berdasarkan jenis konten, seperti akademik, berita, galeri, kesiswaan, PPDB, profil, pengguna, kontak, hingga Pengaturan Website.

#### `lib/landing_page/` — Website Publik

Berisi halaman yang ditampilkan kepada pengunjung.

Konten halaman publik terintegrasi dengan backend sehingga perubahan yang dilakukan melalui Admin Dashboard dapat ditampilkan secara dinamis.

#### `lib/routing/` — Routing

Mengatur navigasi dan URL halaman pada Flutter Web sehingga halaman publik dapat menggunakan struktur URL yang lebih bersih.

#### `lib/services/` — API Services

Menangani komunikasi antara Flutter dengan backend PHP, termasuk proses mengambil, mengirim, dan memperbarui data.

#### `api/` — PHP Backend

Berfungsi sebagai penghubung antara Flutter Web dan database MySQL.

Backend menangani request dari frontend, autentikasi administrator, pengelolaan data, monitoring aktivitas login, serta proses upload media.

#### `database/` — Database & Migration

Berisi file SQL yang digunakan untuk membuat atau memperbarui struktur database selama proses pengembangan.

#### `assets/` — Assets

Berisi berbagai asset statis yang digunakan oleh aplikasi Flutter.

#### `web/` — Flutter Web Configuration

Berisi konfigurasi yang diperlukan untuk menjalankan dan melakukan build aplikasi sebagai website.

---

## 🔄 Pengelolaan Konten Dinamis

Salah satu fokus utama project ini adalah mengurangi konten yang bersifat **hardcoded** pada frontend.

Konten website dikelola menggunakan alur:

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

Administrator melakukan perubahan melalui Admin Dashboard.

Data kemudian dikirim ke backend PHP dan disimpan pada database MySQL. Website publik mengambil data tersebut melalui API dan menampilkannya kepada pengunjung.

Dengan pendekatan ini, administrator dapat memperbarui informasi website tanpa perlu membuka atau mengubah source code Flutter.

---

## 🖼️ Pengelolaan Media

Website mendukung penggunaan dan pengelolaan media untuk berbagai jenis konten.

Media digunakan pada:

- Banner dan slider beranda
- Profil sekolah
- Berita
- Galeri
- Prestasi
- Ekstrakurikuler
- Konten halaman lainnya

Media dapat diunggah melalui sistem pengelolaan konten dan kemudian digunakan oleh halaman website.

---

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

Routing juga digunakan untuk menangani navigasi antarhalaman di dalam Flutter Web.

---

## 🔧 Konfigurasi Database

Backend PHP menggunakan MySQL sebagai database.

Konfigurasi koneksi mendukung environment variable:

```text
SMAK_DB_HOST
SMAK_DB_USER
SMAK_DB_PASSWORD
SMAK_DB_NAME
SMAK_DB_PORT
```

Dengan pendekatan ini, credential database production tidak perlu disimpan secara langsung di dalam source code repository.

---

## 💻 Menjalankan Project

### 1. Clone Repository

```bash
git clone https://github.com/rizqiwijayaa/flutter-smak-website.git
```

Masuk ke folder project:

```bash
cd flutter-smak-website
```

### 2. Install Dependency

Pastikan Flutter SDK sudah tersedia.

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

Pastikan database telah dikonfigurasi dan backend API dapat diakses oleh aplikasi Flutter.

### 4. Jalankan Flutter Web

```bash
flutter run -d chrome
```

Aplikasi kemudian akan dijalankan melalui browser Chrome.

---

## 🌍 Deployment

Build production Flutter Web dapat dibuat menggunakan:

```bash
flutter build web
```

Hasil build akan tersedia pada:

```text
build/web/
```

File hasil build kemudian dapat dideploy ke web server.

Backend PHP dan database MySQL perlu dikonfigurasi sesuai dengan environment server yang digunakan.

Project ini menggunakan konfigurasi Apache melalui `.htaccess` untuk mendukung kebutuhan routing pada deployment web.

---

## 🔎 SEO & Website Configuration

Project menyediakan konfigurasi dasar untuk mendukung kebutuhan website publik, seperti:

- Website title
- Meta description
- Keywords
- Canonical URL
- Open Graph metadata
- Identitas website
- Favicon
- Pengaturan status website

Sebagian pengaturan website dapat dikelola melalui Admin Dashboard.

---

## 🎯 Tujuan Pengembangan

Project ini dikembangkan untuk membuat sistem website sekolah yang tidak hanya menampilkan informasi secara statis, tetapi juga memungkinkan administrator mengelola konten website secara mandiri.

Pengembangan project mencakup:

- Perancangan UI website
- Responsive design
- Pengembangan frontend menggunakan Flutter Web
- Pengembangan Admin Dashboard / CMS
- Integrasi frontend dengan PHP API
- Pengelolaan database MySQL
- Pengelolaan konten dinamis
- Sistem pengelolaan media
- Authentication administrator
- Monitoring aktivitas login
- Pencatatan login berhasil dan gagal
- Pencatatan alamat IP
- Routing halaman
- Pengaturan Website
- SEO dasar
- Maintenance mode
- Deployment website
- Version control menggunakan Git

---

## 👨‍💻 Developer

**Rizqi Wijaya**

D3 Teknologi Informasi  
Politeknik Negeri Malang PSDKU Lumajang

---

Built with 💙 using **Flutter**.