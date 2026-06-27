# Rencana Implementasi "Equip Item" (Sisi Flutter / Aplikasi)

Dokumen ini memuat langkah-langkah teknis untuk Flutter Developer guna mengimplementasikan fitur pemakaian (equip) item (Avatar, Frame, Theme) di sisi aplikasi.

## 1. Domain & Data Layer (API Integration)

1.  **Update Entity & Model User**
    *   Ubah `UserEntity` dan `UserModel` (di layer Auth) untuk menerima data baru dari backend:
        *   `equippedAvatarUrl` (String?)
        *   `equippedFrameUrl` (String?)
        *   `equippedThemeUrl` (String?)
    *   Sesuaikan fungsi `fromJson` dan `copyWith`.

2.  **Update API Repository Inventori**
    *   Pada `InventoryRemoteDataSource` & `InventoryRepository`, tambahkan 2 endpoint baru:
        *   `equipItem(String itemId, String category)` 
        *   `unequipItem(String category)`
    *   *Catatan:* Category bernilai `'avatar'`, `'frame'`, atau `'theme'`.

## 2. State Management (BLoC / Cubit)

1.  **Update `InventoryCubit`**
    *   Tambahkan method `equip(String itemId, String category)` yang memanggil repository.
    *   Jika API berhasil, *trigger* pembaruan data User global melalui `AuthBloc`.
2.  **Update `AuthBloc`**
    *   Tambahkan event `AuthUserEquipUpdated` yang menerima parameter URL item baru.
    *   State `Authenticated` akan diperbarui dengan data `UserEntity` terbaru sehingga komponen UI mana pun yang mem-build ulang berdasarkan AuthBloc akan langsung menampilkan item baru.

## 3. UI Layer: Halaman Inventori

1.  **Tombol Equip / Unequip**
    *   Di halaman **Inventori** (`inventory_page.dart` atau di dalam Card item-nya), tambahkan tombol aksi.
    *   Jika ID item tersebut **sama dengan** `equippedAvatarUrl/Id` milik user saat ini, tampilkan label **"Sedang Dipakai"** atau tombol **"Lepas" (Unequip)**.
    *   Jika **tidak**, tampilkan tombol **"Gunakan" (Equip)**.
2.  **Feedback Loading & Notifikasi**
    *   Tampilkan `CircularProgressIndicator` saat proses equip berjalan ke server.
    *   Tampilkan *SnackBar* jika berhasil atau gagal.

## 4. UI Layer: Tampilan Visual (Efek Equip)

1.  **Avatar & Frame (Global)**
    *   Buat widget kustom baru, misalnya `EquippedAvatarWidget`.
    *   Widget ini akan memantau `AuthBloc`.
    *   **Logic:**
        *   Gunakan `equippedAvatarUrl` sebagai gambar profil utama (jika `null`, gunakan ikon default).
        *   Gunakan `Stack` untuk menempatkan gambar `equippedFrameUrl` di atas avatar sebagai bingkai (jika `null`, jangan tampilkan apa-apa).
    *   Implementasikan widget ini di `HomeProfileWidget`, *Leaderboard*, atau bagian lain yang menampilkan foto user.

2.  **Theme (Global / Halaman Tertentu)**
    *   Gunakan data `equippedThemeUrl` untuk mengubah latar belakang.
    *   Contoh: Di `HomeSceneSection`, jika `equippedThemeUrl` ada isinya, pasang sebagai *background image* atau ubah nuansa warna halaman beranda agar sesuai dengan tema yang di-equip.

---
**Prioritas Pengerjaan:**
Pengerjaan di sisi Flutter baru bisa sepenuhnya diuji setelah **API Backend** selesai dan siap menerima *request* serta mengembalikan data *equipped* di profil user.
