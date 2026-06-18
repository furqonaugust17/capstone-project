# API Documentation - Admin Dashboard

Dokumentasi ini ditujukan bagi tim yang membangun **Admin Web Panel**. Endpoint berikut membutuhkan *Bearer Token* dengan akses level `ADMIN`.

---

## 📌 Base Configuration
- **Base URL**: `http://<IP_SERVER>:3000/api`
- **Upload File**: Gunakan tipe `multipart/form-data` untuk unggah gambar dan `.tflite`.
- **Autentikasi**: *Bearer Token* di Header (`Authorization: Bearer <ACCESS_TOKEN>`). Jika akun tidak berstatus ADMIN, server akan merespon `403 Forbidden`.

---

## 1️⃣ Authentication (`/api/auth`)

### Admin Login
- **Endpoint**: `POST /auth/login`
- **Auth**: None
- **Catatan**: Akun admin bawaan biasanya telah di-seed di database (`admin@animaldrawing.com`).

### Verify Admin Session
- **Endpoint**: `GET /auth/me`
- **Auth**: Required

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

### Activate a Model
- **Endpoint**: `PUT /ml-models/:id/activate`
- **Auth**: Required (Admin)
- **Deskripsi**: Menonaktifkan model aktif saat ini, dan menset model terpilih menjadi model aktif (Satu-satunya yang akan diunduh oleh aplikasi Flutter).

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
