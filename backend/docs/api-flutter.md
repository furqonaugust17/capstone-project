# API Documentation - Flutter Game (Player App)

Dokumentasi ini berisi panduan lengkap integrasi API backend untuk aplikasi **Educational Animal Drawing Game** berbasis Flutter. Hanya mencakup endpoint yang dibutuhkan oleh player (`role: USER`).

> **Terakhir diperbarui**: 22 Juni 2026

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

> **Catatan Caching**: Beberapa endpoint GET di-cache oleh Redis di sisi server (`/animals`, `/ml-models/active`, `/leaderboards`). Data yang di-cache akan otomatis di-invalidasi ketika ada perubahan data terkait, sehingga Flutter tidak perlu menangani logika ini.

---

## 1️⃣ Authentication (`/api/auth`)

### Register
- **Method**: `POST /auth/register`
- **Auth**: ❌ Tidak perlu
- **Rate Limit**: 10 request / 15 menit per IP
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
- **Rate Limit**: 10 request / 15 menit per IP
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
- **Cache**: ✅ 5 menit (server-side Redis)
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
- **Cache**: ✅ 10 menit (server-side Redis)
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
    "activatedAt": "2026-06-20T...",
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
- **Format**: `multipart/form-data`
- **Fields**:
  - `animalId`: UUID valid (wajib)
  - `modelId`: UUID valid (wajib)
  - `predictionLabel`: string (wajib)
  - `confidenceScore`: float 0.0 - 1.0 (wajib)
  - `gameScore`: integer (wajib)
  - `focusScore`: float (opsional)
  - `drawingDuration`: integer dalam detik (wajib)
  - `startedAt`: ISO 8601 datetime (wajib)
  - `file`: file image hasil gambar (opsional, max 2MB)
- **Side Effects**:
  - Nilai `gameScore` otomatis ditambahkan ke `totalPoint` pada profil user.
  - `UserStatistic` (totalGames, highestScore, averageFocus, dll) diperbarui secara otomatis.
  - `LearningProfile` untuk hewan terkait diperbarui (adaptive learning).
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
    "imageUrl": "https://...",
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

## 5️⃣ Statistics (`/api/statistics`)

Digunakan untuk menampilkan statistik pribadi pemain.

### Get My Statistics
- **Method**: `GET /statistics/my`
- **Auth**: ✅ Required
- **Response** (`data`):
  ```json
  {
    "userId": "uuid",
    "totalGames": 42,
    "totalScore": 3500,
    "highestScore": 200,
    "averageFocus": 0.78,
    "totalDrawingTime": 1890,
    "updatedAt": "2026-06-22T..."
  }
  ```
- **Catatan Flutter**: Data ini terupdate otomatis setiap kali pemain menyelesaikan game session. Tidak perlu submit manual.

---

## 6️⃣ Shop (`/api/shop`)

Digunakan untuk menampilkan item yang bisa dibeli pemain menggunakan point.

### Get All Shop Items
- **Method**: `GET /shop`
- **Auth**: ✅ Required
- **Query Params**: `?page=1&limit=10&category=AVATAR&rarity=RARE`
  - `category`: opsional, filter berdasarkan kategori (`AVATAR`, `FRAME`, `STICKER`, `THEME`)
  - `rarity`: opsional, filter berdasarkan kelangkaan (`COMMON`, `RARE`, `EPIC`, `LEGENDARY`)
- **Response** (`data`): Pagination object berisi array `ShopItem`.
- **Contoh item**:
  ```json
  {
    "id": "uuid",
    "name": "Golden Frame",
    "description": "A premium golden frame for your profile.",
    "imageUrl": "https://...",
    "price": 500,
    "category": "FRAME",
    "rarity": "EPIC",
    "isActive": true,
    "createdAt": "2026-06-12T...",
    "updatedAt": "2026-06-12T..."
  }
  ```

### Get Shop Item Detail
- **Method**: `GET /shop/:id`
- **Auth**: ✅ Required
- **Response** (`data`): Objek `ShopItem` tunggal.

---

## 7️⃣ Purchase (`/api/purchase`)

Digunakan untuk membeli item dari shop menggunakan point.

### Buy Item
- **Method**: `POST /purchase/:itemId`
- **Auth**: ✅ Required
- **Response** (`data`): Objek `PurchaseHistory`.
- **Side Effects**:
  - `totalPoint` pada user dikurangi sesuai harga item.
  - Item ditambahkan ke `UserInventory`.
- **Error Cases**:
  - `400`: Poin tidak cukup ("Insufficient points")
  - `404`: Item tidak ditemukan

---

## 8️⃣ Inventory (`/api/inventory`)

Digunakan untuk menampilkan item yang dimiliki pemain.

### Get My Inventory
- **Method**: `GET /inventory`
- **Auth**: ✅ Required
- **Response** (`data`): Array objek `UserInventory` beserta relasi `shopItem`.

### Get My Purchase History
- **Method**: `GET /inventory/history`
- **Auth**: ✅ Required
- **Response** (`data`): Array objek `PurchaseHistory` beserta relasi `shopItem`.

---

## 9️⃣ Leaderboard (`/api/leaderboards`)

Digunakan untuk menampilkan peringkat pemain.

