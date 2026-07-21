# Architecture Documentation

> **Project:** Educational Animal Drawing App  
> **Framework:** Flutter (Dart)  
> **SDK:** ^3.11.4  
> **Orientation:** Landscape-only  
> **Last updated:** 2026-06-07

---

## 1. Overview

Aplikasi ini adalah **educational drawing game** berbasis Flutter yang mengajarkan anak-anak menggambar hewan menggunakan kanvas digital. Setelah selesai menggambar, gambar diklasifikasikan secara **on-device** menggunakan model TensorFlow Lite (MobileNetV2-based) untuk memberikan skor kemiripan.

### Tech Stack

| Layer | Teknologi |
|---|---|
| UI Framework | Flutter / Material 3 |
| State Management | flutter_bloc (BLoC + Cubit) |
| Navigation | go_router |
| Dependency Injection | get_it |
| ML Inference | tflite_flutter |
| Local Database | Drift (SQLite via sqflite) |
| Drawing Persistence | SharedPreferences (JSON) |
| Image Processing | package:image |
| Code Generation | freezed, json_serializable, drift_dev |

---

## 2. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Presentation Layer                        │
│  Pages → Sections → Widgets  │  BLoC / Cubit  │  Controllers   │
├─────────────────────────────────────────────────────────────────┤
│                         Domain Layer                             │
│         Entities  │  Repositories (abstract)  │  UseCases      │
├─────────────────────────────────────────────────────────────────┤
│                          Data Layer                              │
│     Data Sources (Local)  │  Models  │  Repository Impls       │
├─────────────────────────────────────────────────────────────────┤
│                           Core Layer                             │
│   ML Pipeline  │  Database  │  Theme  │  Constants  │  Env     │
└─────────────────────────────────────────────────────────────────┘
```

Arsitektur mengikuti **Clean Architecture** dengan pemisahan layer yang ketat:
- Dependency mengalir ke dalam: Presentation → Domain ← Data
- Domain layer tidak bergantung pada framework eksternal apapun
- Core layer menyediakan utilitas shared yang digunakan lintas fitur

---

## 3. Directory Structure

```
lib/
├── main.dart                        # Entry point, orientasi, DI bootstrap
├── routes/
│   └── app_router.dart              # GoRouter konfigurasi semua route
├── injection/
│   └── injection.dart               # Root DI: core singletons + feature modules
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # Model path, input size, normalization params
│   ├── database/
│   │   ├── app_database.dart        # Drift DB definition
│   │   ├── app_database.g.dart      # Generated Drift code
│   │   └── tables.dart              # Drift table definitions (Scores)
│   ├── env/
│   │   └── environment.dart         # Flavor enum + API base URLs
│   ├── ml/
│   │   ├── tflite_service.dart      # TFLite interpreter wrapper + inference
│   │   ├── image_preprocessor.dart  # Image decode, crop, resize, normalize
│   │   └── tensor_converter.dart    # Float32 tensor creation + validation
│   ├── theme/
│   │   ├── app_theme.dart           # ThemeData (Material 3)
│   │   ├── app_colors.dart          # Semantic color tokens
│   │   ├── app_text_styles.dart     # TextStyle definitions
│   │   ├── app_typography.dart      # Font family + weight constants
│   │   ├── app_spacing.dart         # Spacing scale (xs → xxl)
│   │   ├── app_radius.dart          # Border radius scale
│   │   ├── app_shadows.dart         # Box shadow definitions
│   │   ├── app_dimensions.dart      # Dimension constants (appBar, button, icon)
│   │   └── app_assets.dart          # Asset path constants
│   └── utils/
│       └── image_preprocessor.dart  # Legacy/utility version
│
├── features/
│   ├── home/                        # Landing / splash screen
│   ├── choose/                      # Pilih hewan screen
│   ├── mode/                        # Pilih mode (thicken / free draw)
│   ├── drawing/                     # Drawing canvas + persistence
│   ├── classification/              # TFLite inference + scoring
│   └── result/                      # Tampilan hasil skor
│
└── shared/
    └── widgets/
        ├── placeholder_page.dart
        └── primary_button.dart
