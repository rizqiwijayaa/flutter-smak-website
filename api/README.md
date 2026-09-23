# API SMAK

## URL frontend dan API

Default Flutter adalah `api/index.php`, relatif terhadap `<base href>` halaman.
Letakkan folder `api/` sejajar dengan `index.html` hasil build. Untuk hosting dalam
subdirektori, base href Flutter harus menunjuk subdirektori tersebut dan diakhiri `/`.
Tidak perlu menetapkan domain pada source untuk hosting same-origin.

Endpoint alternatif dapat ditentukan saat menjalankan/compile Flutter melalui
`--dart-define=SMAK_API_URL=...` (URL relatif atau URL absolut endpoint PHP tanpa query).
Untuk development Flutter dengan server terpisah dari Laragon:

```sh
flutter run -d chrome --dart-define=SMAK_API_URL=http://127.0.0.1/website_smak/api/index.php
```

Perubahan dart-define membutuhkan restart `flutter run`, bukan hanya reload browser.
Untuk production same-origin, jangan sertakan override development tersebut.
URL file menggunakan endpoint API yang sama dan parameter `file` yang di-encode;
tautan gambar HTTP/HTTPS eksternal tetap dipertahankan.

## Database server

`config.php` membaca environment PHP berikut, dengan default development existing:

| Variabel | Default |
| --- | --- |
| `SMAK_DB_HOST` | `127.0.0.1` |
| `SMAK_DB_PORT` | `3306` |
| `SMAK_DB_NAME` | `web_smak` |
| `SMAK_DB_USER` | `root` |
| `SMAK_DB_PASSWORD` | kosong |

Host ini adalah koneksi PHP ke MySQL, bukan alamat yang diakses browser.
Atur environment sesuai database hosting sebenarnya; file `.env` tidak otomatis
dibaca. Jangan memasukkan credential database ke dart-define atau aset frontend.
Request normal tidak melakukan CREATE/ALTER/seed otomatis.

## Auth, CORS, dan berkas hosting

Protected GET dan `security_dashboard` menggunakan Authorization Bearer.
CORS menerima `Content-Type, Authorization` dan tidak memiliki origin development
hardcoded. Jika API dipisah origin, tetapkan kebijakan CORS berdasarkan origin
hosting sebenarnya pada tahap konfigurasi hosting.

Sertakan seluruh `api/uploads/` dari runtime aktif saat menyiapkan hosting;
folder uploads workspace bukan salinan lengkap storage aktif. Jangan mengunggah
seluruh repository, profil browser `.dart_tool`, atau konfigurasi IDE ke webroot.
Gunakan output build baru pada tahap build yang terpisah.
