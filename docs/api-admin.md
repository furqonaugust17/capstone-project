# API Documentation - Admin Dashboard

Dokumentasi ini ditujukan bagi tim yang membangun **Admin Web Panel**. Endpoint berikut membutuhkan *Bearer Token* dengan akses level `ADMIN`.

> **Terakhir diperbarui**: 22 Juni 2026

---

## 📌 Base Configuration
- **Base URL**: `http://<IP_SERVER>:3000/api`
- **Upload File**: Gunakan tipe `multipart/form-data` untuk unggah gambar dan `.tflite`.
- **Autentikasi**: *Bearer Token* di Header (`Authorization: Bearer <ACCESS_TOKEN>`). Jika akun tidak berstatus ADMIN, server akan merespon `403 Forbidden`.
- **API Docs (Swagger)**: Akses `GET /api/docs` untuk melihat dokumentasi interaktif Swagger UI.
- **Rate Limit**: Global 100 request / 15 menit per IP. Endpoint auth dibatasi 10 request / 15 menit.

---

## 1️⃣ Authentication (`/api/auth`)

### Admin Login
- **Endpoint**: `POST /auth/login`
- **Auth**: None
- **Rate Limit**: 10 request / 15 menit per IP
- **Catatan**: Akun admin bawaan biasanya telah di-seed di database (`admin@animaldrawing.com`).

### Verify Admin Session
- **Endpoint**: `GET /auth/me`
- **Auth**: Required

### Refresh Token
- **Endpoint**: `POST /auth/refresh`
- **Auth**: None
- **Body**: `{ "refreshToken": "..." }`
- **Catatan**: Implementasikan auto-refresh di Axios interceptor agar session tidak expired.

---

## 2️⃣ Manage Animals (`/api/animals`)

Manajemen katalog hewan dalam game.

### List All Animals
- **Endpoint**: `GET /animals`
- **Auth**: Required
- **Query Params**: `?page=1&limit=10`

### Create New Animal
- **Endpoint**: `POST /animals`
- **Auth**: Required (Admin)
- **Format**: `multipart/form-data`
- **Fields**:
  - `name` (text, wajib)
  - `description` (text, opsional)
  - `thumbnail` (file image, opsional)
  - `hintImage` (file image, opsional)

### Update Animal
- **Endpoint**: `PUT /animals/:id`
- **Auth**: Required (Admin)
- **Format**: `multipart/form-data`
- **Fields**: Sama seperti create, namun dengan parameter opsional `isActive` (boolean). File lama di R2 akan terhapus otomatis jika ada file ekstensi baru yang diunggah.

### Delete/Deactivate Animal
- **Endpoint**: `DELETE /animals/:id`
- **Auth**: Required (Admin)

---

## 3️⃣ Manage ML Models (`/api/ml-models`)

Manajemen file `TensorFlow Lite` untuk deteksi gambar AI.

### List All ML Models
- **Endpoint**: `GET /ml-models`
- **Auth**: Required (Admin)
- **Query Params**: `?page=1&limit=10`

### Get Model Detail
- **Endpoint**: `GET /ml-models/:id`
- **Auth**: Required

### Upload New TFLite Model
- **Endpoint**: `POST /ml-models`
- **Auth**: Required (Admin)
- **Format**: `multipart/form-data`
- **Fields**:
  - `name` (text, cth: "Animal CNN")
  - `version` (text, cth: "v2.0")
  - `inputSize` (number, cth: 224)
  - `accuracy` (number, cth: 88.5)
  - `file` (file `.tflite`, wajib, Max 50MB)

### Update Model
- **Endpoint**: `PUT /ml-models/:id`
- **Auth**: Required (Admin)
- **Format**: `multipart/form-data`
- **Fields**: Sama seperti create, semua opsional. File `.tflite` baru akan mengganti file lama di R2.

### Activate a Model
- **Endpoint**: `PATCH /ml-models/:id/activate`
- **Auth**: Required (Admin)
- **Deskripsi**: Menonaktifkan model aktif saat ini, dan menset model terpilih menjadi model aktif (satu-satunya yang akan diunduh oleh aplikasi Flutter). Field `activatedAt` akan ter-set secara otomatis.

### Get Model History
- **Endpoint**: `GET /ml-models/:id/history`
- **Auth**: Required (Admin)
- **Deskripsi**: Menampilkan riwayat semua versi model dengan nama yang sama, diurutkan dari yang terbaru.
- **Response** (`data`): Array objek `MLModel`.

### Rollback Model
- **Endpoint**: `POST /ml-models/:id/rollback`
- **Auth**: Required (Admin)
- **Deskripsi**: Mengaktifkan kembali model versi sebelumnya (yang pernah aktif). Menggunakan database transaction untuk memastikan atomicity.

### Sync Model Supported Animals
- **Endpoint**: `POST /ml-models/:id/animals`
- **Auth**: Required (Admin)
- **Format**: `application/json`
- **Body**:
  ```json
  {
    "animalIds": ["uuid-animal-1", "uuid-animal-2", "uuid-animal-3"]
  }
  ```