### Get Live Leaderboard
- **Method**: `GET /leaderboards/live`
- **Auth**: ✅ Required
- **Query Params**: `?limit=100` (opsional, default 100)
- **Cache**: ✅ 1 menit (server-side Redis)
- **Response** (`data`): Array user diurutkan berdasarkan `totalScore` tertinggi.
- **Contoh item**:
  ```json
  {
    "userId": "uuid",
    "totalScore": 5000,
    "totalGames": 50,
    "user": {
      "username": "player1",
      "displayName": "Player One",
      "avatarUrl": "https://..."
    }
  }
  ```

### Get My Rank
- **Method**: `GET /leaderboards/me`
- **Auth**: ✅ Required
- **Response** (`data`):
  ```json
  {
    "rank": 5,
    "totalScore": 3500,
    "totalGames": 42
  }
  ```

### Get Leaderboard Snapshot
- **Method**: `GET /leaderboards/snapshot`
- **Auth**: ✅ Required
- **Query Params**: `?period=WEEKLY&periodLabel=2026-W25` (wajib)
  - `period`: `WEEKLY`, `MONTHLY`, `SEASONAL`, `ALL_TIME`
  - `periodLabel`: label periode (cth: `2026-W25`, `2026-06`, `Season-1`)
- **Cache**: ✅ 1 jam (server-side Redis)
- **Response** (`data`): Objek `LeaderboardSnapshot` berisi `rankings` (JSON array).

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
| `activatedAt` | datetime? | Waktu terakhir model diaktifkan |
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
| `imageUrl` | string? | URL gambar hasil karya |
| `startedAt` | datetime | Waktu mulai menggambar |
| `finishedAt` | datetime | Waktu selesai (otomatis) |

### UserStatistic
| Field | Type | Keterangan |
|---|---|---|
| `userId` | string (UUID) | Primary key (FK ke User) |
| `totalGames` | int | Jumlah total permainan |
| `totalScore` | int | Akumulasi total skor |
| `highestScore` | int | Skor tertinggi sepanjang masa |
| `averageFocus` | float | Rata-rata focus score |
| `totalDrawingTime` | int | Total waktu menggambar (detik) |
| `updatedAt` | datetime | Terakhir diupdate |

### ShopItem
| Field | Type | Keterangan |
|---|---|---|
| `id` | string (UUID) | Primary key |
| `name` | string | Nama item |
| `description` | string? | Deskripsi |
| `imageUrl` | string? | URL gambar item |
| `price` | int | Harga dalam point |
| `category` | enum | `AVATAR`, `FRAME`, `STICKER`, `THEME` |
| `rarity` | enum | `COMMON`, `RARE`, `EPIC`, `LEGENDARY` |
| `isActive` | boolean | Status aktif |


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
│  2. GET /ml-models/active (cached 10 menit)             │
│     ├─ Bandingkan version dengan cache lokal             │
│     ├─ Jika beda → Download fileUrl ke local storage     │
│     └─ Simpan daftar animalModels sebagai label map      │
│                                                         │
│  3. GET /animals?limit=100 (cached 5 menit)             │
│     └─ Simpan daftar hewan untuk UI pemilihan            │
│                                                         │
│  4. GET /statistics/my                                  │
│     └─ Tampilkan statistik pribadi pemain                │
├─────────────────────────────────────────────────────────┤
│                    GAMEPLAY                             │
│                                                         │
│  5. User pilih hewan → Catat startedAt                  │
│  6. User menggambar → Hitung drawingDuration            │
│  7. Jalankan inferensi TFLite lokal                     │
│     └─ Dapat predictionLabel & confidenceScore          │
│  8. Hitung gameScore berdasarkan bisnis logic           │
│  9. POST /game-sessions (submit hasil)                  │
│      └─ Side effect: update point, stats                │
├─────────────────────────────────────────────────────────┤
│                    SOCIAL & SHOP                        │
│                                                         │
│  10. GET /leaderboards/live (peringkat real-time)       │
│  11. GET /leaderboards/me (ranking pribadi)             │
│  12. GET /shop (daftar item toko)                       │
│  13. POST /purchase/:itemId (beli item)                 │
│  14. GET /inventory (item yang dimiliki)                │
├─────────────────────────────────────────────────────────┤
│                    HISTORY                              │
│                                                         │
│  15. GET /game-sessions (riwayat bermain)               │
│  16. GET /auth/me (lihat totalPoint terbaru)            │
└─────────────────────────────────────────────────────────┘
```

---

## ⚠️ Error Codes yang Umum

| Code | Kondisi | Aksi Flutter |
|---|---|---|
| `400` | Validasi gagal / Poin tidak cukup | Tampilkan pesan error dari `message` |
| `401` | Token expired / invalid | Panggil `POST /auth/refresh`, jika gagal → redirect ke Login |
| `403` | Akses ditolak (bukan pemilik data) | Tampilkan pesan error |
| `404` | Data tidak ditemukan | Tampilkan empty state |
| `409` | Email/username sudah terdaftar (saat register) | Tampilkan pesan validasi |
| `429` | Rate limit tercapai (terlalu banyak request) | Tampilkan pesan "Coba lagi nanti" |
| `500` | Internal server error | Tampilkan pesan error generik |
