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

## Dokumentasi 
| Nama Laman | Tampilan Laman |
|---|---|
| Main | <img width="150" src="https://github.com/user-attachments/assets/05ff7922-8081-407f-a406-4d0989608936" /> |
| Splash Screen | <img width="150" src="https://github.com/user-attachments/assets/b15009cd-be09-4285-a57f-e811af0263b6" /> |
| Home Page | <img width="150" src="https://github.com/user-attachments/assets/4c820cbc-4e59-46b1-bca7-11ed8d30be3e" /> |
| Explore Page | <img width="150" src="https://github.com/user-attachments/assets/3659c17d-d9c6-460e-9da8-56ec70565877" /> <img width="150" src="https://github.com/user-attachments/assets/b5970210-42b6-484e-bb5b-a51957f9c6fc" /> |
| Pop Up Tambah Tips & Resep | <img width="150" src="https://github.com/user-attachments/assets/f51354a8-c8fd-4f0c-adc1-b651c15d5542" /> |
| Form Resep Baru | <img width="150" src="https://github.com/user-attachments/assets/2a405f8a-df73-4eaf-af06-71b73d9a71db" /> <img width="150" src="https://github.com/user-attachments/assets/f1c1e49c-1a10-4412-9307-003504cfd637" /> <img width="150" src="https://github.com/user-attachments/assets/4addf9ed-0f64-4f1e-a4a6-c02ca00254be" /> <img width="150" src="https://github.com/user-attachments/assets/a46b6772-bd8c-4d91-a947-d59724ee3f09" /> <img width="150" src="https://github.com/user-attachments/assets/c04403dc-5a5c-4f27-8b27-843e9b41ae05" /> |
| Form Tips Baru |  <img width="150" src="https://github.com/user-attachments/assets/2e9fdf7a-901c-48ef-a167-a9fc850237b1" /> <img width="150" src="https://github.com/user-attachments/assets/a3a25d75-1218-4e82-a601-2cec700449ce" /> |
| Laman Forum | <img width="150" src="https://github.com/user-attachments/assets/4578aec0-ee81-4c59-8c3b-214be3e2985e" /> <img width="150" src="https://github.com/user-attachments/assets/54289abd-48b2-45c2-a0ba-72fe12de0873" /> <img width="150" src="https://github.com/user-attachments/assets/7cc6ee65-d402-4c29-81a2-af83c9b8d5fa" /> |
| Detail Resep | <img width="150" src="https://github.com/user-attachments/assets/1281f882-cb98-4098-a7c5-df463ef90b49" /> |
| Detail Tips | <img width="150" src="https://github.com/user-attachments/assets/b949cb35-daa5-4a18-b52c-46db3e051f86" /> |
| Profile | <img width="150" src="https://github.com/user-attachments/assets/29e779ea-be56-4d9c-8f2c-3f43c9cbaf80" /> <img width="150" src="https://github.com/user-attachments/assets/05fc1a18-4d31-4195-af23-daf7d275a364" />  <img width="150" src="https://github.com/user-attachments/assets/e9162ba9-8734-4f25-bc24-39f30d27ae44" />|



## Lisensi

MIT License © 2025 Kelompok 20 C1
