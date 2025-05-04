# Tugas 3 - Implementasikan UI dalam Flutter
## Identitas Kelompok

**Tugas Pemrograman Perangkat Bergerak - Kelompok 20 C1**

| NIM     | Nama Lengkap                       |
| ------- | ---------------------------------- |
| 2304137 | Muhammad Bintang Eighista Dwiputra |
| 2308224 | Datuk Daneswara Raditya Samsura    |
| 2308744 | Shizuka Maulia Putri               |
| 2309209 | Safira Aliyah Azmi                 |
| 2311474 | Hafsah Hamidah                     |
| 2312091 | Nina Wulandari                     |

---

# MASAKIO — Aplikasi Resep dan Komunitas Memasak

MASAKIO adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna menemukan, membuat, dan berbagi resep makanan yang sehat, hemat, dan mudah diakses. Aplikasi ini juga menyediakan fitur komunitas dan personalisasi untuk berbagai tipe pengguna, seperti mahasiswa, ibu rumah tangga, dan pekerja kantoran.

---

## Fitur Utama

- Splash Screen: Menampilkan branding MASAKIO saat aplikasi dibuka
- Autentikasi: Halaman daftar dan login akun
- Edit Profil: Mengatur nama, email, kata sandi, tanggal lahir, dan riwayat penyakit
- Beranda (Homepage): Menampilkan rekomendasi resep dan tips populer
- Tambah Resep: Form bertahap untuk mengisi resep baru
- Tambah Tips: Membagikan tips dan trik memasak
- Discovery Resep: Menemukan resep berdasarkan bahan, kategori, atau filter
- Discovery Tips: Menelusuri kumpulan tips memasak
- Forum: Tempat pengguna berdiskusi dan saling tanya-jawab
- Wishlist & Riwayat: Menyimpan resep favorit dan melihat riwayat interaksi
- Detail Resep & Tips: Menampilkan konten lengkap dari resep atau tips
- Validasi Resep: Preview akhir sebelum resep dikirimkan

---

## Daftar Halaman

| Halaman              | Deskripsi Singkat                                                |
|----------------------|------------------------------------------------------------------|
| Homepage             | Rekomendasi konten dan navigasi utama                           |
| Discovery Resep      | Pencarian dan filter resep makanan                              |
| Discovery Tips       | Eksplorasi kumpulan tips memasak                                |
| Detail Resep         | Informasi lengkap bahan, langkah, dan penulis resep             |
| Tambah Resep         | Form input bertahap (3 halaman) untuk menambahkan resep baru    |
| Forum Utama          | Forum diskusi komunitas                                         |
| Forum Detail         | Detail thread forum dan komentar                                |
| Profile              | Menampilkan informasi akun pengguna                             |
| Edit Profile         | Edit informasi pengguna dan riwayat penyakit                    |
| Detail Tips          | Melihat konten satu tips lengkap                                |
| Tambah Tips          | Form untuk membagikan tips                                      |
| Login                | Halaman masuk ke akun                                           |
| Registrasi           | Form daftar akun baru                                           |

---

## Tech Stack

- Flutter 3.x
- Dart
- Intl (untuk formatting tanggal)
- Stateful Widget untuk validasi dan form dinamis
- Komponen modular: `Button`, `UserAvatar`, `BottomPopup`, `Card`

---

## Struktur Proyek

```

lib/
├── .components/ 
│   ├── bottom_popup.dart
│   ├── button.dart
│   ├── card_rekomendasi.dart
│   ├── card_temukan_resep.dart
│   ├── card_tips_n_trik.dart
│   └── user_avatar.dart
│
├── Auth/
│   ├── daftar.dart
│   └── masuk.dart
│
├── Forum/
│   ├── add_discussion_page.dart
│   ├── detail_page.dart
│   ├── forum_page.dart
│   └── reply_discussion.dart
│
├── Profile/
│   ├── edit_profile.dart
│   └── profile.dart
│
├── Tambah Resep/
│   ├── tambah_resep1.dart
│   ├── tambah_resep2.dart
│   └── tambah_resep3.dart
│
├── Tips Trik/
│   ├── detail_tips.dart
│   └── tambah_tips.dart
│
├── Discovery/
│   ├── discovery_tips.dart
│   └── discovery_resep.dart
│
├── home.dart
├── main_page.dart
├── main.dart
└── resep_detail.dart

assets/
└── images/

pubspec.yaml
README.md

````

---

## Cara Menjalankan

1. Pastikan Flutter SDK sudah terpasang.
2. Clone repositori:

```bash
git clone https://github.com/namauser/masakio.git
cd masakio
````

3. Install dependensi:

```bash
flutter pub get
```

4. Jalankan aplikasi:

```bash
flutter run
```

---

## Lisensi

MIT License © 2025 Kelompok 20 C1