- **Deskripsi**: Menentukan (mapping) hewan apa saja yang dapat dideteksi oleh versi ML Model tersebut. Sangat krusial agar flutter tahu klasifikasi akhir hewan.

### Delete Model
- **Endpoint**: `DELETE /ml-models/:id`
- **Auth**: Required (Admin)

---

## 4️⃣ Manage Users (`/api/users`)

Manajemen akun pemain yang terdaftar.

### List All Users
- **Endpoint**: `GET /users`
- **Auth**: Required (Admin)
- **Query Params**:
  - `page`: Nomor halaman (opsional, default: 1)
  - `limit`: Jumlah data per halaman (opsional, default: 10)
  - `search`: Mencari user berdasarkan username, email, atau display name (opsional)

### Delete User
- **Endpoint**: `DELETE /users/:id`
- **Auth**: Required (Admin)
- **Catatan**: Ini akan menghapus user beserta seluruh riwayat permainannya (Cascade delete).

---

## 5️⃣ Manage Shop (`/api/shop`)

Manajemen item yang dijual di toko dalam game.

### List All Shop Items
- **Endpoint**: `GET /shop`
- **Auth**: Required
- **Query Params**: `?page=1&limit=10&category=AVATAR&rarity=RARE`

### Get Shop Item Detail
- **Endpoint**: `GET /shop/:id`
- **Auth**: Required

### Create Shop Item
- **Endpoint**: `POST /shop`
- **Auth**: Required (Admin)
- **Format**: `multipart/form-data`
- **Fields**:
  - `name` (text, wajib)
  - `description` (text, opsional)
  - `price` (number, wajib)
  - `category` (text, wajib: `AVATAR` / `FRAME` / `STICKER` / `THEME`)
  - `rarity` (text, wajib: `COMMON` / `RARE` / `EPIC` / `LEGENDARY`)
  - `file` (file image, opsional)

### Update Shop Item
- **Endpoint**: `PUT /shop/:id`
- **Auth**: Required (Admin)
- **Format**: `multipart/form-data`
- **Fields**: Sama seperti create, semua opsional. Tambahan field `isActive` (boolean).

### Delete Shop Item
- **Endpoint**: `DELETE /shop/:id`
- **Auth**: Required (Admin)

---

## 6️⃣ Manage Animal-Model Relationships (`/api/relationships`)

Manajemen mapping antara hewan dan ML Model.

### List All Relationships
- **Endpoint**: `GET /relationships`
- **Auth**: Required (Admin)

### Create Relationship
- **Endpoint**: `POST /relationships`
- **Auth**: Required (Admin)
- **Body**:
  ```json
  {
    "animalId": "uuid-animal",
    "modelId": "uuid-model"
  }
  ```

### Bulk Assign Relationships
- **Endpoint**: `POST /relationships/bulk`
- **Auth**: Required (Admin)
- **Body**:
  ```json
  {
    "modelId": "uuid-model",
    "animalIds": ["uuid-1", "uuid-2", "uuid-3"]
  }
  ```

### Delete Relationship
- **Endpoint**: `DELETE /relationships/:id`
- **Auth**: Required (Admin)

---

## 7️⃣ Statistics Dashboard (`/api/statistics`)

Statistik dan overview performa aplikasi untuk admin.

### Overview
- **Endpoint**: `GET /statistics/overview`
- **Auth**: Required (Admin)
- **Deskripsi**: Ringkasan statistik global (total users, total sessions, dll).

### Charts
- **Endpoint**: `GET /statistics/charts`
- **Auth**: Required (Admin)
- **Deskripsi**: Data yang diformat untuk grafik di dashboard.

### Detailed Statistics
- **Endpoint**: `GET /statistics/detailed`
- **Auth**: Required (Admin)
- **Deskripsi**: Statistik detail per-user atau per-animal.

---

## 8️⃣ Leaderboard Management (`/api/leaderboards`)

Manajemen leaderboard dan snapshot.

### Get Live Leaderboard
- **Endpoint**: `GET /leaderboards/live`
- **Auth**: Required
- **Query Params**: `?limit=100`

### Get Leaderboard Snapshot
- **Endpoint**: `GET /leaderboards/snapshot`
- **Auth**: Required
- **Query Params**: `?period=WEEKLY&periodLabel=2026-W25` (wajib)

### Generate Leaderboard Snapshot
- **Endpoint**: `POST /leaderboards/snapshot`
- **Auth**: Required (Admin)
- **Body**:
  ```json
  {
    "period": "WEEKLY",
    "periodLabel": "2026-W25",
    "limit": 100
  }
  ```
- **Deskripsi**: Membuat snapshot leaderboard untuk periode tertentu. Biasanya dipanggil oleh cron job.

---

## 9️⃣ Analytics Dashboard (`/api/analytics`)

Data analitik lanjutan untuk admin dashboard.

