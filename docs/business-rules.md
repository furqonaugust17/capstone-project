# Business Rules

> Dokumen ini mendeskripsikan aturan bisnis yang diterapkan dalam aplikasi, diturunkan dari source code yang ada.  
> **Konteks:** Aplikasi edukasi menggambar hewan untuk anak-anak, berbasis klasifikasi gambar on-device.

---

## 1. Alur Pengguna (User Journey)

```
Home
  │
  └─► Pilih Hewan (Choose)
          │
          └─► Pilih Mode (Mode)
                  │
                  ├─► Mode "Ayo Tebalkan!" (thicken)
                  │       └─► Drawing Page (dengan trace gambar)
                  │               └─► Klasifikasi → Result
                  │
                  └─► Mode "Gambar Sendiri!" (free)
                          └─► Drawing Page (kanvas kosong)
                                  └─► Klasifikasi → Result
                                          └─► Kembali ke Home
```

---

## 2. Pilihan Hewan (Animal Selection)

### BR-001: Hewan yang Tersedia
Aplikasi mendukung **tepat 5 hewan**:

| No | Nama | Icon |
|---|---|---|
| 1 | Kucing | pets |
| 2 | Sapi | grass |
| 3 | Bebek | water |
| 4 | Ikan | set_meal |
| 5 | Lumba-Lumba | pool |

### BR-002: Hewan Harus Dipilih Sebelum Menggambar
Pengguna **tidak dapat** langsung ke halaman gambar tanpa memilih hewan terlebih dahulu. Pilihan hewan di-pass melalui route parameter `extra: {'animal': 'Kucing'}`.

### BR-003: Fallback Hewan Default
Jika `selectedAnimal` adalah `null` (kondisi error atau direct navigation), sistem menggunakan **"Kucing"** sebagai default di DrawingPage dan ResultPage.

---

## 3. Mode Menggambar (Drawing Mode)

### BR-004: Dua Mode yang Tersedia
- **`thicken`** — "Ayo Tebalkan!": Menampilkan gambar contoh sebagai trace transparan (opacity 35%) di belakang kanvas. Pengguna diminta menebalkan garis.
- **`free`** — "Gambar Sendiri!": Kanvas kosong tanpa panduan. Pengguna menggambar bebas.

### BR-005: Trace Image per Hewan
Setiap hewan memiliki satu contoh gambar trace yang berbeda:

| Hewan | Asset Path |
|---|---|
| Kucing | `assets/images/example/cat.png` |
| Sapi | `assets/images/example/cow.png` |
| Bebek | `assets/images/example/duck.png` |
| Ikan | `assets/images/example/fish.png` |
| Lumba-Lumba | `assets/images/example/dolphin.png` |

Jika hewan tidak dikenal (nama tidak cocok), **trace tidak ditampilkan** (null-safe fallback).

### BR-006: Trace Hanya pada Mode Thicken
Gambar trace **hanya** ditampilkan saat `drawingMode == 'thicken'`. Pada mode `free`, kanvas selalu kosong tanpa trace.

---

## 4. Kanvas Menggambar (Drawing Canvas)

### BR-007: Warna Background Kanvas
Background kanvas adalah **`0xFFF7F9FC`** (R=247, G=249, B=252) — warna ini bukan putih murni tetapi "clean white" dari design system. Warna ini adalah konstanta penting yang konsisten antara rendering dan preprocessing.

### BR-008: Brush Default
Saat memulai session menggambar, brush default adalah:
- **Warna:** Hitam (`0xFF000000`)
- **Ukuran:** 6.0 px

### BR-009: Tool yang Tersedia
- **Pen** — menggambar stroke normal
- **Eraser** — menghapus dengan `BlendMode.clear`

### BR-010: Undo
Pengguna dapat undo **satu stroke terakhir** setiap kali menekan undo. Stroke yang sudah di-clear tidak dapat di-recover.

### BR-011: Clear Canvas
Menekan tombol clear akan **menghapus semua stroke** sekaligus. Aksi ini juga memanggil `DrawingCubit.clear()` yang membersihkan persistence.

### BR-012: Smooth Drawing
Stroke dirender menggunakan **quadratic Bezier curve** dengan titik tengah antara dua point sebagai kontrol point, menghasilkan garis yang halus dan natural.

---

## 5. Klasifikasi Gambar (Classification)

### BR-013: Gambar Harus Ada untuk Diklasifikasi
Jika pengguna menekan tombol "Finish" tanpa menggambar apapun (kanvas kosong / `captureImage()` returns null), sistem menampilkan snackbar **"Nothing to classify yet"** dan tidak melanjutkan ke klasifikasi.

### BR-014: Format Input ke Model
Gambar yang dikirim ke model **selalu dalam format raw RGBA** (`ui.ImageByteFormat.rawRgba`) yang di-capture langsung dari `RenderRepaintBoundary`.

### BR-015: Pipeline Preprocessing (Urutan Wajib)
Sebelum dikirim ke model, gambar **harus** melalui pipeline berikut secara berurutan:
1. **Replace background** — pixel yang mirip warna background (threshold diff ≤ 30) diganti dengan putih murni
2. **Crop to drawing** — bounding box dari semua foreground pixel (diff > 30 dari background)
3. **Center to square** — drawing di-center di dalam canvas persegi dengan background putih
4. **Resize** — ke 224×224 px (model input size)
5. **Grayscale** (opsional) — hanya jika model membutuhkan 1 channel

### BR-016: Deteksi Foreground
Pixel dianggap "foreground" (stroke gambar) jika **total perbedaan RGB** terhadap background color > **30**:
```
diff = |r - 247| + |g - 249| + |b - 252| > 30
```

