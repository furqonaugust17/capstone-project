# Backend Entity Design Recommendation
## Educational Animal Drawing Game with CNN Sketch Classification

## Overview

This document summarizes the recommended backend entities and architecture for future development using:

- Node.js
- PostgreSQL
- Flutter
- TensorFlow Lite
- Dynamic Animal Management
- Dynamic ML Model Management
- Leaderboard System
- Shop & Inventory System
- Achievement System
- Learning Analytics

The goal is to support both the current capstone project and future production-scale expansion without requiring major database redesign.

---

# Core Entities

## User

Stores player information and account data.

```text
User
- id
- username
- email
- password_hash
- display_name
- avatar_url
- total_point
- created_at
- updated_at
```

### Notes

- `total_point` digunakan sebagai mata uang dalam game.
- `display_name` digunakan untuk leaderboard.
- `avatar_url` digunakan untuk profil pemain.

### Future Support

```text
- firebase_uid
```

---

## Animal

Menyimpan daftar hewan yang tersedia untuk dimainkan.

```text
Animal
- id
- name
- description
- thumbnail_url
- hint_image_url
- difficulty
- is_active
- created_at
```

### Notes

- Animal dapat ditambah tanpa update aplikasi.
- Mendukung dynamic animal management.
- Mendukung sistem difficulty.

Contoh:

```text
Lion
Difficulty: Easy

Elephant
Difficulty: Medium

Eagle
Difficulty: Hard
```

---

## MLModel

Menyimpan metadata model machine learning.

```text
MLModel
- id
- name
- version
- file_url
- labels_url
- input_size
- framework
- accuracy
- is_active
- created_at
```

### Notes

Mendukung:

- Dynamic model deployment
- Model versioning
- Rollback model
- Multiple model support

Contoh:

```text
Animal CNN v1.0
Animal CNN v1.1
Animal CNN v2.0
```

---



# Game Session

Entity ini menggantikan `PredictionResult`.

```text
GameSession
- id
- user_id
- animal_id
- model_id

- prediction_label
- confidence_score

- game_score
- focus_score

- drawing_duration

- started_at
- finished_at
```

### Why?

Karena satu sesi permainan tidak hanya berisi hasil prediksi.

Tetapi juga:

- score
- focus score
- confidence score
- durasi bermain

---

# Shop System

## ShopItem

Menyimpan seluruh item yang bisa dibeli.

```text
ShopItem
- id
- name
- description
- image_url
- price
- category
- rarity
- is_active
```

### Categories

```text
Avatar
Frame
Sticker
Theme
```

### Rarity

```text
Common
Rare
Epic
Legendary
```

---

# Inventory System

## UserInventory

Menyimpan item yang dimiliki user.

```text
UserInventory
- id
- user_id
- item_id
- quantity
- acquired_at
```

### Notes

Lebih fleksibel dibanding hanya:

```text
user_id
item_id
```

karena mendukung:

- multiple item ownership
- stacking item

---

# Purchase History

## PurchaseHistory

Menyimpan seluruh transaksi pembelian.

```text
PurchaseHistory
- id
- user_id
- item_id
- price
- purchased_at
```

### Benefits

- Audit transaksi
- Riwayat pembelian
- Refund handling (future)

---



# User Statistics

## UserStatistic

```text
UserStatistic
- user_id
- total_games
- total_score
- highest_score
- average_focus
```

### Why?

Mempermudah:

- Dashboard
- Analytics
- Leaderboard

tanpa harus menghitung ulang seluruh GameSession.

---

# Leaderboard

## MVP

Belum perlu tabel khusus.

Leaderboard dapat dihitung dari:

```sql
SELECT
    user_id,
    SUM(game_score)
FROM game_sessions
GROUP BY user_id
ORDER BY SUM(game_score) DESC;
```

---

## Future

```text
LeaderboardSnapshot
- id
- period
- generated_at
```

### Examples

```text
Weekly Leaderboard
Monthly Leaderboard
Season Leaderboard
```

---

# Relationship Diagram

```text
User
├── UserStatistic
├── UserInventory
├── PurchaseHistory
├── UserAchievement
└── GameSession

Animal
└── AnimalModel

MLModel
└── AnimalModel

ShopItem
└── UserInventory

Achievement
└── UserAchievement

GameSession
├── User
├── Animal
└── MLModel
```

---

# Development Roadmap

## Phase 1 — Capstone MVP

Entities:

```text
User
Animal
MLModel
AnimalModel
GameSession
```

Features:

- Authentication
- Dynamic Animal List
- Dynamic ML Model
- Prediction History
- Focus Score Tracking

---

## Phase 2 — Reward System

Entities:

```text
ShopItem
UserInventory
PurchaseHistory
```

Features:

- Shop
- Cosmetic Item
- Point Redemption

---

## Phase 3 — Progress System

Entities:

```text
Achievement
UserAchievement
UserStatistic
```

Features:

- Achievement
- User Progress
- Learning Analytics

---

## Phase 4 — Competitive Features

Entities:

```text
LeaderboardSnapshot
```

Features:

- Weekly Leaderboard
- Monthly Leaderboard
- Seasonal Event
- Daily Challenge

---

# Focus Detection Integration

Saat ini focus detection belum menggunakan database.

Namun pada tahap backend nanti, focus score dapat disimpan pada:

```text
GameSession
- focus_score
```

Sehingga dapat digunakan untuk:

- User Analytics
- Progress Tracking
- Achievement
- Adaptive Learning System

---

# Future Machine Learning Expansion

Saat ini:

```text
CNN
→ Sketch Classification
```

Di masa depan:

```text
CNN
→ Sketch Classification

Behavior Analytics
→ Focus Detection

Recommendation Engine
→ Adaptive Learning
```

---

# Most Important Improvements

## Critical

✅ Tambahkan authentication pada User

✅ Ganti PredictionResult menjadi GameSession

✅ Tambahkan model versioning

✅ Tambahkan animal difficulty

---

## Important

✅ Achievement System

✅ Purchase History

✅ User Statistics

---

## Future

✅ Seasonal Leaderboard

✅ Daily Challenge

✅ Event System

✅ Firebase Integration

✅ Cloud Analytics

---

# Final Recommended Entity List

```text
User

Animal

MLModel

AnimalModel

GameSession

ShopItem

UserInventory

PurchaseHistory

Achievement

UserAchievement

UserStatistic
```

---

# Conclusion

Struktur entity di atas sudah cukup untuk mendukung:

- Dynamic Animal Management
- Dynamic Machine Learning Model Management
- CNN Sketch Classification
- Focus Detection Analytics
- Shop System
- Inventory System
- Achievement System
- Leaderboard System
- Future Firebase Integration
- Future Production Deployment

tanpa perlu melakukan redesign besar pada database ketika aplikasi berkembang dari capstone project menjadi aplikasi production-ready.