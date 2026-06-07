# Project Memory

> Dokumen ini adalah **living document** yang mencatat konteks, keputusan, dan status terkini project.  
> Update setiap kali ada perubahan signifikan.  
> **Last updated:** 2026-06-07

---

## 1. Identitas Project

| Item | Detail |
|---|---|
| **Nama** | Educational Animal Drawing App |
| **Tipe** | Capstone Project — Semester 6 |
| **Platform** | Flutter (multi-platform, target utama: Android) |
| **Orientasi** | Landscape Only |
| **Bahasa UI** | Bahasa Indonesia |
| **App Title** | "Educational Animal Drawing" |
| **Flutter SDK** | ^3.11.4 |
| **Versi App** | 0.1.0+1 |

---

## 2. Tujuan Aplikasi

Aplikasi edukasi interaktif untuk anak-anak yang belajar menggambar hewan menggunakan tablet/device. Pengguna memilih hewan, menggambar di kanvas digital, lalu mendapat **skor kemiripan** dari model AI yang berjalan langsung di device (on-device inference) tanpa internet.

---

## 3. Status Implementasi

### ✅ Selesai / Berfungsi
- [x] Arsitektur Clean Architecture 3-layer untuk fitur `drawing` dan `classification`
- [x] Navigation flow lengkap: Home → Choose → Mode → Drawing → Result
- [x] Drawing canvas dengan stroke rendering (quadratic bezier)
- [x] Pen dan eraser tool
- [x] Undo dan clear canvas
- [x] Trace image untuk mode "thicken"
- [x] ML pipeline: capture RGBA → preprocess → TFLite inference → skor
- [x] Background color replacement sebelum inference
- [x] Crop to drawing region (foreground detection)
- [x] Center to square + resize ke 224×224
- [x] Normalisasi tensor: (pixel - 127.5) / 127.5
- [x] Skor kemiripan berdasarkan hewan yang dipilih (bukan argmax)
- [x] Result page dengan preview gambar dan skor
- [x] Theme system lengkap (colors, typography, spacing, dimensions)
- [x] Dependency injection (GetIt) dengan feature modules
- [x] Drift SQLite database (tabel scores terdefinisi)
- [x] Drawing persistence via SharedPreferences

### ⚠️ Partial / Hardcoded (Belum Final)
- [ ] **Score badge** di result page: hardcoded "1,240" — belum dihitung/disimpan
- [ ] **Timer "WAKTU"** di result page: hardcoded "00:45" — belum ada timer aktif
- [ ] **3 bintang** di result page: selalu tampil 3 bintang — belum berdasarkan skor
- [ ] **ResultActionButtons**: widget ada tapi behavior belum fully implemented
- [ ] **Tabel `scores`** (Drift): terdefinisi tapi belum digunakan untuk menyimpan hasil

### ❌ Belum Diimplementasi
- [ ] Sound/audio effects (package `audioplayers` sudah ada di pubspec tapi belum dipakai)
- [ ] Animations (package `flutter_animate` sudah ada tapi belum dipakai)
- [ ] Riwayat gambar / leaderboard
- [ ] Settings / preferensi pengguna
- [ ] Onboarding / tutorial untuk anak

---

## 4. Model ML

### Spesifikasi
- **File:** `assets/models/sketch_model.tflite`
- **Arsitektur:** MobileNetV2-based (berdasarkan context dari percakapan sebelumnya)
- **Input:** 224×224×3 (RGB, float32, normalized [-1, 1])
- **Output:** 5 confidence scores
- **Labels:** `assets/models/labels.txt`

### Kelas yang Didukung (Index Order Alphabetical)
```
0: Bebek
1: Ikan  
2: Kucing
3: Lumba-Lumba
4: Sapi
```