```

---

## 4. Feature Modules

Setiap fitur mengikuti struktur **3-layer Clean Architecture**:

```
features/<name>/
├── data/
│   ├── datasources/    # Implementasi akses data (local/remote)
│   ├── models/         # Data models (extends domain entities)
│   └── repositories/   # Implementasi repository interface
├── domain/
│   ├── entities/       # Pure Dart domain objects
│   ├── repositories/   # Abstract repository interfaces
│   └── usecases/       # Business logic operations
├── presentation/
│   ├── bloc/ atau cubit/  # State management
│   ├── pages/          # Full-screen routes
│   ├── sections/       # Artboard/scene-level widgets
│   └── widgets/        # Komponen UI reusable
└── injection.dart      # Feature-level DI setup
```

### 4.1 Feature: `home`
- **Presentasi saja** — tidak ada domain/data layer
- `HomePage` → `HomeSceneSection` → navigasi ke `/choose`

### 4.2 Feature: `choose`
- **Presentasi saja** — tidak ada domain/data layer
- `ChooseAnimalPage` → `ChooseSceneSection`
- Artboard fixed size 917×412 dengan `FittedBox` untuk responsif
- 5 pilihan hewan: Kucing, Sapi, Bebek, Ikan, Lumba-Lumba
- Navigasi ke `/mode` dengan parameter `animal`

### 4.3 Feature: `mode`
- **Presentasi saja** — tidak ada domain/data layer
- `ModePage` → `ModeSceneSection`
- 2 mode: `thicken` (Ayo Tebalkan!) dan `free` (Gambar Sendiri!)
- Navigasi ke `/drawing` dengan parameter `animal` + `mode`

### 4.4 Feature: `drawing`
- **Full Clean Architecture** dengan 3 layer
- **Domain Entities:** `Stroke`, `Point`, `Brush` (+ `ToolType` enum)
- **Domain Repository:** `DrawingRepository` (save/load/clear)
- **Domain UseCases:** `SaveDrawingUseCase`, `LoadDrawingUseCase`, `ClearDrawingUseCase`
- **Data Model:** `StrokeModel extends Stroke` — serializable ke JSON
- **Data Source:** `DrawingLocalDataSourceImpl` via SharedPreferences
- **Presentation Cubit:** `DrawingCubit` — mengatur save/load/clear/undo/setBrush
- **Controller:** `DrawingController extends ChangeNotifier` — mengelola `ValueNotifier<List<Stroke>>` dan `ValueNotifier<Stroke?>` untuk current stroke
- **Painter:** `SketchPainter extends CustomPainter` — quadratic bezier rendering
- **Canvas:** `DrawingCanvas` — `RepaintBoundary` + `GestureDetector` + image capture

### 4.5 Feature: `classification`
- **Full Clean Architecture** dengan 3 layer
- **Domain Entity:** `PredictionEntity` (label, confidence, rawScores, inferenceDuration)
- **Domain Repository:** `ClassificationRepository` (classifySketch, warmUpModel)
- **Domain UseCase:** `ClassifySketchUseCase` + `ClassifySketchParams`
- **Data Model:** `PredictionModel extends PredictionEntity`
- **Data Source:** `TFLiteLocalDataSourceImpl` — orkestrasi ML pipeline lengkap
- **Presentation BLoC:** `ClassificationBloc` — events: WarmUp, Requested, Reset

### 4.6 Feature: `result`
- **Presentasi saja**
- `ResultPage` → `ResultSceneSection`
- Menerima `imageBytes`, `similarityPercent`, `selectedAnimal` via GoRouter `extra`
- Artboard fixed size 917×412

---

## 5. ML Pipeline (Core + Classification Feature)

```
DrawingCanvas.captureImage()
        │  (ui.Image → rawRGBA bytes)
        ▼
ClassificationBloc ← ClassificationRequested(imageBytes, isRawRgba, width, height)
        │
        ▼
ClassifySketchUseCase.call(ClassifySketchParams)
        │
        ▼
ClassificationRepository.classifySketch()
        │
        ▼
TFLiteLocalDataSourceImpl.classifySketch()
        │
        ├─── ImagePreprocessor.preprocessFromRgba()
        │         ├── replaceBackgroundWithWhite()    (0xFFF7F9FC → white)
        │         ├── cropToDrawing()                 (foreground detection)
        │         ├── centerToSquare()                (padding to square)
        │         ├── resize(224×224)                 (model input size)
        │         └── toGrayscaleIfNeeded()
        │
        ├─── TensorConverter.toFloat32()
        │         └── normalize: (pixel - 127.5) / 127.5   → range [-1, 1]
        │
        ├─── TensorConverter.toInterpreterInputForShape()
        │         └── validate element count == shape total
        │
        └─── TFLiteService.runInference()
                  ├── flatten input → Float32List → Uint8List (ByteBuffer)
                  ├── interpreter.run(inputBytes, outputBytes)
                  └── decode outputBytes → Float32List scores
                            │
                            ▼
                    PredictionModel(label, confidence, rawScores, duration)
```

### Model Specs

| Parameter | Value |
|---|---|
| Model path | `assets/models/sketch_model.tflite` |
| Labels path | `assets/models/labels.txt` |
| Input size | 224 × 224 px |
| Input channels | 3 (RGB) |
| Output classes | 5 |
| Normalization mean | 127.5 |
| Normalization std | 127.5 |
| Inference threads | 2 |

### Label Mapping (index order dari labels.txt)

| Index | Label |
|---|---|
| 0 | Bebek |
| 1 | Ikan |
| 2 | Kucing |
| 3 | Lumba-Lumba |
| 4 | Sapi |

---

## 6. State Management

### BLoC (ClassificationBloc)

```
Events:
  ClassificationWarmUpRequested
  ClassificationRequested { imageBytes, forceGrayscale, isRawRgba, width, height }
  ClassificationResetRequested

