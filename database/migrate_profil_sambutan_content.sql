-- Memindahkan isi awal halaman publik Sambutan Kepala Sekolah ke MySQL.
-- Aman dijalankan berulang kali; hanya memperbarui record profil_sambutan id 1.
UPDATE profil_sambutan
SET
  subtitle = 'Pesan dan harapan untuk seluruh keluarga besar SMAK.',
  nama_kepala = 'Drs. Andreas Prasetyo',
  jabatan = 'Kepala SMAK Mgr. Soegijapranata',
  masa_jabatan = 'Masa Jabatan 2023-Sekarang',
  telepon = '(024) 831-6521',
  email = 'kepsek@smaksoegijapranata.sch.id',
  alamat = 'Jl. Poyudan Luhur IV/1, Semarang, Jawa Tengah',
  sosial_json = '{"facebook":"https://facebook.com/smaksoegijapranata","instagram":"https://instagram.com/smaksoegija","youtube":"https://youtube.com/@smaksoegijapranata","tiktok":"https://tiktok.com/@smaksoegija"}',
  kutipan = 'Tuhan adalah sumber hikmat, dari-Nya datang terang yang menerangi jalan hidup kita.',
  sumber_kutipan = 'Amsal 2:6',
  isi = 'Salam sejahtera bagi kita semua.\n\nPuji syukur kita haturkan ke hadirat Tuhan Yang Maha Esa atas segala berkat dan penyertaan-Nya, sehingga kita semua dapat berkarya dan melayani di dalam komunitas pendidikan SMAK Mgr. Soegijapranata yang kita cintai.\n\nSebagai Kepala Sekolah, saya merasa terhormat dan bersyukur dapat memimpin sekolah ini bersama Bapak/Ibu Guru, Tenaga Kependidikan, Peserta Didik, dan seluruh orang tua dalam semangat pelayanan dan kasih.\n\nSMAK Mgr. Soegijapranata bukan hanya tempat belajar, tetapi juga rumah untuk bertumbuh dalam iman, ilmu, karakter, dan kepedulian terhadap sesama. Kita berkomitmen untuk menghadirkan pendidikan berkualitas yang utuh, seimbang, dan berorientasi pada masa depan.\n\nMari kita terus berjalan bersama, saling mendukung, dan berkolaborasi untuk mewujudkan sekolah yang unggul, berkarakter, dan berjiwa pelayanan.\n\nTuhan memberkati langkah dan karya kita semua.\n\nSalam kasih,',
  pesan = 'Percayalah pada proses, hiduplah dalam disiplin, dan belajarlah untuk mengasihi. Tuhan kunci menjadi pribadi yang utuh dan bermakna.',
  motto = 'Veritas in Caritate (Kebenaran dalam Kasih)',
  komitmen_json = '["Pendidikan Berkualitas","Pembentukan Karakter","Pengembangan Potensi","Pelayanan Penuh Kasih"]',
  harapan_json = '["Prestasi yang Bertumbuh","Karakter yang Kuat","Kolaborasi yang Harmonis"]',
  program_prioritas_json = '[{"title":"Penguatan Akademik","text":"Meningkatkan kualitas pembelajaran dan asesmen untuk hasil belajar yang optimal dan relevan."},{"title":"Digitalisasi Pembelajaran","text":"Memanfaatkan teknologi untuk proses belajar yang efektif, kreatif, dan berdaya saing."},{"title":"Sekolah Ramah Anak","text":"Mewujudkan lingkungan sekolah yang aman, nyaman, inklusif, dan mendukung perkembangan anak."},{"title":"Pengembangan Talenta","text":"Mendukung pengembangan minat dan bakat siswa melalui berbagai program dan layanan."},{"title":"Budaya Literasi","text":"Menumbuhkan budaya membaca, menulis, dan berpikir kritis dalam kehidupan sehari-hari."},{"title":"Kemitraan & Alumni","text":"Memperkuat jaringan kemitraan dan peran alumni untuk kemajuan sekolah dan siswa."}]',
  kegiatan_kepala_json = '["Pendampingan Siswa","Rapat Bersama Guru","Kunjungan Orang Tua","Pelayanan Masyarakat"]',
  penutup = 'Akhir kata, saya mengajak seluruh keluarga besar SMAK Mgr. Soegijapranata untuk terus melangkah maju dengan semangat pelayanan, keterbukaan, dan kerja sama.\n\nSemoga Tuhan senantiasa menuntun, memberkati, dan menyertai setiap langkah kita dalam mewujudkan pendidikan yang utuh dan bermakna.\n\nTerima kasih atas kepercayaan dan dukungan yang telah diberikan.\n\nSalam kasih,',
  status = 'aktif'
WHERE id = 1;