### Riwayat Debugging ML (dari conversation f069ad45)
- **Problem:** Tensor shape mismatch dan type casting error antara Flutter dan TFLite native interpreter
- **Fix:** Input dikirim sebagai raw `Uint8List` (ByteBuffer) bukan nested list → menghindari "List<double> is not a subtype of Float32List" error
- **Problem:** Background color canvas (0xFFF7F9FC) menyebabkan model salah membaca
- **Fix:** `replaceBackgroundWithWhite()` sebelum crop dan inference

---

## 5. Keputusan Arsitektur Penting

### DK-001: ValueNotifier di DrawingController
DrawingController menggunakan `ValueNotifier` (bukan setState) untuk performa rendering. `AnimatedBuilder` di `DrawingCanvas` hanya rebuild canvas saat `_repaint` notifier berubah — bukan seluruh widget tree.

### DK-002: Raw RGBA untuk Inference
Canvas di-capture sebagai `rawRgba` bukan `png` untuk menghindari loss quality dari re-encoding. PNG bytes tetap di-capture secara terpisah untuk preview di result page.

### DK-003: Skor Berdasarkan Hewan yang Dipilih
Skor yang ditampilkan adalah `rawScores[selectedAnimalIndex]`, bukan `max(rawScores)`. Ini adalah keputusan pedagogi — skor mencerminkan "seberapa mirip dengan hewan yang kamu pilih", bukan "model paling yakin ini hewan apa".

### DK-004: Artboard Fixed Size 917×412
Semua scene section menggunakan fixed artboard size 917×412 yang di-FittedBox untuk responsif di semua ukuran layar landscape. Ini mengikuti design Figma asli.

### DK-005: Fallback Inferensi Raw RGBA
`TFLiteLocalDataSourceImpl` memiliki 3-tier fallback untuk format input:
1. Explicit `isRawRgba = true` → `preprocessFromRgba()`
2. Byte count cocok dengan `width × height × 4` → `preprocessFromRgba()`
3. PNG decode berhasil → `preprocess()`
4. PNG gagal tapi byte count kelipatan 4 → infer dimensi → `preprocessFromRgba()`

### DK-006: Drawing Storage via SharedPreferences (Sementara)
Komentar di kode menyebut: "In production replace with Drift implementation (DB) per project rules." SharedPreferences digunakan sebagai implementasi sementara yang fungsional.

---

## 6. Tech Debt yang Diketahui

| ID | Lokasi | Masalah | Prioritas |
|---|---|---|---|
| TD-001 | `result_scene_section.dart:80` | Score badge hardcoded "1,240" | Medium |
| TD-002 | `result_scene_section.dart:150` | Timer hardcoded "00:45" | Medium |
| TD-003 | `result_scene_section.dart` | 3 stars selalu tampil (tidak berdasarkan skor) | Low |
| TD-004 | `drawing_local_data_source.dart` | Komentar "replace with Drift" — belum dilakukan | Low |
| TD-005 | `core/database/tables.dart` | Tabel `scores` tidak terintegrasi ke flow | Low |
| TD-006 | `signature_prediction_helper.dart` | Helper untuk SignaturePad lama, mungkin tidak terpakai | Low |
| TD-007 | `main.dart:31-50` | Kode lama di-comment, bisa dihapus | Low |
| TD-008 | `core/utils/image_preprocessor.dart` | Kemungkinan duplikat dari `core/ml/image_preprocessor.dart` | Medium |
| TD-009 | `environment.dart` | API URLs adalah placeholder, belum ada network calls | Low |
| TD-010 | Seluruh codebase | `print()` statements masih banyak untuk debugging | High (sebelum release) |

---

## 7. Dependency Package Penting