### Overview
- **Endpoint**: `GET /analytics/overview`
- **Auth**: Required (Admin)
- **Response** (`data`):
  ```json
  {
    "totalUsers": 100,
    "totalSessions": 500,
    "avgScore": 85,
    "avgFocus": 0.8
  }
  ```

### Animals Analytics
- **Endpoint**: `GET /analytics/animals`
- **Auth**: Required (Admin)
- **Deskripsi**: Statistik per hewan: total dimainkan, rata-rata skor, rata-rata confidence, hewan paling/kurang populer.
- **Response** (`data`):
  ```json
  {
    "mostPopular": { "animalId": "uuid", "animalName": "Cat", "totalPlayed": 150 },
    "leastPopular": { "animalId": "uuid", "animalName": "Elephant", "totalPlayed": 5 },
    "stats": [
      {
        "animalId": "uuid",
        "animalName": "Cat",
        "thumbnailUrl": "https://...",
        "totalPlayed": 150,
        "avgScore": 85,
        "avgConfidence": 0.82
      }
    ]
  }
  ```

### Focus Distribution
- **Endpoint**: `GET /analytics/focus`
- **Auth**: Required (Admin)
- **Deskripsi**: Distribusi focus score pemain dalam 5 range (0.0-0.2 hingga 0.8-1.0).
- **Response** (`data`):
  ```json
  {
    "distribution": {
      "0.0 - 0.2": 10,
      "0.2 - 0.4": 25,
      "0.4 - 0.6": 45,
      "0.6 - 0.8": 80,
      "0.8 - 1.0": 40
    },
    "totalTracked": 200
  }
  ```

### User Detail Analytics
- **Endpoint**: `GET /analytics/users/:id`
- **Auth**: Required (Admin)
- **Deskripsi**: Detail analitik untuk user spesifik: hewan favorit, trend skor, total waktu bermain.
- **Response** (`data`):
  ```json
  {
    "user": { "displayName": "Player One", "username": "player1" },
    "totalGames": 42,
    "totalDrawingTime": 1890,
    "averageScore": 83,
    "averageFocus": 0.78,
    "highestScore": 200,
    "favoriteAnimal": { "id": "uuid", "name": "Cat" },
    "recentTrend": [
      { "gameScore": 80, "focusScore": 0.7, "createdAt": "2026-06-20T..." },
      { "gameScore": 95, "focusScore": 0.85, "createdAt": "2026-06-21T..." }
    ]
  }
  ```

---

## 📎 Quick Reference: All Admin Endpoints

| Method | Endpoint | Deskripsi |
|---|---|---|
| `POST` | `/auth/login` | Login admin |
| `GET` | `/auth/me` | Verifikasi session |
| `POST` | `/auth/refresh` | Refresh token |
| `GET` | `/animals` | List semua hewan |
| `POST` | `/animals` | Buat hewan baru |
| `PUT` | `/animals/:id` | Update hewan |
| `DELETE` | `/animals/:id` | Hapus hewan |
| `GET` | `/ml-models` | List semua model |
| `GET` | `/ml-models/:id` | Detail model |
| `POST` | `/ml-models` | Upload model baru |
| `PUT` | `/ml-models/:id` | Update model |
| `PATCH` | `/ml-models/:id/activate` | Aktifkan model |
| `GET` | `/ml-models/:id/history` | Riwayat versi model |
| `POST` | `/ml-models/:id/rollback` | Rollback ke model lama |
| `POST` | `/ml-models/:id/animals` | Sync hewan ke model |
| `DELETE` | `/ml-models/:id` | Hapus model |
| `GET` | `/users` | List semua user |
| `DELETE` | `/users/:id` | Hapus user |
| `GET` | `/shop` | List shop items |
| `POST` | `/shop` | Buat shop item |
| `PUT` | `/shop/:id` | Update shop item |
| `DELETE` | `/shop/:id` | Hapus shop item |
| `GET` | `/achievements` | List achievements |
| `POST` | `/achievements` | Buat achievement |
| `PUT` | `/achievements/:id` | Update achievement |
| `DELETE` | `/achievements/:id` | Hapus achievement |
| `GET` | `/relationships` | List animal-model relations |
| `POST` | `/relationships` | Buat relasi |
| `POST` | `/relationships/bulk` | Bulk assign relasi |
| `DELETE` | `/relationships/:id` | Hapus relasi |
| `GET` | `/statistics/overview` | Overview statistik |
| `GET` | `/statistics/charts` | Data chart |
| `GET` | `/statistics/detailed` | Statistik detail |
| `GET` | `/leaderboards/live` | Leaderboard live |
| `GET` | `/leaderboards/snapshot` | Snapshot leaderboard |
| `POST` | `/leaderboards/snapshot` | Generate snapshot |
| `GET` | `/analytics/overview` | Analytics overview |
| `GET` | `/analytics/animals` | Analytics per hewan |
| `GET` | `/analytics/focus` | Distribusi focus |
| `GET` | `/analytics/users/:id` | Detail user analytics |
