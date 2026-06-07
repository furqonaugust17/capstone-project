# Coding Rules & Conventions

> Dokumen ini diturunkan langsung dari source code yang ada di project.  
> **Berlaku untuk:** Semua kontributor yang mengembangkan fitur baru atau memodifikasi kode yang ada.

---

## 1. Prinsip Utama

1. **Clean Architecture** — Dependency hanya boleh mengalir ke dalam (Presentation → Domain ← Data)
2. **Domain Layer adalah Core** — Domain entities dan repository interfaces **tidak boleh** mengimport package Flutter atau package pihak ketiga apapun (kecuali `equatable` untuk value equality)
3. **Satu Tanggung Jawab** — Setiap kelas, file, dan fungsi hanya melakukan satu hal
4. **Const First** — Gunakan `const` constructor dan widget kapanpun memungkinkan

---

## 2. Struktur File & Naming

### 2.1 File Naming
- Semua file menggunakan `snake_case`: `drawing_page.dart`, `tflite_service.dart`
- Suffix file harus mencerminkan peran: `_page`, `_section`, `_widget`, `_bloc`, `_cubit`, `_state`, `_event`, `_entity`, `_model`, `_repository`, `_usecase`, `_datasource`, `_controller`

### 2.2 Class Naming
- Classes menggunakan `PascalCase`
- Suffix class harus konsisten dengan suffix file:

| Peran | Suffix Contoh |
|---|---|
| Domain Entity | `PredictionEntity`, `Stroke`, `Brush` |
| Data Model | `PredictionModel`, `StrokeModel` |
| Repository Interface | `ClassificationRepository`, `DrawingRepository` |
| Repository Impl | `ClassificationRepositoryImpl`, `DrawingRepositoryImpl` |
| Data Source Interface | `TFLiteLocalDataSource`, `DrawingLocalDataSource` |
| Data Source Impl | `TFLiteLocalDataSourceImpl`, `DrawingLocalDataSourceImpl` |
| Use Case | `ClassifySketchUseCase`, `SaveDrawingUseCase` |
| BLoC | `ClassificationBloc` |
| Cubit | `DrawingCubit` |
| State | `ClassificationState`, `ClassificationSuccess`, dll. |
| Event | `ClassificationEvent`, `ClassificationRequested`, dll. |
| Page | `DrawingPage`, `HomePage` |
| Section | `DrawingSceneSection`, `ResultSceneSection` |
| Widget | `DrawingCanvas`, `SketchPainter` |
| Controller | `DrawingController` |
| Service | `TFLiteService` |
| Exception | `TFLiteServiceException`, `ClassificationException` |

### 2.3 Variable & Method Naming
- Variables dan methods: `camelCase`
- Constants: `camelCase` (Dart convention), bukan `SCREAMING_SNAKE_CASE`
- Private members: prefix underscore `_interpreter`, `_isInitialized`

---

## 3. Layer Rules

### 3.1 Domain Layer
```dart
// ✅ BENAR — domain entity hanya Pure Dart
class PredictionEntity extends Equatable {
  final String label;
  final double confidence;
  // ...
}

// ✅ BENAR — repository adalah abstract interface
abstract class ClassificationRepository {
  Future<PredictionEntity> classifySketch(Uint8List imageBytes, {...});
}

// ❌ SALAH — jangan import Flutter di domain
import 'package:flutter/material.dart'; // NOT ALLOWED in domain/
```

### 3.2 Data Layer
```dart
// ✅ BENAR — Model extends Entity (tambahkan serialization di sini)
class PredictionModel extends PredictionEntity {
  factory PredictionModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}

// ✅ BENAR — Repo Impl hanya bergantung pada DataSource (via interface)
class ClassificationRepositoryImpl implements ClassificationRepository {
  final TFLiteLocalDataSource _localDataSource;
  // ...
}
```

### 3.3 Presentation Layer
```dart
// ✅ BENAR — Page hanya berisi scaffold + wiring BLoC
class DrawingPage extends StatefulWidget { ... }

// ✅ BENAR — BLoC/Cubit hanya menggunakan UseCase, tidak langsung ke Repository
class ClassificationBloc extends Bloc<ClassificationEvent, ClassificationState> {
  final ClassifySketchUseCase _classifySketchUseCase;
}

// ❌ SALAH — jangan akses repository langsung dari BLoC/Cubit
class DrawingCubit extends Cubit<DrawingState> {
  final DrawingRepository repository; // WRONG
}
```

---

## 4. State Management

### 4.1 Pilihan BLoC vs Cubit
- **Gunakan BLoC** untuk fitur yang memiliki banyak event berbeda dan transisi state kompleks (contoh: `ClassificationBloc`)
- **Gunakan Cubit** untuk fitur yang state-nya lebih sequential dan sederhana (contoh: `DrawingCubit`)