States:
  ClassificationInitial
  ClassificationLoading
  ClassificationReady
  ClassificationSuccess { prediction: PredictionEntity }
  ClassificationError { message: String }
```

### Cubit (DrawingCubit)

```
States:
  DrawingInitial
  DrawingLoading
  DrawingSaved
  DrawingLoaded { strokes }
  DrawingCleared
  DrawingUpdated { strokes }
  DrawingBrushUpdated { brush }
  DrawingSelectedAnimalUpdated { animal }
  DrawingError { message }
```

### Controller (DrawingController extends ChangeNotifier)
Low-level state untuk rendering — menggunakan `ValueNotifier` untuk menghindari full rebuild:
- `ValueNotifier<List<Stroke>> strokes`
- `ValueNotifier<Stroke?> current`
- `ValueNotifier<Brush> brushNotifier`
- `ChangeNotifier _repaint` → trigger `AnimatedBuilder` di canvas

---

## 7. Navigation (GoRouter)

```
/           → HomePage
/choose     → ChooseAnimalPage
/mode       → ModePage      (extra: { animal: String? })
/drawing    → DrawingPage   (extra: { animal: String?, mode: String? })
/result     → ResultPage    (extra: { imageBytes, width, height, similarityPercent, animal })
```

- **`initialLocation: '/'`** — selalu mulai dari home
- Router dibuat sebagai static final di `AppRouter`
- BLoC injection dilakukan di router builder untuk `/drawing`
- Error builder menampilkan pesan error sebagai teks

---

## 8. Dependency Injection (GetIt)

```
configureDependencies()
├── Core Singletons
│   ├── AppDatabase                (LazySingleton)
│   ├── ImagePreprocessor          (LazySingleton)
│   ├── TensorConverter            (LazySingleton)
│   ├── TFLiteService              (Singleton — await init())
│   └── SharedPreferences          (Singleton — await getInstance())
│
├── classification_injection.initClassificationFeature()
│   ├── TFLiteLocalDataSource      (LazySingleton)
│   ├── ClassificationRepository   (LazySingleton)
│   ├── ClassifySketchUseCase      (Factory)
│   └── ClassificationBloc         (Factory)
│
└── drawing_injection.initDrawingFeature()
    ├── DrawingLocalDataSource     (LazySingleton)
    ├── DrawingRepository          (LazySingleton)
    ├── DrawingController          (Factory)
    ├── SaveDrawingUseCase         (Factory)
    ├── LoadDrawingUseCase         (Factory)
    ├── ClearDrawingUseCase        (Factory)
    └── DrawingCubit               (FactoryParam<DrawingController>)
```

---

## 9. Database Schema (Drift / SQLite)

### Table: `scores`

| Column | Type | Constraint |
|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT |
| label | TEXT | NOT NULL |
| confidence | REAL | NOT NULL |
| timestamp | INTEGER | NOT NULL |

> Catatan: Tabel `scores` terdefinisi namun belum sepenuhnya terintegrasi ke flow result.

---

## 10. Drawing Persistence (SharedPreferences)

Stroke data disimpan sebagai JSON string dengan key `drawing_session` (atau custom id):

```json
[
  {
    "points": [{"x": 12.5, "y": 34.0}],
    "colorValue": 4278190080,
    "strokeWidth": 6.0,
    "isEraser": false
  }
]
```

---

## 11. Theme System

| File | Konten |
|---|---|
| `app_colors.dart` | Semantic color tokens (primary, secondary, accent, background, dll.) |
| `app_text_styles.dart` | TextStyle: displayLarge → caption + button |
| `app_typography.dart` | Font family (primaryFont), font weight constants |
| `app_spacing.dart` | Spacing scale: xs, sm, md, lg, xl, xxl |
| `app_radius.dart` | Border radius: sm, md, lg |
| `app_dimensions.dart` | appBarHeight, buttonHeight, cardRadius, iconMedium, avatarMedium |

---

## 12. Asset Structure

```
assets/
├── models/
│   ├── sketch_model.tflite     # TFLite model (MobileNetV2-based)
│   └── labels.txt              # 5 kelas label
└── images/
    ├── home/                   # Aset gambar halaman home
    ├── result/                 # Aset gambar halaman result
    └── example/                # Contoh gambar per hewan (cat, cow, duck, fish, dolphin)
```

---

## 13. Platform Support

| Platform | Status |
|---|---|
| Android | ✅ Target utama |
| iOS | ✅ Didukung |
| Web | ⚠️ Folder ada, TFLite mungkin terbatas |
| Linux / macOS / Windows | ⚠️ Folder ada, belum diverifikasi |

Orientasi dikunci **landscape** via `SystemChrome.setPreferredOrientations`.
