# Final Admin UI Action Audit — 11 September 2026

Verdict: **NOT PASS untuk final click-through**. Source telah diperiksa dan bug
yang dapat ditentukan dengan aman telah diperbaiki. Browser automation tidak
memiliki browser terhubung; klik UI, file picker, dan penyimpanan melalui UI
belum diuji pada source hasil patch. Tidak ada build, hosting, sync API, perubahan
DB, akun, atau data sekolah pada audit ini.

## Cakupan dan batas verifikasi

- 39 file Dart Admin dipindai. Terdapat 528 binding handler tekstual (termasuk
  helper, penggunaan ulang, dan blok legacy; bukan 528 tombol unik).
- Sidebar dan pemilihan halaman ditelusuri sampai widget modul. Save/delete/upload
  ditelusuri sampai service; editor yang menyimpan draft dibedakan dari editor
  yang langsung memanggil API.
- `MANUAL TEST` berarti wiring source telah ditelusuri, namun klik runtime belum
  terverifikasi. Fix source yang lolos analyzer tidak otomatis menjadi PASS UI.
- Preview menampilkan konten publik yang sudah tersimpan, bukan draft yang belum
  disimpan. Dialog Preview memiliki navigator tersendiri dan tombol tutup agar
  navigasi publik tidak membuang state editor Admin.

## Checklist seluruh menu

| Menu/modul | Action yang ditelusuri | Status akhir |
| --- | --- | --- |
| Navigasi global desktop/mobile | Sidebar, expand submenu, drawer, overlay penutup, logout | MANUAL TEST |
| Dashboard | Quick-action cards, Lihat semua aktivitas menuju tab keamanan | MANUAL TEST — fix source |
| Beranda Website / alias Web Editor | Sembilan bagian: banner/hero, highlight, tentang, program, PPDB, kehidupan, statistik, kontak, testimoni; CRUD dialog, upload, hapus/ganti banner, Preview | MANUAL TEST — fix Preview |
| Profil → Identitas Sekolah | Tambah saat kosong, edit, hapus dengan konfirmasi, simpan, batal, retry | MANUAL TEST |
| Profil → Sambutan Kepala Sekolah | Simpan konten, daftar, gambar/upload/clear, dialog batal/tutup, Preview | MANUAL TEST — fix Preview |
| Profil → Sejarah Sekolah | Simpan utama; CRUD timeline, era, galeri; upload, refresh, batal | MANUAL TEST |
| Profil → Visi & Misi | Draft item tambah/edit/hapus, Simpan utama+item, upload, Preview | MANUAL TEST — fix Preview |
| Profil → Struktur Organisasi | Simpan utama, CRUD bagan/pimpinan/guru/pegawai, filter, foto, konfirmasi hapus | MANUAL TEST |
| Profil → Sarana & Prasarana | Simpan utama/bagian, CRUD fasilitas, kategori, upload/clear, konfirmasi hapus | MANUAL TEST |
| Akademik → Prestasi Akademik | Simpan setting, CRUD prestasi/bidang/pembinaan, unggulan, upload/clear, Preview | MANUAL TEST — fix Preview |
| Akademik → Kurikulum | Draft daftar dan mapel, tambah/edit/hapus, upload/clear, Simpan seluruh tabel, Preview | MANUAL TEST — fix serialisasi + Preview |
| Akademik → Kalender Akademik | Draft agenda, menu edit/hapus, kategori, Simpan, upload PDF/banner, buka/clear file, Preview | MANUAL TEST — fix Preview |
| Akademik → Jadwal Pelajaran | Filter tahun/tingkat/kelas/semester/hari, CRUD baris, switch istirahat, Simpan setting, PDF/banner, Preview | MANUAL TEST — fix Preview |
| Kesiswaan → Tata Tertib | Draft kategori/poin/pembinaan, tambah/edit/hapus, Simpan, PDF/banner, Preview | MANUAL TEST — fix Preview |
| Kesiswaan → OSIS | Draft pengurus/bidang/program/agenda/dokumentasi/poin, Simpan, upload, Preview | MANUAL TEST — fix ID/data + Preview |
| Kesiswaan → Prestasi Siswa | Draft prestasi/unggulan/bidang/pembinaan/perjalanan/dokumentasi, Simpan, upload, Preview | MANUAL TEST — fix Preview |
| Kesiswaan → Ekstrakurikuler | Draft kegiatan/poin/pembinaan/galeri/FAQ, Simpan, upload, CTA kontak, Preview | MANUAL TEST — fix CTA + Preview |
| Berita | Tambah berita/pengumuman, edit/hapus, gambar/tanggal/status/kategori, pencarian/filter, refresh | MANUAL TEST |
| Galeri | Upload kegiatan multi-foto, edit/hapus, kategori, search/filter/sort, grid/list, pagination, Preview foto, tutup/next/previous | MANUAL TEST — fix header mobile |
| PPDB | Draft konten/daftar, tambah/edit/hapus, upload gambar/dokumen, buka/clear file, Simpan, refresh | MANUAL TEST |
| Kontak | Edit field, Simpan ke API, refresh | MANUAL TEST |
| Pengguna | Tambah/edit Admin, validasi password dan ID, foto, refresh/search/filter, menu ⋮ hapus; ID 1 dilindungi | MANUAL TEST |
| Pengaturan → Identitas | Field, logo/favicon, Simpan atas/bawah/tab, Batal/reload | MANUAL TEST — fix notifikasi sukses palsu |
| Pengaturan → Tampilan | Warna/preset, fallback image, Simpan/Batal | MANUAL TEST |
| Pengaturan → Login | Konten, upload/hapus hero, Simpan/Batal | MANUAL TEST |
| Pengaturan → Footer | Seluruh field diteruskan ke parent, Simpan/Batal | MANUAL TEST |
| Pengaturan → SEO Dasar | Field/preview, Simpan/Batal | MANUAL TEST |
| Pengaturan → Status Website | Toggle aktif/maintenance, pesan, autosave 650 ms, Lihat Website | MANUAL TEST — fix Lihat Website |
| Pengaturan → Keamanan & Aktivitas | Refresh/periksa sekarang, filter aktivitas, muat riwayat berikutnya, revoke sesi, tinjau alert | MANUAL TEST |
| Bantuan → Hubungi Developer | Callback kosong; tidak ada tujuan kontak developer dalam source | BLOCKER — NEEDS MANUAL REVIEW |