### 4.2 State Definitions
```dart
// ✅ BENAR — setiap state sebagai class tersendiri
class ClassificationSuccess extends ClassificationState {
  final PredictionEntity prediction;
  const ClassificationSuccess(this.prediction);
  
  @override
  List<Object?> get props => [prediction]; // wajib override props
}

// ❌ SALAH — jangan gunakan enum untuk state yang membawa data
enum ClassificationStatus { initial, loading, success, error } // TOO SIMPLE
```

### 4.3 Part Files
Event dan State harus menggunakan `part of` pattern:
```dart
// classification_bloc.dart
part 'classification_event.dart';
part 'classification_state.dart';

// classification_state.dart
part of 'classification_bloc.dart';
```

### 4.4 DrawingController (Low-level State)
Untuk state rendering performa tinggi, gunakan `ValueNotifier` + `AnimatedBuilder`:
```dart
// ✅ BENAR — gunakan ValueNotifier untuk menghindari full rebuild
final ValueNotifier<List<Stroke>> strokes = ValueNotifier([]);

// Di widget: gunakan AnimatedBuilder, bukan setState
AnimatedBuilder(
  animation: controller.repaint,
  builder: (context, _) { ... },
);
```

---

## 5. Error Handling

### 5.1 Custom Exception per Layer
Setiap layer memiliki custom exception class sendiri:
```dart
class TFLiteServiceException implements Exception {
  final String message;
  final Object? cause;
  const TFLiteServiceException(this.message, {this.cause});
}

class ImagePreprocessorException implements Exception { ... }
class TensorConverterException implements Exception { ... }
class ClassificationException implements Exception { ... }
```

### 5.2 Exception Wrapping
Layer yang lebih luar harus catch exception dari layer yang lebih dalam dan wrap ke exception-nya sendiri:
```dart
// ✅ BENAR — TFLiteLocalDataSourceImpl wraps exceptions dari core ML
on TFLiteServiceException catch (error) {
  throw ClassificationException('TensorFlow Lite operation failed.', cause: error);
} on ImagePreprocessorException catch (error) {
  throw ClassificationException('Image preprocessing failed.', cause: error);
}
```

### 5.3 Jangan Swallow Exceptions
```dart
// ❌ SALAH
try { ... } catch (e) { } // kosong, tanpa rethrow/logging

// ✅ BENAR — minimal rethrow atau emit error state
} catch (error) {
  emit(ClassificationError(error.toString()));
}
```

### 5.4 Validasi Input
Validasi input di awal fungsi sebelum operasi:
```dart
if (imageBytes.isEmpty) {
  throw const ClassificationException('Image input is empty.');
}
if (std == 0) {
  throw const TensorConverterException('Normalization std cannot be zero.');
}
```

---

## 6. ML Pipeline Conventions

### 6.1 Preprocessing Pipeline Order (WAJIB)
Urutan preprocessing tidak boleh diubah:
1. `replaceBackgroundWithWhite()` — canvas background (0xFFF7F9FC) → pure white
2. `cropToDrawing()` — deteksi foreground pixel, crop ke bounding box
3. `centerToSquare()` — center drawing di dalam canvas persegi
4. `resize(targetWidth, targetHeight)` — resize ke input size model
5. `toGrayscaleIfNeeded()` — hanya jika model input channels == 1

### 6.2 Background Color (HARDCODED)
Background color canvas `0xFFF7F9FC` (R=247, G=249, B=252) adalah konstanta desain yang wajib konsisten antara:
- `DrawingCanvas.backgroundColor` property
- `ImagePreprocessor.cropToDrawing()` dan `replaceBackgroundWithWhite()` default params

### 6.3 Normalization
Selalu gunakan konstanta dari `AppConstants`:
```dart
// ✅ BENAR
mean: AppConstants.defaultNormalizationMean,  // 127.5
std: AppConstants.defaultNormalizationStd,    // 127.5

// ❌ SALAH — jangan hardcode langsung
mean: 127.5, std: 127.5,
```

### 6.4 TFLite Input/Output via ByteBuffer
Gunakan raw `Uint8List` (ByteBuffer) saat memanggil interpreter untuk menghindari type conversion errors:
```dart
// ✅ BENAR — TFLiteService sudah handle ini secara internal
final inputBytes = flatInput.buffer.asUint8List();
interpreter.run(inputBytes, outputBytes);
```

---

## 7. Navigation

### 7.1 Gunakan GoRouter Exclusively
Jangan gunakan `Navigator.push` untuk navigasi antar halaman utama — semua route didefinisikan di `AppRouter`.

```dart
// ✅ BENAR
context.push('/mode', extra: {'animal': 'Kucing'});
context.go('/result', extra: { 'imageBytes': bytes, ... });

// ❌ SALAH (kecuali untuk dialog)
Navigator.push(context, MaterialPageRoute(builder: (_) => ModePage()));
```

