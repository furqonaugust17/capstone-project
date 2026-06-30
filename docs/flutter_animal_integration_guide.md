# Panduan Integrasi Fitur Hewan (Animal) untuk Tim Flutter

Dokumen ini berisi informasi mengenai pembaruan *payload* API dari *backend* terkait entitas Hewan (`Animal`). Terdapat atribut-atribut baru yang kini dikembalikan oleh *endpoint* `GET /api/animals` dan `GET /api/animals/:id`.

Tim Flutter diharapkan memperbarui model/kelas (seperti `AnimalModel` di Dart) untuk menyesuaikan dengan struktur JSON terbaru berikut.

## 1. Pembaruan Struktur JSON (Response API)

Setiap *object* `Animal` kini memiliki tiga atribut tambahan yang dapat bernilai `null` jika belum diisi oleh admin:

```json
{
  "id": "uuid-string",
  "name": "Kucing",
  "description": "Deskripsi singkat hewan",
  "thumbnailUrl": "https://url-ke-gambar-thumbnail.jpg",
  "hintImageUrl": "https://url-ke-gambar-hint.jpg",
  "difficulty": "easy",
  
  // -- ATRIBUT BARU --
  "funFact": "Kucing menghabiskan sekitar 70% dari hidupnya untuk tidur.",
  "drawingTips": [
    "Mulai dengan bentuk lingkaran untuk kepala dan oval untuk badan.",
    "Gunakan dua segitiga kecil untuk telinga di atas kepala.",
    "Tambahkan kumis panjang di area pipi agar terlihat lebih nyata."
  ],
  "traceImageUrl": "https://url-ke-gambar-jiplakan.png",
  // ------------------
  
  "isActive": true,
  "createdAt": "2026-06-27T10:00:00.000Z",
  "updatedAt": "2026-06-27T10:05:00.000Z"
}
```

## 2. Detail Atribut Baru & Cara Penggunaannya di UI Flutter

### `funFact` (`String?`)
- **Tipe Data Dart:** `String?` (Nullable String)
- **Penjelasan:** Fakta unik seputar hewan yang bersifat edukatif.
- **Implementasi UI:** Bisa ditampilkan di halaman profil hewan atau *pop-up* dialog setelah pemain berhasil menggambar hewan tersebut untuk memberikan wawasan tambahan kepada anak-anak.

### `drawingTips` (`List<String>`)
- **Tipe Data Dart:** `List<String>` (Selalu berupa Array/List, meskipun kosong `[]`)
- **Penjelasan:** Langkah-langkah atau tips cara menggambar hewan. Panjang *array* dibatasi **maksimal 3 poin**.
- **Implementasi UI:** Dapat ditampilkan sebagai daftar instruksi (*bullet points* atau angka 1, 2, 3) di layar persiapan sebelum pengguna mulai menggambar atau masuk ke kanvas.

### `traceImageUrl` (`String?`)
- **Tipe Data Dart:** `String?` (Nullable String)
- **Penjelasan:** URL gambar kerangka/jiplakan yang digunakan khusus untuk mode **Ayo Tebalkan**.
- **Implementasi UI:** Mode *Ayo Tebalkan* kini harus mengambil gambar dari URL ini secara dinamis. Jika `traceImageUrl` bernilai `null`, Anda bisa mengatur *fallback* ke mode menggambar bebas, atau menonaktifkan tombol mode "Ayo Tebalkan" untuk hewan tersebut.

## 3. Contoh Pembaruan Kelas Dart (Model)

Pastikan pemetaan dari JSON ke *object* Dart di-*update* menjadi seperti ini:

```dart
class Animal {
  final String id;
  final String name;
  final String? description;
  final String? thumbnailUrl;
  final String? hintImageUrl;
  final String difficulty;
  final String? funFact;
  final List<String> drawingTips;
  final String? traceImageUrl;

  Animal({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
    this.hintImageUrl,
    required this.difficulty,
    this.funFact,
    required this.drawingTips,
    this.traceImageUrl,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      hintImageUrl: json['hintImageUrl'],
      difficulty: json['difficulty'] ?? 'easy',
      funFact: json['funFact'],
      // Pastikan cast ke List<String> dengan aman
      drawingTips: json['drawingTips'] != null 
          ? List<String>.from(json['drawingTips']) 
          : [],
      traceImageUrl: json['traceImageUrl'],
    );
  }
}
```

Silakan hubungi tim *backend* jika menemui kendala terkait _response_ API. Selamat mengintegrasikan! 🚀