## Masalah dan patch

Semua path berikut relatif terhadap `lib/admin/`.

| File | Action / penyebab | Perubahan | Verifikasi |
| --- | --- | --- | --- |
| `admin_dashboard_page.dart` | Preview sebelumnya tidak memiliki alur yang valid untuk kembali ke editor; shortcut aktivitas perlu tujuan tab | Helper Preview berisi halaman existing dan navigator terisolasi; tab awal pengaturan dapat dipilih oleh shortcut | Analyzer, pemetaan source; klik/tutup manual |
| `dashboard/dashboard_page.dart` | Lihat semua aktivitas callback kosong | Teruskan callback ke Pengaturan → Keamanan & Aktivitas, desktop dan mobile | Trace callback sampai `initialTab`; manual klik |
| `dashboard/beranda_website_page.dart` | Preview membuka `/`, dapat masuk kembali ke Admin melalui session gate | Buka LandingPage dalam Preview | Analyzer; manual klik |
| `profil/sambutan_kepala_sekolah_page.dart` | Preview membuka `/`, bukan Sambutan | Buka halaman Sambutan existing | Analyzer dan key peta halaman; manual klik |
| `profil/visi_misi_page.dart` | Preview callback kosong | Buka Visi & Misi existing | Analyzer dan peta halaman; manual klik |
| `akademik/prestasi_akademik_page.dart` | Preview menuju `/prestasi-akademik` tanpa named route yang terdaftar | Buka widget Prestasi Akademik existing | Analyzer dan peta halaman; manual klik |
| `akademik/kurikulum_page.dart` | Preview kosong; tambah item memasukkan IconData yang tidak JSON-serializable, sementara save sudah mulai delete baris lama | Preview terhubung; serialisasi seluruh draft sebelum mutasi, IconData menjadi nilai numerik JSON | Empat assertion metode source/API tiruan PASS; manual Simpan |
| `akademik/kalender_akademik_page.dart` | Preview hanya Snackbar | Buka Kalender existing | Analyzer dan peta halaman; manual klik |
| `akademik/jadwal_pelajaran_page.dart` | Preview hanya Snackbar | Buka Jadwal existing | Analyzer dan peta halaman; manual klik |
| `kesiswaan/tata_tertib_page.dart` | Preview kosong | Buka Tata Tertib existing | Analyzer dan peta halaman; manual klik |
| `kesiswaan/osis_page.dart` | Preview kosong; ID posisi dapat berbenturan dengan ID eksplisit setelah delete+add; edit membuang ID/gambar; save mengosongkan gambar program selain pertama | Preview terhubung; hindari penggunaan ID ganda; pertahankan field existing saat edit dan gambar program berikutnya | Empat assertion metode source/API tiruan PASS; trace field; manual CRUD |
| `kesiswaan/prestasi_siswa_page.dart` | Preview kosong | Buka Prestasi Siswa existing | Analyzer dan peta halaman; manual klik |
| `kesiswaan/ekstrakurikuler_page.dart` | Preview dan CTA kontak kosong | Preview terhubung; CTA membuka field link yang sudah ada setelah validasi HTTP/HTTPS | Analyzer; manual CTA tanpa mengirim pesan |
| `galeri/galeri_page.dart` | Header memakai Expanded di Flex vertikal dalam scroll pada lebar <650, berpotensi render exception sebelum tombol bisa dipakai | Expanded hanya untuk desktop; isi, ukuran teks, warna, spacing, dan susunan mobile dipertahankan | Analyzer dan constraint trace; manual mobile |
| `pengaturan_website/pengaturan_website_page.dart` | Lihat Website memakai origin root; shortcut aktivitas selalu masuk tab Identitas | Gunakan Preview LandingPage; terima `initialTab` | Analyzer dan trace; manual klik |
| `pengaturan_website/identitas_tab.dart` | Child selalu menampilkan sukses setelah parent menangkap kegagalan API | Hilangkan notifikasi sukses ganda; parent melaporkan hasil API sebenarnya | Analyzer dan trace jalur error; manual save/error |