### 7.2 Pengecualian: Pop & Dialog
`Navigator.maybePop(context)` boleh digunakan untuk tombol back dalam artboard/section.  
`showDialog()` boleh menggunakan navigator dialog biasa.

### 7.3 Extra Data Type Safety
Selalu cast extra dengan null-safe type check:
```dart
final extra = state.extra;
if (extra is Map<String, dynamic>) {
  final animal = extra['animal'] as String?;
}
```

---

## 8. Dependency Injection

### 8.1 Registrasi Scoping
| Tipe | Kapan digunakan |
|---|---|
| `registerSingleton` | Instance yang harus diinit secara async sebelum app start (TFLiteService, SharedPreferences) |
| `registerLazySingleton` | Services/repositories yang cukup dibuat sekali dan di-share (AppDatabase, ImagePreprocessor, Repository) |
| `registerFactory` | Object yang butuh instance baru setiap kali (UseCases, BLoC, Cubit, Controller) |
| `registerFactoryParam` | Factory yang membutuhkan runtime parameter (DrawingCubit membutuhkan DrawingController) |

### 8.2 Feature Injection Files
Setiap fitur yang memiliki DI harus memiliki file `injection.dart` tersendiri:
```dart
// features/classification/injection.dart
Future<void> initClassificationFeature(GetIt sl) async {
  // daftarkan semua dependency fitur di sini
}
```

### 8.3 Akses DI
Gunakan global `di` instance dari `injection/injection.dart`:
```dart
import 'package:app/injection/injection.dart';
final service = di<TFLiteService>();
```

---

## 9. Widget Structure

### 9.1 Page = Thin Shell
Page widget hanya boleh berisi:
- `Scaffold` dengan `backgroundColor`
- `Center` + `FittedBox` untuk responsif landscape
- Delegate ke Section widget

```dart
// ✅ BENAR
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: HomeSceneSection(onStartPressed: () => context.push('/choose')),
        ),
      ),
    );
  }
}
```

### 9.2 Artboard Fixed Size
Semua scene sections menggunakan fixed artboard size `917 × 412` dengan `FittedBox`:
```dart
const artboardWidth = 917.0;
const artboardHeight = 412.0;

// Section di-wrap dalam SizedBox fixed size
SizedBox(width: artboardWidth, height: artboardHeight, child: ...)
```

### 9.3 RepaintBoundary
Setiap section yang melakukan capture (`DrawingCanvas`) atau yang merupakan artboard statis harus di-wrap `RepaintBoundary` untuk optimasi rendering.

### 9.4 Composability
- **Section** = artboard-level, satu per page
- **Widget** = komponen reusable yang dipakai di dalam section
- Section tidak boleh di-embed di dalam widget lain (kecuali page)

---

## 10. Theme & Styling

### 10.1 Selalu Gunakan Token
```dart
// ✅ BENAR
color: AppColors.primary,
style: AppTextStyles.displayLarge,
padding: EdgeInsets.all(AppSpacing.md),

// ❌ SALAH — jangan hardcode nilai
color: Color(0xFF4285F4),
fontSize: 40,
padding: EdgeInsets.all(16),
```

### 10.2 copyWith untuk Variasi
```dart
// ✅ BENAR — gunakan copyWith untuk modifikasi minor
style: AppTextStyles.displayMedium.copyWith(
  color: AppColors.primary,
  fontWeight: FontWeight.w800,
),
```

---

## 11. Const Constructors

```dart
// ✅ BENAR — gunakan const kapanpun bisa
const ImagePreprocessor()
const TensorConverter()
const PredictionEntity(...)
const ClassificationInitial()

// ❌ SALAH — jangan buat non-const jika tidak perlu mutasi
ImagePreprocessor() // tanpa const
```

---

## 12. Asset References

Gunakan konstanta dari `AppConstants` atau `AppAssets`, jangan hardcode string path asset:
```dart
// ✅ BENAR
AppConstants.modelAssetPath   // 'assets/models/sketch_model.tflite'
AppConstants.labelsAssetPath  // 'assets/models/labels.txt'

// ❌ SALAH
'assets/models/sketch_model.tflite' // hardcoded langsung di kode bisnis
```

---

## 13. Debugging & Logging

Print statement untuk debugging diperbolehkan selama development dengan pattern ini:
```dart
try {
  print('ClassName.methodName: info=$value');
} catch (_) {} // jangan crash jika logging gagal
```

> **Catatan:** Sebelum production release, semua `print()` harus diganti dengan logging library yang proper atau dihapus.

---

## 14. Code Generation

Project menggunakan code generation:
- **Drift:** `app_database.g.dart` — generate dari `app_database.dart`
- **Freezed / JsonSerializable:** (tersedia, gunakan untuk DTO kompleks jika dibutuhkan)

Setelah modifikasi file yang memerlukan code gen, jalankan:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Commit file generated (`*.g.dart`, `*.freezed.dart`) ke repository.
