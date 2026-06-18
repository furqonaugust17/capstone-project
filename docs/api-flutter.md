# API Documentation - Flutter Game (Player App)

Dokumentasi ini berisi panduan lengkap integrasi API backend untuk aplikasi **Educational Animal Drawing Game** berbasis Flutter. Hanya mencakup endpoint yang dibutuhkan oleh player (`role: USER`).

> **Terakhir diperbarui**: 12 Juni 2026

---

## 📌 Base Configuration

| Item | Value |
|---|---|
| **Base URL** | `http://<IP_SERVER>:3001/api` |
| **Content-Type** | `application/json` |
| **Auth Header** | `Authorization: Bearer <ACCESS_TOKEN>` |
| **Naming Convention** | Semua field menggunakan **camelCase** (contoh: `createdAt`, `isActive`, `totalPoint`) |

### Standard Success Response
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Operation successful",
  "data": { ... }
}
```

### Standard Error Response
```json
{
  "success": false,
  "statusCode": 401,
  "message": "Invalid email or password",
  "errors": null
}
```

### Pagination Response
Endpoint yang mendukung paginasi mengembalikan format berikut di dalam `data`:
```json
{
  "data": [ ... ],
  "meta": {
    "total": 50,
    "page": 1,
    "limit": 10,
    "totalPages": 5
  }
}
```

---

## 1️⃣ Authentication (`/api/auth`)

### Register
- **Method**: `POST /auth/register`
- **Auth**: ❌ Tidak perlu
- **Request Body**:
  ```json
  {
    "username": "player1",
    "email": "player1@example.com",
    "password": "secretpassword",
    "displayName": "Player One"
  }
  ```
- **Validation**:
  - `username`: min 3 karakter, max 50
  - `email`: format email valid
  - `password`: min 6 karakter
  - `displayName`: opsional, max 50 karakter
- **Response** (`data`):
  ```json
  {
    "id": "uuid",
    "username": "player1",
    "email": "player1@example.com",
    "displayName": "Player One",
    "avatarUrl": null,
    "totalPoint": 0,
    "role": "USER",
    "createdAt": "2026-06-12T...",
    "updatedAt": "2026-06-12T..."
  }
  ```

### Login
- **Method**: `POST /auth/login`
- **Auth**: ❌ Tidak perlu
- **Request Body**:
  ```json
  {
    "email": "player1@example.com",
    "password": "secretpassword"
  }
  ```
- **Response** (`data`):
  ```json
  {
    "user": {
      "id": "uuid",
      "username": "player1",
      "email": "player1@example.com",
      "displayName": "Player One",
      "avatarUrl": null,
      "totalPoint": 0,
      "role": "USER",
      "createdAt": "2026-06-12T...",
      "updatedAt": "2026-06-12T..."
    },
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
  }
  ```
- **Catatan Flutter**: Simpan `accessToken` dan `refreshToken` ke Secure Storage.

### Refresh Token
- **Method**: `POST /auth/refresh`
- **Auth**: ❌ Tidak perlu
- **Request Body**:
  ```json
  {
    "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
  }
  ```
- **Response** (`data`):
  ```json
  {
    "accessToken": "NEW_ACCESS_TOKEN"
  }
  ```
- **Catatan Flutter**: Panggil endpoint ini secara otomatis ketika `accessToken` kedaluwarsa (HTTP 401). Implementasikan di *interceptor* Dio.

### Get My Profile
- **Method**: `GET /auth/me`
- **Auth**: ✅ Required
- **Response** (`data`): Objek `User` lengkap (tanpa `passwordHash`).

### Logout
- **Method**: `POST /auth/logout`
- **Auth**: ✅ Required
- **Request Body**:
  ```json
  {
    "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
  }
  ```

---

## 2️⃣ Animals (`/api/animals`)

Digunakan untuk menampilkan daftar hewan yang tersedia untuk digambar.

### Get All Animals
- **Method**: `GET /animals`
- **Auth**: ✅ Required
- **Query Params**: `?page=1&limit=10`
- **Response** (`data`): Pagination object berisi array `Animal`.
- **Contoh item**:
  ```json
  {
    "id": "uuid",
    "name": "Cat",
    "description": "A small domesticated carnivorous mammal with soft fur.",
    "thumbnailUrl": "https://capstone-image.furqonaugust.site/animals/thumbnails/uuid.png",
    "hintImageUrl": "https://capstone-image.furqonaugust.site/animals/hints/uuid.png",
    "isActive": true,
    "createdAt": "2026-06-12T...",
    "updatedAt": "2026-06-12T..."
  }
  ```
- **Catatan Flutter**: Hanya hewan dengan `isActive: true` yang dikembalikan oleh API.

### Get Animal Detail
- **Method**: `GET /animals/:id`
- **Auth**: ✅ Required
- **Response** (`data`): Objek `Animal` tunggal.

---

## 3️⃣ ML Models (`/api/ml-models`)

Digunakan untuk mengunduh model TFLite yang akan mendeteksi hasil gambar pemain.

### ⭐ Get Active Model (WAJIB dipanggil saat aplikasi dimulai)
- **Method**: `GET /ml-models/active`
- **Auth**: ✅ Required
- **Response** (`data`):
  ```json
  {
    "id": "uuid",
    "name": "CNN Sketch Animal",
    "version": "1.0.0",
    "fileUrl": "https://capstone-image.furqonaugust.site/models/CNN_Sketch_Animal-v1.0.0.tflite",
    "labelsUrl": null,
    "inputSize": 224,
    "framework": null,
    "accuracy": 92.5,
    "isActive": true,
    "firebaseModelName": null,
    "createdAt": "2026-06-12T...",
    "updatedAt": "2026-06-12T...",
    "animalModels": [
      {
        "id": "uuid",
        "animalId": "uuid",
        "modelId": "uuid",
        "createdAt": "2026-06-12T...",
        "animal": {
          "id": "uuid",
          "name": "Cat",
          "description": "...",
          "thumbnailUrl": "https://...",
          "hintImageUrl": "https://...",
          "isActive": true,
          "createdAt": "2026-06-12T...",
          "updatedAt": "2026-06-12T..."
        }
      }
    ]
  }
  ```

#### Panduan Integrasi Flutter:

1. **Splash Screen / Loading**: Panggil `GET /ml-models/active`.
2. **Download TFLite**: Unduh file dari `fileUrl` ke local storage perangkat.
3. **Input Size**: Gunakan `inputSize` (misal: 224) sebagai dimensi preprocessing gambar sebelum inferensi.
4. **Label Mapping**: Baca array `animalModels` → ambil `animal.name` dari setiap item untuk mencocokkan output klasifikasi model ke nama hewan yang benar.
5. **Caching**: Simpan `version` di SharedPreferences. Saat aplikasi dibuka, bandingkan dengan versi dari API. Jika sama, gunakan file lokal. Jika berbeda, unduh ulang.

---

## 4️⃣ Game Sessions (`/api/game-sessions`)

Digunakan untuk menyimpan hasil dan riwayat permainan setiap kali pemain selesai menggambar.

### Submit Game Result
- **Method**: `POST /game-sessions`
- **Auth**: ✅ Required
- **Request Body**:
  ```json
  {
    "animalId": "uuid-hewan-target",
    "modelId": "uuid-ml-model-aktif",
    "predictionLabel": "Cat",
    "confidenceScore": 0.95,
    "gameScore": 150,
    "focusScore": 0.85,
    "drawingDuration": 45,
    "startedAt": "2026-06-12T10:30:00.000Z"
  }
  ```
- **Validation**:
  - `animalId`, `modelId`: UUID valid (wajib)
  - `predictionLabel`: string (wajib)
  - `confidenceScore`: float 0.0 - 1.0
  - `gameScore`: integer (wajib)
  - `focusScore`: float, opsional
  - `drawingDuration`: integer dalam detik (wajib)
  - `startedAt`: ISO 8601 datetime (wajib)
- **Side Effect**: Nilai `gameScore` otomatis ditambahkan ke `totalPoint` pada profil user (menggunakan database transaction).
- **Response** (`data`): Objek `GameSession` yang baru dibuat.

#### Panduan Integrasi Flutter:

```
Waktu mulai gambar → catat DateTime.now() → startedAt
Selesai gambar → hitung durasi → drawingDuration (detik)
Jalankan inferensi TFLite → predictionLabel + confidenceScore
Hitung skor game berdasarkan logika bisnis → gameScore
Submit ke endpoint POST /game-sessions
```

### Get My Drawing History
- **Method**: `GET /game-sessions`
- **Auth**: ✅ Required
- **Query Params**: `?page=1&limit=10`
- **Response** (`data`): Pagination object berisi array `GameSession`.
- **Contoh item**:
  ```json
  {
    "id": "uuid",
    "userId": "uuid",
    "animalId": "uuid",
    "modelId": "uuid",
    "predictionLabel": "Cat",
    "confidenceScore": 0.87,
    "gameScore": 85,
    "focusScore": 0.72,
    "drawingDuration": 38,
    "startedAt": "2026-06-12T10:29:00.000Z",
    "finishedAt": "2026-06-12T10:30:00.000Z",
    "createdAt": "2026-06-12T10:30:00.000Z",
    "animal": {
      "id": "uuid",
      "name": "Cat",
      "thumbnailUrl": "https://..."
    },
    "model": {
      "id": "uuid",
      "name": "CNN Sketch Animal",
      "version": "1.0.0"
    }
  }
  ```

### Get Session Detail
- **Method**: `GET /game-sessions/:id`
- **Auth**: ✅ Required
- **Akses**: Hanya pemilik session yang bisa melihat (jika bukan miliknya → `403 Forbidden`).
- **Response** (`data`): Objek `GameSession` lengkap beserta relasi `animal` dan `model`.

---

## 📎 Data Models Reference

### User
| Field | Type | Keterangan |
|---|---|---|
| `id` | string (UUID) | Primary key |
| `username` | string | Unique |
| `email` | string | Unique |
| `displayName` | string? | Nama tampilan |
| `avatarUrl` | string? | URL avatar |
| `totalPoint` | int | Akumulasi skor game |
| `role` | enum | `USER` / `ADMIN` |
| `createdAt` | datetime | - |
| `updatedAt` | datetime | - |

### Animal
| Field | Type | Keterangan |
|---|---|---|
| `id` | string (UUID) | Primary key |
| `name` | string | Nama hewan |
| `description` | string? | Deskripsi |
| `thumbnailUrl` | string? | URL gambar thumbnail |
| `hintImageUrl` | string? | URL gambar petunjuk |
| `isActive` | boolean | Status aktif |
| `createdAt` | datetime | - |
| `updatedAt` | datetime | - |

### MLModel
| Field | Type | Keterangan |
|---|---|---|
| `id` | string (UUID) | Primary key |
| `name` | string | Nama model |
| `version` | string | Versi model |
| `fileUrl` | string | URL file .tflite di Cloudflare R2 |
| `inputSize` | int? | Dimensi input (misal: 224) |
| `accuracy` | float? | Akurasi model (0-100) |
| `isActive` | boolean | Apakah model yang sedang aktif |
| `animalModels` | array | Relasi hewan yang didukung model |

### GameSession
| Field | Type | Keterangan |
|---|---|---|
| `id` | string (UUID) | Primary key |
| `userId` | string (UUID) | Foreign key ke User |
| `animalId` | string (UUID) | Hewan target yang digambar |
| `modelId` | string (UUID) | Model yang digunakan |
| `predictionLabel` | string | Hasil klasifikasi model |
| `confidenceScore` | float | Confidence (0.0 - 1.0) |
| `gameScore` | int | Skor yang didapat |
| `focusScore` | float? | Skor fokus (opsional) |
| `drawingDuration` | int | Durasi menggambar (detik) |
| `startedAt` | datetime | Waktu mulai menggambar |
| `finishedAt` | datetime | Waktu selesai (otomatis) |

---

## 🔄 Flow Integrasi Game (End-to-End)

```
┌─────────────────────────────────────────────────────────┐
│                    APP LAUNCH                           │
│                                                         │
│  1. Cek token di Secure Storage                         │
│     ├─ Ada → GET /auth/me (validasi session)            │
│     └─ Tidak ada → Tampilkan Login Screen               │
│                                                         │
│  2. GET /ml-models/active                               │
│     ├─ Bandingkan version dengan cache lokal             │
│     ├─ Jika beda → Download fileUrl ke local storage     │
│     └─ Simpan daftar animalModels sebagai label map      │
│                                                         │
│  3. GET /animals?limit=100                              │
│     └─ Simpan daftar hewan untuk UI pemilihan            │
├─────────────────────────────────────────────────────────┤
│                    GAMEPLAY                             │
│                                                         │
│  4. User pilih hewan → Catat startedAt                  │
│  5. User menggambar → Hitung drawingDuration            │
│  6. Jalankan inferensi TFLite lokal                     │
│     └─ Dapat predictionLabel & confidenceScore          │
│  7. Hitung gameScore berdasarkan bisnis logic           │
│  8. POST /game-sessions (submit hasil)                  │
├─────────────────────────────────────────────────────────┤
│                    HISTORY                              │
│                                                         │
│  9. GET /game-sessions (riwayat bermain)                │
│  10. GET /auth/me (lihat totalPoint terbaru)            │
└─────────────────────────────────────────────────────────┘
```

---

## ⚠️ Error Codes yang Umum

| Code | Kondisi | Aksi Flutter |
|---|---|---|
| `401` | Token expired / invalid | Panggil `POST /auth/refresh`, jika gagal → redirect ke Login |
| `403` | Akses ditolak (bukan pemilik data) | Tampilkan pesan error |
| `404` | Data tidak ditemukan | Tampilkan empty state |
| `409` | Email/username sudah terdaftar (saat register) | Tampilkan pesan validasi |
| `500` | Internal server error | Tampilkan pesan error generik |