## Temuan yang tidak diubah

- `shared/admin_sidebar.dart:123`: Hubungi Developer tidak mempunyai alamat
  tujuan yang dapat dipastikan. Tidak diarahkan ke nomor sekolah secara tebakan.
  Memerlukan keputusan pemilik proyek sebelum bisa dinyatakan berfungsi.
- `dashboard/beranda_website_page.dart`: tombol Simpan Perubahan atas hanya
  menjelaskan bahwa tiap bagian disimpan melalui editor. Halaman tidak memiliki
  draft global yang belum tersimpan; dialog bagian memang memanggil API. Bukan
  kehilangan wiring save data, tetapi label tombol perlu penilaian manual bila
  pemilik mengharapkan fungsi global. Tidak dibuat sistem save baru.
- `galeri/galeri_page.dart`: callback kosong pada nomor pagination yang sedang
  aktif memang tidak perlu memindahkan halaman. Nomor lain/prev/next terhubung.
- Tombol saat saving/uploading/loading, hapus gambar kosong, batas pagination,
  Lihat Website saat offline/maintenance, serta Hapus Administrator ID 1 memang
  disabled berdasarkan state; tidak diaktifkan paksa.
- `profil/profil_identitas_page.dart`: kartu dokumen hardcoded dan tombol Lihat
  kosong berada pada `AdminIdentitasSekolahPage` lama yang tidak dipakai router
  Admin aktif. Halaman aktif adalah `AdminIdentitasSekolahCrudPage`. Tidak
  mengarang file tujuan dan tidak menghapus source legacy pada audit ini.