### BR-017: Normalisasi Tensor
Setiap nilai pixel dinormalisasi menggunakan:
```
normalized = (pixel_value - 127.5) / 127.5
```
Menghasilkan range **[-1.0, 1.0]**.

### BR-018: Model Output — 5 Kelas
Model menghasilkan **5 confidence score** yang merepresentasikan probabilitas setiap kelas:

| Index | Hewan |
|---|---|
| 0 | Bebek |
| 1 | Ikan |
| 2 | Kucing |
| 3 | Lumba-Lumba |
| 4 | Sapi |

**Penting:** Urutan index model (alphabetical) berbeda dari urutan tampilan UI.

### BR-019: Label Prediksi
Label yang ditampilkan diambil dari `labels.txt` menggunakan index prediksi terbaik (argmax).

### BR-020: Fallback ke Raw RGBA
Jika image bytes gagal di-decode sebagai PNG (tapi byte count-nya adalah kelipatan 4), sistem mencoba **infer dimensi** sebagai raw RGBA:
1. Cek apakah `width × height × 4 == bytes.length` dari dimensi yang diberikan
2. Cek apakah byte count cocok dengan model input dimensions (224×224)
3. Cek apakah byte count adalah perfect square (sqrt → integer)
4. Jika tidak ada yang cocok → rethrow exception asli

---

## 6. Perhitungan Skor Kemiripan (Similarity Score)

### BR-021: Skor Berdasarkan Hewan yang Dipilih, Bukan Prediksi Terbaik
Skor kemiripan yang ditampilkan adalah **confidence score spesifik untuk hewan yang dipilih pengguna**, bukan confidence score dari prediksi terbaik model:

```dart
final index = _selectedAnimalIndex(selectedAnimal);  // mapping hewan → index
final similarityPercent = rawScores[index] * 100;
```

Ini berarti skor bisa rendah meskipun model yakin dengan prediksinya (jika prediksi berbeda dari hewan yang dipilih).

### BR-022: Fallback Skor
Jika hewan yang dipilih tidak dikenal atau index out of range, fallback menggunakan **confidence score prediksi terbaik × 100**.

### BR-023: Skor Dikunci ke Range [0, 100]
`rawScores[index].clamp(0.0, 1.0) * 100` — skor tidak bisa negatif atau melebihi 100%.

### BR-024: Tampilan Skor
Skor ditampilkan dengan **1 desimal** di halaman result:
```dart
'${(similarityPercent ?? 0).toStringAsFixed(1)}%'
```

---

## 7. Halaman Hasil (Result Page)

### BR-025: Data yang Ditampilkan
Result page menampilkan:
1. **Gambar gambar pengguna** — preview PNG dari kanvas
2. **Nama hewan** — yang dipilih pengguna (bukan prediksi model)
3. **Skor kemiripan** — sesuai BR-021
4. **Pesan positif** — "Hebat! Ini adalah [Hewan]!" — selalu menampilkan hewan yang dipilih, bukan hewan yang diprediksi
5. **3 bintang** — ditampilkan secara statis (selalu 3 bintang, belum dinamis)
6. **Score badge** — "1,240" (hardcoded, belum dinamis)
7. **Waktu** — "00:45" (hardcoded, belum implementasi timer)

### BR-026: Navigasi dari Result
Pengguna dapat:
- **Kembali ke Home** — tombol back (icon) → `context.go('/')`
- **Action buttons** — via `ResultActionButtons` widget (implementasi detail di widget tersebut)

### BR-027: Fallback Image
Jika `imageBytes` adalah null, result page menampilkan gambar fallback: `assets/images/result/cat_drawing.png`.

---

## 8. Orientasi Layar

### BR-028: Landscape Only
Aplikasi **dikunci ke mode landscape** (landscape left dan landscape right) sejak startup via `SystemChrome.setPreferredOrientations`. Portrait mode tidak didukung.

---

## 9. Persistensi Data

### BR-029: Gambar Disimpan Secara Otomatis
Drawing session disimpan ke `SharedPreferences` dengan key `drawing_session` setiap kali `SaveDrawingUseCase` dipanggil.

### BR-030: Session Bisa Di-Clear
`ClearDrawingUseCase` menghapus data dari SharedPreferences. Clear ini terjadi saat pengguna menekan tombol clear pada kanvas.

### BR-031: Database Scores (Infrastruktur)
Tabel `scores` di Drift SQLite sudah terdefinisi untuk menyimpan riwayat klasifikasi (label, confidence, timestamp), namun belum terhubung ke alur klasifikasi aktif. Ini adalah infrastruktur yang siap digunakan.

---

## 10. Constraint Teknis

### BR-032: Tidak Ada Network Request
Semua klasifikasi dilakukan **sepenuhnya on-device**. Tidak ada request ke API eksternal untuk inferensi gambar.

### BR-033: Model Harus Ada di Assets
Jika `sketch_model.tflite` atau `labels.txt` tidak ada di assets, aplikasi akan throw `TFLiteServiceException` saat init dan tidak dapat berfungsi.

### BR-034: Model Harus Diinisialisasi Sebelum Klasifikasi
`TFLiteService.init()` dipanggil saat DI setup (startup), dan juga dipanggil sebagai guard sebelum setiap inferensi (`await _tfliteService.init()` di datasource). Double-init aman karena ada guard `if (isInitialized) return`.

### BR-035: Labels Tidak Boleh Kosong
Jika `labels.txt` kosong, sistem throw `TFLiteServiceException('Labels file is empty.')`. Minimal 1 label diperlukan.
