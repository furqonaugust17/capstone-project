# 📖 User Manual — AniDraw

> **Aplikasi:** AniDraw — Educational Animal Drawing Game  
> **Platform:** Android  
> **Versi Dokumen:** 1.0  
> **Terakhir Diperbarui:** 26 Juni 2026

---

## Daftar Isi

1. [Pendahuluan](#1-pendahuluan)
2. [Persyaratan Sistem](#2-persyaratan-sistem)
3. [Instalasi Aplikasi](#3-instalasi-aplikasi)
4. [Memulai Aplikasi](#4-memulai-aplikasi)
   - 4.1 [Splash Screen](#41-splash-screen)
   - 4.2 [Registrasi Akun Baru](#42-registrasi-akun-baru)
   - 4.3 [Login / Masuk](#43-login--masuk)
5. [Halaman Utama (Home)](#5-halaman-utama-home)
6. [Alur Bermain Game](#6-alur-bermain-game)
   - 6.1 [Memilih Hewan](#61-memilih-hewan)
   - 6.2 [Memilih Mode Menggambar](#62-memilih-mode-menggambar)
   - 6.3 [Menggambar di Kanvas](#63-menggambar-di-kanvas)
   - 6.4 [Melihat Hasil](#64-melihat-hasil)
7. [Fitur Tambahan](#7-fitur-tambahan)
   - 7.1 [Galeri / Riwayat Permainan](#71-galeri--riwayat-permainan)
   - 7.2 [Papan Peringkat (Leaderboard)](#72-papan-peringkat-leaderboard)
   - 7.3 [Toko (Shop)](#73-toko-shop)
   - 7.4 [Inventori](#74-inventori)
   - 7.5 [Statistik](#75-statistik)
8. [Sistem Skor](#8-sistem-skor)
9. [Tips Menggambar agar Skor Tinggi](#9-tips-menggambar-agar-skor-tinggi)
10. [Tanya Jawab (FAQ)](#10-tanya-jawab-faq)
11. [Pemecahan Masalah (Troubleshooting)](#11-pemecahan-masalah-troubleshooting)

---

## 1. Pendahuluan

**AniDraw** adalah aplikasi game edukasi menggambar hewan yang dirancang khusus untuk anak-anak usia dini. Aplikasi ini mengajarkan anak-anak cara menggambar hewan melalui dua mode yang menyenangkan, kemudian menggunakan teknologi **kecerdasan buatan (AI)** untuk mengenali dan menilai gambar yang dibuat.

### Tujuan Aplikasi

- 🎨 Melatih kreativitas dan kemampuan motorik halus anak melalui menggambar
- 🧠 Mengenalkan berbagai bentuk hewan kepada anak
- 🤖 Memberikan umpan balik otomatis menggunakan klasifikasi gambar berbasis AI
- 🏆 Memotivasi anak dengan sistem skor dan peringkat

### Fitur Utama

| Fitur | Deskripsi |
|---|---|
| Menggambar Hewan | Kanvas digital interaktif untuk menggambar |
| Mode Tebalkan | Menebalkan pola gambar hewan yang sudah disediakan |
| Mode Gambar Bebas | Menggambar hewan secara bebas tanpa panduan |
| Klasifikasi AI | Pengenalan gambar otomatis menggunakan teknologi CNN |
| Sistem Skor | Penilaian kemiripan gambar dengan hewan yang dipilih |
| Galeri Riwayat | Melihat kembali riwayat gambar dan skor sebelumnya |
| Papan Peringkat | Membandingkan skor dengan pengguna lain |
| Toko & Inventori | Membeli dan mengelola item dalam game |

---

## 2. Persyaratan Sistem

| Komponen | Persyaratan Minimum |
|---|---|
| Sistem Operasi | Android 5.0 (Lollipop) atau lebih baru |
| RAM | Minimal 2 GB |
| Penyimpanan | Minimal 100 MB ruang kosong |
| Orientasi Layar | Landscape (wajib) |
| Koneksi Internet | Diperlukan untuk login, registrasi, leaderboard, dan toko. Proses klasifikasi gambar berjalan **sepenuhnya offline**. |

> **Catatan:** Aplikasi berjalan secara optimal pada perangkat Android kelas menengah ke atas. Orientasi layar akan otomatis terkunci ke mode **landscape** saat aplikasi dibuka.

---

## 3. Instalasi Aplikasi

1. Dapatkan file instalasi aplikasi (file `.apk`) dari sumber yang disediakan.
2. Buka **File Manager** di perangkat Android Anda.
3. Navigasi ke lokasi file `.apk` yang telah diunduh.
4. Ketuk file `.apk` tersebut untuk memulai instalasi.
5. Jika diminta, aktifkan izin **"Instal dari sumber tidak dikenal"** di pengaturan perangkat.
6. Tunggu proses instalasi selesai.
7. Ketuk **"Buka"** untuk menjalankan aplikasi.

> **Catatan:** Pastikan perangkat memiliki ruang penyimpanan yang cukup sebelum melakukan instalasi.

---

## 4. Memulai Aplikasi

### 4.1 Splash Screen

Saat pertama kali membuka aplikasi, Anda akan melihat **Splash Screen** yang menampilkan logo AniDraw beserta indikator loading. Pada tahap ini, aplikasi sedang:

- Memuat model AI untuk klasifikasi gambar
- Memeriksa status login pengguna
- Menyiapkan komponen-komponen yang diperlukan

Setelah proses inisialisasi selesai:
- Jika Anda **sudah login** sebelumnya → langsung diarahkan ke **Halaman Utama**
- Jika Anda **belum login** → diarahkan ke **Halaman Login**

Jika terjadi kesalahan saat inisialisasi, akan muncul pesan error dan tombol **"Coba Lagi"** untuk mengulang proses.

---

### 4.2 Registrasi Akun Baru

Jika Anda belum memiliki akun, ikuti langkah berikut:

1. Pada halaman Login, ketuk tautan **"Belum punya akun? Daftar di sini"** di bagian bawah.
2. Anda akan diarahkan ke halaman **Registrasi**.
3. Isi formulir pendaftaran:
   - **Email** — Masukkan alamat email yang valid (format: `nama@domain.com`)
   - **Kata Sandi** — Masukkan kata sandi minimal **6 karakter**
4. Ketuk tombol **"DAFTAR"** untuk membuat akun.
5. Jika berhasil, Anda akan otomatis masuk dan diarahkan ke **Halaman Utama**.

> **Tips:** Gunakan email yang mudah diingat dan kata sandi yang aman agar akun terlindungi.

---

### 4.3 Login / Masuk

Jika Anda sudah memiliki akun:

1. Pada halaman Login, masukkan **Email** dan **Kata Sandi** yang telah terdaftar.
2. Ketuk tombol **"MASUK"**.
3. Jika data benar, Anda akan langsung diarahkan ke **Halaman Utama**.
4. Jika terjadi kesalahan (email/password salah), akan muncul notifikasi error di bagian bawah layar.

---

## 5. Halaman Utama (Home)

Halaman Utama adalah pusat navigasi utama aplikasi. Dari halaman ini Anda dapat mengakses semua fitur yang tersedia.

### Elemen di Halaman Utama

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│    [Profil]            ANIDRAW                          │
│                  "Ayo belajar menggambar                │
│                   hewan lucu dengan cara                │
│                   yang menyenangkan!"                   │
│                                                         │
│                   [ ▶ MULAI BERMAIN ]                   │
│                                                         │
│              [Galeri]  [Peringkat]  [Toko]              │
│                                                         │
│    [Profil]                   [Inventori]  [Toko]       │
└─────────────────────────────────────────────────────────┘
```

| Elemen | Fungsi |
|---|---|
| **MULAI BERMAIN** | Memulai permainan menggambar (navigasi ke pilihan hewan) |
| **Galeri** | Melihat riwayat gambar dan skor sebelumnya |
| **Peringkat** | Melihat papan peringkat pemain |
| **Toko** | Mengakses toko untuk membeli item |
| **Inventori** | Melihat item yang sudah dimiliki |
| **Profil** | Menampilkan informasi profil pengguna |

---

## 6. Alur Bermain Game

Berikut adalah alur lengkap bermain game AniDraw dari awal hingga selesai:

```
┌──────────┐     ┌───────────────┐     ┌──────────────┐     ┌──────────────┐     ┌────────┐
│   Home   │────►│ Pilih Hewan   │────►│ Pilih Mode   │────►│  Menggambar  │────►│ Hasil  │
│          │     │   (Choose)    │     │   (Mode)     │     │  (Drawing)   │     │(Result)│
└──────────┘     └───────────────┘     └──────────────┘     └──────────────┘     └────────┘
                                                                                     │
                                                               ┌─────────────────────┘
                                                               ▼
                                                     [Kembali ke Home]
                                                           atau
                                                     [Bermain Lagi]
```

---

### 6.1 Memilih Hewan

Setelah menekan tombol **"MULAI BERMAIN"** di halaman utama, Anda akan diarahkan ke halaman **Pilih Hewan**.

#### Hewan yang Tersedia

Aplikasi menyediakan **5 pilihan hewan** yang dapat digambar:

| No | Hewan | Ikon |
|---|---|---|
| 1 | 🐱 **Kucing** | pets |
| 2 | 🐄 **Sapi** | grass |
| 3 | 🦆 **Bebek** | water |
| 4 | 🐟 **Ikan** | set_meal |
| 5 | 🐬 **Lumba-Lumba** | pool |

#### Cara Memilih Hewan:
1. Perhatikan semua pilihan hewan yang ditampilkan di layar.
2. **Ketuk** pada ikon atau nama hewan yang ingin Anda gambar.
3. Anda akan otomatis diarahkan ke halaman **Pilih Mode**.

> **Catatan:** Anda **wajib** memilih hewan terlebih dahulu sebelum dapat menggambar. Tidak dapat langsung melompat ke halaman menggambar.

---

### 6.2 Memilih Mode Menggambar

Setelah memilih hewan, Anda akan diminta untuk memilih **mode menggambar**. Tersedia dua mode:

#### Mode 1: Ayo Tebalkan! (Thicken)

- **Deskripsi:** Muncul gambar contoh hewan sebagai panduan transparan di belakang kanvas.
- **Cara bermain:** Tebalkan garis-garis panduan dengan mengikuti pola yang ditampilkan.
- **Cocok untuk:** Anak-anak yang baru belajar menggambar atau memerlukan panduan visual.
- **Tingkat kesulitan:** ⭐ Mudah
- **Keunggulan:** Membantu anak memahami bentuk dasar hewan dengan menebalkan pola.

#### Mode 2: Gambar Sendiri! (Free Draw)

- **Deskripsi:** Kanvas sepenuhnya kosong tanpa panduan visual apapun.
- **Cara bermain:** Gambar hewan yang dipilih secara bebas berdasarkan imajinasi Anda.
- **Cocok untuk:** Anak-anak yang sudah percaya diri dan ingin mengeksplorasi kreativitas.
- **Tingkat kesulitan:** ⭐⭐ Sedang
- **Keunggulan:** Melatih daya ingat dan kreativitas anak.

#### Cara Memilih Mode:
1. Ketuk salah satu dari dua pilihan mode yang tersedia.
2. Anda akan langsung diarahkan ke **halaman menggambar**.

---

### 6.3 Menggambar di Kanvas

Halaman menggambar adalah inti dari pengalaman bermain AniDraw. Di sini Anda akan menggambar hewan yang telah dipilih.

#### Tampilan Halaman Menggambar

```
┌─────────────────────────────────────────────────────────┐
│  [← Kembali]  Ayo Gambar [Nama Hewan]!     [CONTOH]   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│                                                         │
│               ┌─────────────────────────┐               │
│               │                         │               │
│               │    Area Kanvas          │               │
│               │    (Menggambar di sini) │               │
│               │                         │               │
│               └─────────────────────────┘               │
│                                                         │
│  [🖊 Pen] [🧹 Eraser] [↩ Undo] [🗑 Clear]    [SELESAI]│
└─────────────────────────────────────────────────────────┘
```

#### Alat yang Tersedia

| Alat | Ikon | Fungsi |
|---|---|---|
| **Pen (Pena)** | 🖊 | Alat menggambar utama. Warna default: hitam, ukuran: 6.0 px |
| **Eraser (Penghapus)** | 🧹 | Menghapus bagian gambar yang sudah dibuat |
| **Undo (Batalkan)** | ↩ | Membatalkan satu goresan terakhir |
| **Clear (Hapus Semua)** | 🗑 | Menghapus semua gambar di kanvas sekaligus |
| **Contoh** | 💡 | Menampilkan dialog contoh gambar hewan sebagai referensi |
| **Selesai (Finish)** | ✅ | Mengirim gambar untuk diklasifikasi oleh AI |

#### Cara Menggambar:

1. **Mulai menggambar** — Sentuh dan geser jari Anda di atas kanvas untuk membuat goresan.
2. **Garis halus** — Aplikasi menggunakan kurva Bezier kuadratik sehingga garis yang dihasilkan akan terlihat halus dan natural.
3. **Gunakan Eraser** jika ada bagian yang ingin dihapus — ketuk ikon penghapus, lalu sentuh area yang ingin dihapus.
4. **Gunakan Undo** untuk membatalkan satu goresan terakhir.
5. **Gunakan Clear** untuk menghapus seluruh gambar dan memulai dari awal.
6. **Lihat Contoh** — Ketuk tombol **CONTOH** di kanan atas untuk melihat referensi gambar hewan.

> **Penting untuk Mode Ayo Tebalkan:**  
> Pada mode ini, gambar panduan transparan akan muncul di belakang kanvas. Ikuti pola tersebut dan tebalkan garis-garisnya. Transparansi panduan akan menyesuaikan secara otomatis — jika Anda tidak aktif menggambar untuk beberapa saat, panduan akan menjadi lebih terlihat untuk membantu Anda.

#### Mengirim Gambar:

1. Setelah selesai menggambar, ketuk tombol **SELESAI** di pojok kanan bawah.
2. Akan muncul notifikasi **"Classifying your drawing..."** yang menandakan proses klasifikasi sedang berjalan.
3. Tunggu beberapa detik hingga AI selesai menganalisis gambar Anda.
4. Anda akan otomatis diarahkan ke halaman **Hasil**.

> ⚠️ **Perhatian:** Jika Anda menekan tombol **SELESAI** tanpa menggambar apapun (kanvas kosong), akan muncul pesan **"Nothing to classify yet"** dan Anda tidak akan diarahkan ke halaman hasil.

---

### 6.4 Melihat Hasil

Setelah proses klasifikasi selesai, Anda akan diarahkan ke halaman **Hasil** yang menampilkan penilaian gambar.

#### Informasi yang Ditampilkan

| Elemen | Deskripsi |
|---|---|
| **Preview Gambar** | Tampilan gambar yang telah Anda buat |
| **Nama Hewan** | Hewan yang Anda pilih di awal (bukan hasil prediksi AI) |
| **Skor Kemiripan** | Persentase kemiripan gambar Anda dengan hewan yang dipilih (0.0% — 100.0%) |
| **Durasi** | Waktu yang dihabiskan untuk menggambar |
| **Skor Game** | Poin yang diperoleh dari sesi menggambar ini |
| **Bintang** | Indikator performa berdasarkan hasil |

#### Navigasi dari Halaman Hasil

Setelah melihat hasil, Anda memiliki dua pilihan:

- **KEMBALI** — Kembali ke Halaman Utama
- **BERIKUTNYA** — Bermain lagi dengan memilih hewan baru (diarahkan ke halaman Pilih Hewan)

> **Catatan:** Hasil permainan akan otomatis disimpan ke server. Anda dapat melihat kembali riwayat permainan melalui fitur **Galeri**.

---

## 7. Fitur Tambahan

### 7.1 Galeri / Riwayat Permainan

Akses melalui: **Halaman Utama → Galeri**

Fitur Galeri memungkinkan Anda melihat riwayat semua sesi menggambar yang telah dilakukan, termasuk:
- Gambar yang telah dibuat
- Hewan yang dipilih
- Skor yang diperoleh
- Durasi menggambar
- Tanggal dan waktu permainan

Ketuk salah satu riwayat untuk melihat **detail sesi** secara lengkap.

---

### 7.2 Papan Peringkat (Leaderboard)

Akses melalui: **Halaman Utama → Peringkat**

Papan Peringkat menampilkan daftar pemain dengan skor tertinggi. Fitur ini memungkinkan Anda:
- Melihat posisi peringkat Anda dibandingkan pemain lain
- Melihat skor tertinggi yang pernah dicapai
- Memotivasi diri untuk terus berlatih menggambar

> **Catatan:** Diperlukan koneksi internet untuk memuat data peringkat.

---

### 7.3 Toko (Shop)

Akses melalui: **Halaman Utama → Toko** (melalui ikon di menu utama atau tombol di pojok kanan bawah)

Toko menyediakan berbagai item menarik yang dapat dibeli menggunakan poin yang diperoleh dari bermain. Item memiliki tingkat kelangkaan (rarity) yang berbeda:

| Rarity | Warna | Keterangan |
|---|---|---|
| **Common** | Abu-abu | Item umum, harga terjangkau |
| **Rare** | Biru | Item langka, harga menengah |
| **Epic** | Ungu | Item sangat langka, harga tinggi |
| **Legendary** | Emas | Item paling langka, harga premium |

#### Cara Membeli Item:
1. Buka halaman **Toko**.
2. Telusuri item yang tersedia (scroll ke bawah untuk melihat lebih banyak).
3. Ketuk item yang ingin dibeli untuk melihat **detail item**.
4. Ketuk tombol **"Beli"** untuk melakukan pembelian (pastikan poin mencukupi).

---

### 7.4 Inventori

Akses melalui: **Halaman Utama → Inventori** (tombol di pojok kanan bawah)

Halaman Inventori menampilkan semua item yang telah Anda beli dari Toko. Di sini Anda dapat:
- Melihat koleksi item yang dimiliki
- Mengatur atau menggunakan item tertentu

---

### 7.5 Statistik

Akses melalui: **Halaman Utama → Statistik** (jika tersedia)

Halaman Statistik memberikan ringkasan performa Anda secara keseluruhan, termasuk:
- Jumlah total sesi menggambar
- Rata-rata skor kemiripan
- Hewan yang paling sering digambar
- Progres perkembangan dari waktu ke waktu

---

## 8. Sistem Skor

### Bagaimana Skor Dihitung?

Skor kemiripan dalam AniDraw dihitung berdasarkan seberapa mirip gambar yang Anda buat dengan hewan yang Anda **pilih** di awal permainan. Berikut penjelasan detailnya:

1. **Gambar Anda diproses** — Setelah menekan "Selesai", gambar Anda melalui beberapa tahap pemrosesan:
   - Background dihapus dan diganti putih
   - Gambar di-crop agar fokus pada objek yang digambar
   - Gambar di-resize ke ukuran standar
   - Gambar dinormalisasi untuk analisis AI

2. **AI Mengklasifikasi** — Model AI (berbasis MobileNetV2) akan menganalisis gambar dan memberikan skor kepercayaan untuk masing-masing dari 5 hewan.

3. **Skor Dihitung** — Skor yang ditampilkan adalah **skor kepercayaan AI terhadap hewan yang Anda pilih**, bukan skor untuk hewan yang paling mirip menurut AI.

### Contoh Perhitungan Skor:

> Anda memilih **Kucing**, lalu menggambar. AI memberikan skor:
> - Kucing: 72.5%
> - Bebek: 15.3%
> - Ikan: 5.1%
> - Sapi: 4.8%
> - Lumba-Lumba: 2.3%
>
> **Skor yang ditampilkan: 72.5%** (karena Anda memilih Kucing)

### Rentang Skor

| Rentang | Keterangan |
|---|---|
| **80% — 100%** | ⭐⭐⭐ Luar biasa! Gambar sangat mirip |
| **50% — 79%** | ⭐⭐ Bagus! Terus berlatih |
| **20% — 49%** | ⭐ Cukup baik, coba lagi ya! |
| **0% — 19%** | Hmm, coba gambar ulang dengan lebih teliti |

---

## 9. Tips Menggambar agar Skor Tinggi

Berikut beberapa tips agar gambar Anda mendapatkan skor kemiripan yang tinggi:

### ✅ Yang Sebaiknya Dilakukan

1. **Gambar ciri khas hewan** — Fokus pada fitur utama hewan (contoh: telinga runcing untuk kucing, sirip untuk ikan).
2. **Gambar di tengah kanvas** — Usahakan gambar berada di area tengah kanvas, jangan terlalu kecil di pojok.
3. **Gunakan garis yang jelas** — Buat garis yang tegas dan mudah terlihat.
4. **Manfaatkan mode Tebalkan** — Jika baru pertama kali, gunakan mode "Ayo Tebalkan!" untuk belajar bentuk dasar hewan.
5. **Lihat contoh** — Ketuk tombol "CONTOH" di halaman menggambar untuk melihat referensi gambar.
6. **Gambar dengan ukuran proporsional** — Gambar tidak terlalu kecil agar AI dapat mengenalinya dengan baik.

### ❌ Yang Sebaiknya Dihindari

1. **Kanvas kosong** — Jangan menekan "Selesai" tanpa menggambar apapun.
2. **Gambar terlalu kecil** — Gambar yang sangat kecil sulit dikenali oleh AI.
3. **Terlalu banyak detail tidak perlu** — AI dilatih dengan sketch sederhana, jadi gambar sederhana yang jelas justru lebih mudah dikenali.
4. **Menggambar hewan yang berbeda** — Pastikan Anda menggambar hewan yang sesuai dengan pilihan Anda.

---

## 10. Tanya Jawab (FAQ)

### Q: Apakah aplikasi ini memerlukan koneksi internet?
**A:** Proses menggambar dan klasifikasi gambar berjalan **sepenuhnya offline** dan tidak memerlukan internet. Namun, fitur login, registrasi, papan peringkat, toko, dan sinkronisasi riwayat memerlukan koneksi internet.

### Q: Berapa hewan yang tersedia untuk digambar?
**A:** Saat ini tersedia **5 hewan**: Kucing, Sapi, Bebek, Ikan, dan Lumba-Lumba.

### Q: Apa perbedaan antara mode "Ayo Tebalkan" dan "Gambar Sendiri"?
**A:** Mode "Ayo Tebalkan" menampilkan gambar panduan transparan yang bisa Anda tebalkan, cocok untuk pemula. Mode "Gambar Sendiri" memberikan kanvas kosong untuk menggambar bebas, cocok untuk yang sudah percaya diri.

### Q: Mengapa skor saya rendah padahal gambar saya bagus?
**A:** Skor dihitung berdasarkan kemiripan gambar Anda dengan hewan yang **Anda pilih**. Jika Anda menggambar dengan gaya yang sangat berbeda dari apa yang dikenali AI, skor bisa rendah. Coba gambar dengan bentuk yang lebih sederhana dan jelas.

### Q: Bisakah saya membatalkan goresan?
**A:** Ya, gunakan tombol **Undo** untuk membatalkan satu goresan terakhir, atau tombol **Clear** untuk menghapus semua gambar sekaligus.

### Q: Bagaimana cara mendapatkan poin?
**A:** Poin diperoleh dari setiap sesi menggambar yang berhasil. Semakin tinggi skor kemiripan, semakin banyak poin yang diperoleh.

### Q: Apakah data gambar saya tersimpan?
**A:** Ya, setiap sesi menggambar yang diselesaikan akan tersimpan dan dapat dilihat kembali melalui fitur **Galeri** di halaman utama.

### Q: Kenapa layar selalu dalam posisi landscape?
**A:** Aplikasi dirancang khusus untuk mode **landscape** (mendatar) agar area kanvas menggambar lebih luas dan nyaman digunakan.

### Q: Apakah aplikasi ini bisa digunakan di iOS?
**A:** Saat ini aplikasi dioptimalkan untuk **Android**. Dukungan iOS tersedia namun belum menjadi prioritas utama.

---

## 11. Pemecahan Masalah (Troubleshooting)

### Masalah: Aplikasi tidak bisa dibuka / crash saat startup

**Solusi:**
1. Pastikan perangkat memenuhi persyaratan sistem minimum.
2. Hapus cache aplikasi: **Pengaturan → Aplikasi → AniDraw → Hapus Cache**.
3. Uninstall dan install ulang aplikasi.
4. Pastikan ruang penyimpanan mencukupi (minimal 100 MB).

### Masalah: Muncul pesan error saat splash screen

**Solusi:**
1. Ketuk tombol **"Coba Lagi"** yang muncul di layar.
2. Pastikan koneksi internet tersedia untuk proses autentikasi.
3. Jika masalah berlanjut, install ulang aplikasi.

### Masalah: Login gagal

**Solusi:**
1. Pastikan email dan kata sandi yang dimasukkan sudah benar.
2. Periksa koneksi internet Anda.
3. Jika lupa kata sandi, hubungi administrator.

### Masalah: Gambar tidak bisa diklasifikasi ("Nothing to classify yet")

**Solusi:**
Pesan ini muncul karena kanvas masih kosong. Pastikan Anda sudah menggambar sesuatu di kanvas sebelum menekan tombol **SELESAI**.

### Masalah: Skor selalu rendah

**Solusi:**
1. Pastikan Anda menggambar hewan yang **sesuai** dengan pilihan Anda.
2. Gambar dengan ukuran yang cukup besar di kanvas.
3. Fokus pada ciri khas utama hewan (bentuk badan, telinga, ekor, dll).
4. Coba gunakan mode **"Ayo Tebalkan!"** terlebih dahulu untuk memahami bentuk dasar.

### Masalah: Aplikasi lambat / lag saat menggambar

**Solusi:**
1. Tutup aplikasi lain yang berjalan di latar belakang.
2. Restart perangkat Android Anda.
3. Pastikan perangkat memiliki RAM minimal 2 GB.

### Masalah: Tidak bisa mengakses Toko / Papan Peringkat

**Solusi:**
Fitur ini memerlukan koneksi internet. Pastikan perangkat Anda terhubung ke Wi-Fi atau data seluler.

---

> 📌 **Dokumen ini akan diperbarui seiring dengan pembaruan versi aplikasi.**  
> Jika Anda menemukan masalah yang tidak tercantum di sini, silakan hubungi tim pengembang.