- `web_editor/web_editor_page.dart` adalah class lama yang tidak dipakai oleh
  menu Web Editor aktif; alias tersebut menuju AdminBerandaWebsitePage.
- CRUD struktur lama yang terlihat hanya mengubah list berada dalam komentar.
  Handler runtime memakai API dan reload; tidak perlu mengganti helper runtime.
- Beberapa editor batch (termasuk Kurikulum/Kalender) menyimpan melalui beberapa
  request. Tidak ada jaminan transaksi menyeluruh saat jaringan gagal di tengah
  proses. Audit ini memperbaiki error serialisasi deterministik, tidak mengubah
  arsitektur API menjadi transaksi batch.

## Hasil pemeriksaan

| Pemeriksaan | Hasil |
| --- | --- |
| `flutter analyze --no-pub`, sebelum dan sesudah | 0 error, 112 warning, 251 info; set diagnosis sama setelah normalisasi nomor baris |
| Analyzer bersih dari seluruh lint | Belum; 363 diagnosis existing tetap ada. Bukan PASS lint-clean |
| Kurikulum: payload IconData biasa/nested dapat diserialisasi | PASS, metode source dieksekusi dengan API tiruan |
| Kurikulum: tipe unsupported di draft tidak memicu delete/save | PASS, API tiruan |
| OSIS: delete+add tidak overwrite record retained | PASS, API tiruan |
| OSIS: singleton update dan reorder ID tetap benar | PASS, API tiruan |
| Total assertion alur source dengan API tiruan | 8 PASS; bukan klik browser atau tes DB |
| Runtime GET galeri anonymous | HTTP 200 |
| Runtime GET users anonymous | HTTP 401 |
| Runtime GET admin_sessions anonymous | HTTP 401 |
| API workspace dan Laragon | Hash kedua file sama; tidak diedit/disinkronkan oleh task ini |
| Bearer / Remember Me / same-origin | Implementasi service dan storage dipertahankan; tidak mengubah configuration URL |
| Login, GET Admin 200, CRUD via UI, upload picker | Tidak diuji ulang pada task ini; membutuhkan browser |
| Data/file test pada server | Tidak dibuat; tidak ada cleanup DB/upload yang diperlukan |

## Manual click-through tersisa

Jalankan source terbaru melalui development command pada `api/README.md` (gunakan
override SMAK_API_URL jika Flutter dan Laragon berada di server terpisah), bukan
bundle lama. Tidak perlu production build.

1. Satu putaran semua menu/submenu dan tujuh tab Pengaturan sesuai tabel.
   Buka semua Preview yang tersedia, tutup kembali, pastikan draft editor tetap;
   klik shortcut aktivitas. Uji drawer dan tombol Galeri pada lebar mobile.
2. Uji action kritis dengan item temporary, tanpa menyentuh akun ID 1 atau
   menghapus data sekolah: tambah/edit/simpan/reload/hapus pada tiap editor yang
   memiliki handler sendiri. Prioritaskan Kurikulum (tambah item berikon) dan
   OSIS (hapus item test lalu tambah item test dalam satu draft; record lain
   tetap). Editor draft harus diakhiri Simpan halaman.
3. Uji picker gambar/PDF serta multi-upload Galeri, clear/batal, preview file,
   filter/dropdown/toggle/pagination yang tersedia. Hapus record dan file test
   setelah pengujian. Revoke hanya sesi test sendiri; jangan mencabut sesi user
   lain atau menandai alert asli sebagai test. Toggle Status Website yang
   mengubah situs publik perlu waktu uji yang disepakati, lalu pulihkan nilainya.
4. Login/Remember Me, protected data, menu ⋮ Pengguna, dan logout pada browser.
   Tentukan kontak developer yang benar. Review apakah tombol Simpan global
   Beranda yang informatif sudah sesuai maksud produk.

Source fixes sudah selesai; final UI smoke test tetap **NOT PASS** sampai
verifikasi manual tersebut selesai dan tujuan tombol bantuan ditentukan.