| Package | Versi | Kegunaan |
|---|---|---|
| `flutter_bloc` | ^9.1.1 | State management (BLoC + Cubit) |
| `go_router` | ^17.2.3 | Declarative routing |
| `get_it` | ^9.2.1 | Service locator / DI |
| `equatable` | ^2.0.8 | Value equality untuk entities/states |
| `tflite_flutter` | ^0.12.1 | On-device ML inference |
| `drift` | ^2.33.0 | Type-safe SQLite ORM |
| `drift_sqflite` | ^2.0.1 | Drift adapter untuk sqflite |
| `sqflite` | ^2.4.2+1 | SQLite driver |
| `image` | ^4.8.0 | Image processing (decode, resize, crop, grayscale) |
| `shared_preferences` | ^2.5.5 | Drawing session persistence |
| `audioplayers` | ^6.6.0 | Audio (BELUM DIPAKAI) |
| `flutter_animate` | ^4.5.2 | Animations (BELUM DIPAKAI) |
| `syncfusion_flutter_signaturepad` | ^33.2.7 | Signature capture (dipakai di helper lama) |
| `path_provider` | ^2.1.5 | Lokasi direktori database |
| `freezed_annotation` | ^3.1.0 | Code generation untuk immutable classes |
| `json_annotation` | ^4.12.0 | JSON serialization codegen |

---

## 8. Referensi File Kunci

| File | Peran |
|---|---|
| `lib/main.dart` | Entry point — orientasi + DI bootstrap + MaterialApp |
| `lib/routes/app_router.dart` | Semua route definitions |
| `lib/injection/injection.dart` | Root DI — core singletons + feature modules |
| `lib/core/constants/app_constants.dart` | Model specs, input size, normalization params |
| `lib/core/ml/tflite_service.dart` | TFLite interpreter wrapper |
| `lib/core/ml/image_preprocessor.dart` | Preprocessing pipeline |
| `lib/core/ml/tensor_converter.dart` | Float32 conversion + validation |
| `lib/core/database/tables.dart` | Drift table definition |
| `lib/features/classification/data/datasources/tflite_local_data_source.dart` | ML pipeline orchestration |
| `lib/features/classification/presentation/bloc/classification_bloc.dart` | Classification state machine |
| `lib/features/drawing/presentation/controllers/drawing_controller.dart` | Drawing state (low-level) |
| `lib/features/drawing/presentation/painter/sketch_painter.dart` | Custom canvas renderer |
| `lib/features/drawing/presentation/widgets/drawing_canvas.dart` | Canvas widget + image capture |
| `lib/features/drawing/presentation/pages/drawing_page.dart` | Drawing UX + classification trigger |

---

## 9. Quick Reference: Task Umum

### Menambah Hewan Baru
1. Tambah pilihan di `choose_scene_section.dart` (`AnimalPill`)
2. Tambah trace asset path di `drawing_page.dart` (`_exampleAssetPath()`)
3. Tambah index mapping di `drawing_page.dart` (`_selectedAnimalIndex()`)
4. Tambah asset gambar contoh di `assets/images/example/`
5. Update model TFLite dan `labels.txt` untuk kelas baru

### Menambah Mode Baru
1. Tambah mode pill di `mode_scene_section.dart`
2. Handle mode di `drawing_page.dart` (kondisi `showExamplePreview`)
3. Pass mode melalui router extra

### Integrasi Timer Nyata ke Result
1. Tambah `Stopwatch` di `DrawingPage`
2. Start saat halaman load, stop saat tombol finish ditekan
3. Pass elapsed time sebagai extra ke route `/result`
4. Update `ResultSceneSection` untuk tampilkan waktu dinamis

### Menyimpan Skor ke Database
1. Inject `AppDatabase` ke `ClassificationBloc` atau gunakan UseCase baru
2. Setelah `ClassificationSuccess`, insert ke tabel `scores`:
   ```dart
   db.into(db.scores).insert(ScoresCompanion(
     label: Value(prediction.label),
     confidence: Value(prediction.confidence),
     timestamp: Value(DateTime.now().millisecondsSinceEpoch),
   ));
   ```

---

## 10. Conversation History yang Relevan

| Conversation | Topik |
|---|---|
| `f069ad45` | Fixing TFLite inference errors (tensor shape mismatch, RGBA preprocessing) |
