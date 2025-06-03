-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 24, 2025 at 09:15 AM
-- Server version: 8.0.30
-- PHP Version: 8.3.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `masakio`
--

-- --------------------------------------------------------

--
-- Table structure for table `alat`
--

CREATE TABLE `alat` (
  `id_alat` int NOT NULL,
  `id_resep` int DEFAULT NULL,
  `nama_alat` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `jumlah` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alat`
--

INSERT INTO `alat` (`id_alat`, `id_resep`, `nama_alat`, `jumlah`) VALUES
(1, 1, 'Wajan', 1),
(2, 1, 'Spatula', 1),
(3, 1, 'Talenan', 1),
(4, 1, 'Pisau', 1),
(5, 2, 'Panci', 1),
(6, 2, 'Spatula', 1),
(7, 2, 'Saringan', 1),
(8, 2, 'Sendok Makan', 1),
(9, 3, 'Pemanggang', 1),
(10, 3, 'Sikat Bakar', 1),
(11, 3, 'Sendok Makan', 2),
(12, 3, 'Talenan', 1),
(13, 3, 'Pisau', 1),
(14, 4, 'Panci', 1),
(15, 4, 'Saringan', 1),
(16, 4, 'Sendok Sup', 2),
(17, 4, 'Pisau', 1),
(22, 6, 'Blender', 1),
(23, 6, 'Sendok Makan', 1),
(24, 6, 'Gelaskaca', 2),
(25, 7, 'Mangkuk', 1),
(26, 7, 'Sendok', 1),
(27, 7, 'Panci', 1),
(28, 7, 'Whisk', 1);

-- --------------------------------------------------------

--
-- Table structure for table `bahan`
--

CREATE TABLE `bahan` (
  `id_bahan` int NOT NULL,
  `id_resep` int DEFAULT NULL,
  `nama_bahan` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `jumlah` int DEFAULT NULL,
  `id_satuan` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bahan`
--

INSERT INTO `bahan` (`id_bahan`, `id_resep`, `nama_bahan`, `jumlah`, `id_satuan`) VALUES
(1, 1, 'Sosis', 2, 9),
(2, 1, 'Nasi', 1, 1),
(3, 1, 'Telur', 2, 9),
(4, 1, 'Kecap Manis', 1, 1),
(5, 1, 'Bawang Merah', 2, 1),
(6, 1, 'Bawang Putih', 2, 1),
(7, 1, 'Minyak Goreng', 2, 8),
(8, 2, 'Sosis', 3, 9),
(9, 2, 'Nasi', 1, 1),
(10, 2, 'Telur', 2, 9),
(11, 2, 'Kunyit', 1, 1),
(12, 2, 'Garam', 1, 1),
(13, 2, 'Santan', 1, 8),
(14, 3, 'Ayam (bagian paha)', 4, 9),
(15, 3, 'Madu', 2, 8),
(16, 3, 'Kecap Manis', 1, 1),
(17, 3, 'Bawang Putih', 2, 1),
(18, 3, 'Bawang Merah', 2, 1),
(19, 3, 'Lemon', 1, 9),
(20, 3, 'Garam', 1, 1),
(21, 4, 'Ayam (bagian dada)', 1, 9),
(22, 4, 'Jahe', 1, 1),
(23, 4, 'Bawang Putih', 3, 1),
(24, 4, 'Daun Bawang', 2, 9),
(25, 4, 'Kaldu Ayam', 2, 8),
(26, 4, 'Kecap Asin', 1, 1),
(27, 4, 'Garam', 1, 1),
(34, 6, 'Alpukat', 2, 9),
(35, 6, 'Susu Kental Manis', 3, 8),
(36, 6, 'Es Batu', 200, 1),
(37, 6, 'Gula Pasir', 1, 1),
(38, 6, 'Air Putih', 100, 1),
(39, 7, 'Cokelat Batangan', 150, 1),
(40, 7, 'Susu Cair', 300, 8),
(41, 7, 'Gula Pasir', 50, 1),
(42, 7, 'Telur', 3, 9),
(43, 7, 'Vanili', 1, 1),
(44, 7, 'Agar-Agar', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `discussion`
--

CREATE TABLE `discussion` (
  `id_discuss` int NOT NULL,
  `id_user` int DEFAULT NULL,
  `gambar` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `caption` text COLLATE utf8mb4_general_ci,
  `timestamp` datetime DEFAULT NULL,
  `jumlah_like` int DEFAULT NULL,
  `reply_to` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `discussion`
--

INSERT INTO `discussion` (`id_discuss`, `id_user`, `gambar`, `caption`, `timestamp`, `jumlah_like`, `reply_to`) VALUES
(1, 1, 'salmon_goreng.jpg', 'Resep Sausage Nasi Goreng ini sangat enak! Semua anggota keluarga suka, apalagi dengan sosisnya yang gurih!', '2025-05-24 09:00:00', 10, NULL),
(2, 2, NULL, 'Puding cokelatnya enak sekali, tapi ada yang bisa kasih tips supaya lebih lembut?', '2025-05-24 09:15:00', 5, 1),
(3, 3, 'ayam_bakar.jpg', 'Ayam Bakar Madu yang satu ini memang mantap! Tapi kenapa rasanya sedikit terlalu manis?', '2025-05-24 09:30:00', 8, NULL),
(4, 1, NULL, 'Nasi kuning yang saya coba kemarin sangat lezat, saya tambah sedikit sambal terasi, rasanya makin mantap!', '2025-05-24 09:45:00', 12, NULL),
(5, 4, 'sup_ayam_jahe.jpg', 'Sup Ayam Jahe ini segar banget, tapi ada yang bisa beri saran bahan tambahan supaya lebih kaya rasa?', '2025-05-24 10:00:00', 7, 4),
(6, 2, 'jus_alpukat.jpg', 'Jus alpukat yang segar banget! Cuma, rasanya agak kurang manis, mungkin perlu tambahan gula sedikit.', '2025-05-24 10:15:00', 9, NULL),
(7, 3, 'sushi_rolls.jpg', 'Sushi rolls yang saya buat enak banget! Tapi teksturnya sedikit kurang padat, ada yang tahu tipsnya?', '2025-05-24 10:30:00', 6, NULL),
(8, 5, 'puding_cokelat.jpg', 'Puding cokelat ini enak banget! Bisa lebih mantap lagi kalau ada taburan kacang di atasnya.', '2025-05-24 10:45:00', 15, 2),
(9, 6, NULL, 'Sausage Nasi Goreng ini mudah banget dibuat! Anak-anak saya juga suka banget.', '2025-05-24 11:00:00', 11, NULL),
(10, 7, NULL, 'Sup Ayam Jahe saya rasanya sangat enak! Saya masukkan sedikit jeruk nipis supaya ada sensasi asamnya.', '2025-05-24 11:15:00', 10, NULL),
(11, 2, NULL, 'Buat yang ingin buat puding cokelat lebih lembut, coba tambahkan sedikit susu kental manis, deh.', '2025-05-24 11:30:00', 9, 2),
(12, 1, NULL, 'Coba tambahkan sedikit kecap asin saat menggoreng sosis di Sausage Nasi Goreng, rasanya lebih enak!', '2025-05-24 11:45:00', 8, 1),
(13, 5, 'nasi_kuning.jpg', 'Menambahkan sedikit sambal terasi memang bikin Sausage Nasi Kuning jadi lebih nikmat, mantap!', '2025-05-24 12:00:00', 14, 4),
(14, 4, NULL, 'Tambahkan daun salam untuk memberikan aroma yang lebih sedap di Sup Ayam Jahe!', '2025-05-24 12:15:00', 7, 5),
(15, 3, NULL, 'Untuk mendapatkan tekstur yang lebih padat di sushi, pastikan rice vinegar digunakan dengan tepat.', '2025-05-24 12:30:00', 10, 7);

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE `history` (
  `id_history` int NOT NULL,
  `id_user` int DEFAULT NULL,
  `id_resep` int DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `history`
--

INSERT INTO `history` (`id_history`, `id_user`, `id_resep`, `timestamp`) VALUES
(1, 1, 1, '2025-05-24 08:00:00'),
(2, 1, 2, '2025-05-24 08:05:00'),
(3, 2, 3, '2025-05-24 08:10:00'),
(4, 2, 4, '2025-05-24 08:15:00'),
(5, 3, 6, '2025-05-24 08:20:00'),
(6, 3, 4, '2025-05-24 08:25:00'),
(7, 4, 7, '2025-05-24 08:30:00'),
(8, 4, 1, '2025-05-24 08:35:00'),
(9, 5, 2, '2025-05-24 08:40:00'),
(10, 6, 3, '2025-05-24 08:45:00');

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int NOT NULL,
  `kategori` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `kategori`) VALUES
(1, 'Makanan Berat'),
(2, 'Minuman'),
(3, 'Hidangan Pembuka'),
(4, 'Hidangan Penutup'),
(5, 'Jamu');

-- --------------------------------------------------------

--
-- Table structure for table `langkah`
--

CREATE TABLE `langkah` (
  `id_langkah` int NOT NULL,
  `id_prosedur` int NOT NULL,
  `nama_langkah` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `urutan` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `langkah`
--

INSERT INTO `langkah` (`id_langkah`, `id_prosedur`, `nama_langkah`, `urutan`) VALUES
(1, 1, 'Panaskan wajan dan tuang minyak goreng', 1),
(2, 1, 'Masukkan bawang merah dan bawang putih, tumis hingga harum', 2),
(3, 1, 'Masukkan sosis yang telah dipotong, masak hingga matang', 3),
(4, 1, 'Tambahkan telur, aduk rata hingga telur matang', 4),
(5, 1, 'Masukkan nasi, aduk rata dengan bumbu dan sosis', 5),
(6, 1, 'Tambahkan kecap manis dan aduk hingga rata', 6),
(7, 2, 'Cuci beras hingga bersih, tiriskan', 1),
(8, 2, 'Rebus air dan santan dengan bumbu kunyit, masukkan beras', 2),
(9, 2, 'Masak nasi kuning hingga matang, kemudian angkat', 3),
(10, 2, 'Panaskan minyak, tumis sosis hingga matang', 4),
(11, 2, 'Masukkan telur, orak-arik hingga matang', 5),
(12, 2, 'Campurkan nasi kuning, sosis, dan telur, aduk rata', 6),
(13, 3, 'Cuci ayam hingga bersih', 1),
(14, 3, 'Tumbuk bawang merah dan bawang putih, lalu campurkan dengan madu, kecap, dan perasan lemon', 2),
(15, 3, 'Oleskan campuran bumbu ke ayam dan diamkan selama 15 menit', 3),
(16, 3, 'Panaskan pemanggang dan panggang ayam hingga matang dan berwarna kecoklatan', 4),
(17, 3, 'Balik ayam beberapa kali dan oleskan kembali dengan bumbu', 5),
(18, 4, 'Rebus ayam hingga matang, kemudian angkat dan tiriskan', 1),
(19, 4, 'Tumis bawang putih dan jahe hingga harum', 2),
(20, 4, 'Masukkan kaldu ayam, garam, dan kecap asin, kemudian rebus lagi selama 10 menit', 3),
(21, 4, 'Masukkan ayam yang sudah direbus, masak sebentar, dan tambahkan daun bawang', 4),
(22, 4, 'Sup siap disajikan, nikmati selagi hangat', 5),
(29, 6, 'Ambil daging alpukat dan masukkan ke dalam blender', 1),
(30, 6, 'Tambahkan susu kental manis, gula pasir, dan es batu', 2),
(31, 6, 'Tambahkan air putih secukupnya', 3),
(32, 6, 'Blender hingga semua bahan tercampur rata', 4),
(33, 6, 'Sajikan dalam gelas dan nikmati selagi dingin', 5),
(34, 7, 'Lelehkan cokelat batangan dengan cara dipanaskan di atas panci', 1),
(35, 7, 'Kocok telur, susu cair, gula pasir, dan vanili hingga rata', 2),
(36, 7, 'Tambahkan cokelat leleh ke dalam campuran telur, aduk rata', 3),
(37, 7, 'Masukkan agar-agar ke dalam campuran, lalu masak dengan api kecil hingga mengental', 4),
(38, 7, 'Tuang adonan puding ke dalam mangkuk dan dinginkan hingga set', 5),
(39, 7, 'Puding siap disajikan, nikmati dengan taburan cokelat parut atau buah segar', 6);

-- --------------------------------------------------------

--
-- Table structure for table `nutrisi`
--

CREATE TABLE `nutrisi` (
  `id_nutrisi` int NOT NULL,
  `id_resep` int DEFAULT NULL,
  `karbohidrat` decimal(5,2) DEFAULT NULL,
  `protein` decimal(5,2) DEFAULT NULL,
  `lemak` decimal(5,2) DEFAULT NULL,
  `serat` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nutrisi`
--

INSERT INTO `nutrisi` (`id_nutrisi`, `id_resep`, `karbohidrat`, `protein`, `lemak`, `serat`) VALUES
(1, 1, '45.00', '20.00', '15.00', '3.00'),
(3, 2, '50.00', '22.00', '12.00', '2.50'),
(4, 3, '10.00', '25.00', '18.00', '1.00'),
(5, 4, '10.00', '22.00', '7.00', '1.50'),
(7, 6, '18.00', '3.00', '15.00', '5.00'),
(8, 7, '45.00', '5.00', '15.00', '2.00');

-- --------------------------------------------------------

--
-- Table structure for table `penyakit`
--

CREATE TABLE `penyakit` (
  `id_penyakit` int NOT NULL,
  `nama_penyakit` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penyakit`
--

INSERT INTO `penyakit` (`id_penyakit`, `nama_penyakit`) VALUES
(1, 'Diabetes'),
(2, 'Hipertensi'),
(3, 'Kolesterol Tinggi'),
(4, 'Asma'),
(5, 'Radang Sendi'),
(6, 'Gastritis'),
(7, 'Kanker'),
(8, 'TBC'),
(9, 'Stroke'),
(10, 'Penyakit Jantung'),
(11, 'Penyakit Ginjal'),
(12, 'Obesitas'),
(13, 'Sakit Kepala Migrain'),
(14, 'Sakit Gigi'),
(15, 'Masalah Pencernaan'),
(16, 'Cacingan'),
(17, 'Demam Berdarah'),
(18, 'Infeksi Saluran Kemih'),
(19, 'Ambeien'),
(20, 'Gout (Asam Urat)');

-- --------------------------------------------------------

--
-- Table structure for table `prosedur`
--

CREATE TABLE `prosedur` (
  `id_prosedur` int NOT NULL,
  `id_resep` int NOT NULL,
  `nama_prosedur` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `urutan` int NOT NULL,
  `durasi` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prosedur`
--

INSERT INTO `prosedur` (`id_prosedur`, `id_resep`, `nama_prosedur`, `urutan`, `durasi`) VALUES
(1, 1, 'Memasak nasi goreng', 1, 15),
(2, 2, 'Memasak nasi kuning', 1, 20),
(3, 3, 'Memasak ayam bakar madu', 1, 30),
(4, 4, 'Memasak Sup Ayam Jahe', 1, 30),
(6, 6, 'Membuat Jus Alpukat', 1, 10),
(7, 7, 'Membuat Puding Cokelat', 1, 30);

-- --------------------------------------------------------

--
-- Table structure for table `resep`
--

CREATE TABLE `resep` (
  `id_resep` int NOT NULL,
  `id_user` int DEFAULT NULL,
  `nama_resep` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `video` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deskripsi` text COLLATE utf8mb4_general_ci,
  `porsi` int DEFAULT NULL,
  `jumlah_like` int DEFAULT NULL,
  `jumlah_view` int DEFAULT NULL,
  `id_kategori` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `resep`
--

INSERT INTO `resep` (`id_resep`, `id_user`, `nama_resep`, `video`, `deskripsi`, `porsi`, `jumlah_like`, `jumlah_view`, `id_kategori`) VALUES
(1, 1, 'Sausage Nasi Goreng', NULL, 'Ini adalah resep kebanggan keluarga. Nasi goreng dengan sosis, telur, dan bumbu yang meresap sempurna. Cocok untuk makan siang keluarga.', 1, NULL, NULL, 1),
(2, 1, 'Sausage Nasi Kuning', NULL, 'Ini adalah resep kebanggan keluarga. Nasi goreng dengan sosis, telur, dan bumbu yang meresap sempurna. Cocok untuk makan siang keluarga.', 1, NULL, NULL, 1),
(3, 1, 'Ayam Bakar Madu', NULL, 'Ayam bakar dengan bumbu madu yang manis dan gurih. Cocok untuk makan malam bersama keluarga.', 4, 30, 200, 1),
(4, 1, 'Sup Ayam Jahe', NULL, 'Sup ayam jahe yang menyegarkan dan kaya rasa, sangat cocok untuk cuaca dingin atau sebagai hidangan pembuka.', 4, 40, 180, 3),
(6, 1, 'Jus Alpukat', NULL, 'Jus alpukat yang creamy dan menyegarkan, cocok untuk diminum di pagi hari atau sebagai camilan sehat.', 2, 35, 220, 2),
(7, 1, 'Puding Cokelat', NULL, 'Puding cokelat yang lezat dan lembut, cocok untuk hidangan penutup setelah makan besar.', 4, 60, 250, 4);

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `id_review` int NOT NULL,
  `id_user` int DEFAULT NULL,
  `id_resep` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `komentar` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`id_review`, `id_user`, `id_resep`, `rating`, `komentar`) VALUES
(1, 1, 1, 5, 'Resep nasi goreng ini sangat enak! Sosisnya gurih dan bumbunya pas. Saya sering buat ini untuk makan siang keluarga.'),
(2, 2, 1, 4, 'Nasi gorengnya enak, tapi sedikit lebih pedas akan lebih baik.'),
(3, 1, 2, 5, 'Nasi kuning ini sangat lezat dan kaya rasa! Sosisnya sangat cocok dengan nasi kuningnya.'),
(4, 2, 2, 4, 'Cocok untuk sarapan, namun sedikit lebih pedas akan lebih baik.'),
(5, 1, 3, 5, 'Ayam bakar madu ini rasanya luar biasa! Manis, gurih, dan ayamnya empuk. Pasti akan saya buat lagi.'),
(6, 2, 3, 4, 'Resep ini sangat mudah dan lezat. Saya ingin mencoba menambah sedikit rasa pedas agar lebih nikmat.'),
(7, 1, 4, 5, 'Sup ini sangat menyegarkan! Rasa jahe memberikan kehangatan yang pas, sangat cocok di cuaca dingin.'),
(8, 2, 4, 4, 'Sup ayamnya enak, hanya sedikit kurang pedas untuk saya.'),
(11, 1, 6, 5, 'Jus alpukatnya enak banget! Rasanya creamy dan manis. Saya suka membuatnya di pagi hari.'),
(12, 2, 6, 4, 'Jusnya segar dan lezat, hanya saja saya ingin menambah sedikit es krim untuk rasa lebih creamy.'),
(13, 1, 7, 5, 'Puding cokelatnya lembut dan sangat enak! Saya suka sekali teksturnya yang creamy.'),
(14, 2, 7, 4, 'Rasanya enak, namun saya ingin pudingnya sedikit lebih padat.');

-- --------------------------------------------------------

--
-- Table structure for table `riwayat_user`
--

CREATE TABLE `riwayat_user` (
  `id_riwayat` int NOT NULL,
  `id_user` int DEFAULT NULL,
  `id_penyakit` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `riwayat_user`
--

INSERT INTO `riwayat_user` (`id_riwayat`, `id_user`, `id_penyakit`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 1),
(7, 7, 2),
(8, 8, 3),
(9, 9, 4),
(10, 10, 5);

-- --------------------------------------------------------

--
-- Table structure for table `satuan`
--

CREATE TABLE `satuan` (
  `id_satuan` int NOT NULL,
  `nama_satuan` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `satuan`
--

INSERT INTO `satuan` (`id_satuan`, `nama_satuan`) VALUES
(1, 'Gram'),
(2, 'Kilogram'),
(3, 'Ons'),
(4, 'Mililiter'),
(5, 'Liter'),
(6, 'Gelas'),
(7, 'Sendok Makan'),
(8, 'Sendok Teh'),
(9, 'Butir'),
(10, 'Siung'),
(11, 'Lembar');

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE `tag` (
  `id_tag` int NOT NULL,
  `id_resep` int DEFAULT NULL,
  `nama_tag` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`id_tag`, `id_resep`, `nama_tag`) VALUES
(1, 1, 'Makanan Sehat'),
(2, 1, 'Praktis'),
(3, 1, 'Sosis'),
(4, 1, 'Nasi Goreng'),
(5, 2, 'Makanan Sehat'),
(6, 2, 'Praktis'),
(7, 2, 'Nasi Kuning'),
(8, 2, 'Sosis'),
(9, 3, 'Ayam Bakar'),
(10, 3, 'Madu'),
(11, 3, 'Makanan Panggang'),
(12, 3, 'Praktis'),
(13, 4, 'Sup Ayam'),
(14, 4, 'Jahe'),
(15, 4, 'Makanan Sehat'),
(16, 4, 'Hangat'),
(21, 6, 'Minuman Sehat'),
(22, 6, 'Alpukat'),
(23, 6, 'Segar'),
(24, 6, 'Kenyang'),
(25, 7, 'Puding'),
(26, 7, 'Cokelat'),
(27, 7, 'Hidangan Penutup'),
(28, 7, 'Dessert');

-- --------------------------------------------------------

--
-- Table structure for table `tag_tips`
--

CREATE TABLE `tag_tips` (
  `id_tag_tips` int NOT NULL,
  `id_tips` int DEFAULT NULL,
  `nama` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tag_tips`
--

INSERT INTO `tag_tips` (`id_tag_tips`, `id_tips`, `nama`) VALUES
(1, 1, 'Ikan Segar'),
(2, 1, 'Memasak Ikan'),
(3, 1, 'Tips Memasak'),
(4, 1, 'Makanan Sehat'),
(5, 2, 'Nasi'),
(6, 2, 'Masakan Sehat'),
(7, 2, 'Makanan Praktis'),
(8, 2, 'Hidangan Utama'),
(9, 3, 'Puding Cokelat'),
(10, 3, 'Dessert'),
(11, 3, 'Cokelat'),
(12, 3, 'Hidangan Penutup'),
(13, 4, 'Jus Alpukat'),
(14, 4, 'Minuman Sehat'),
(15, 4, 'Minuman Creamy'),
(16, 4, 'Makanan Sehat'),
(17, 5, 'Daging Sapi'),
(18, 5, 'Masakan Daging'),
(19, 5, 'Teknik Memasak'),
(20, 5, 'Makanan Berat'),
(21, 6, 'Tahu'),
(22, 6, 'Vegetarian'),
(23, 6, 'Makanan Sehat'),
(24, 6, 'Masakan Praktis'),
(25, 7, 'Sup'),
(26, 7, 'Makanan Sehat'),
(27, 7, 'Kuah Sup'),
(28, 7, 'Hidangan Pembuka'),
(29, 8, 'Ikan'),
(30, 8, 'Menyimpan Makanan'),
(31, 8, 'Tips Penyimpanan'),
(32, 8, 'Ikan Segar'),
(33, 9, 'Sayuran'),
(34, 9, 'Menyimpan Sayuran'),
(35, 9, 'Makanan Sehat'),
(36, 9, 'Tips Penyimpanan'),
(37, 10, 'Nasi Goreng'),
(38, 10, 'Masakan Praktis'),
(39, 10, 'Makanan Sehat'),
(40, 10, 'Makanan Berat');

-- --------------------------------------------------------

--
-- Table structure for table `tips`
--

CREATE TABLE `tips` (
  `id_tips` int NOT NULL,
  `id_user` int DEFAULT NULL,
  `judul` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  `deskripsi` text COLLATE utf8mb4_general_ci,
  `foto` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tips`
--

INSERT INTO `tips` (`id_tips`, `id_user`, `judul`, `timestamp`, `deskripsi`, `foto`) VALUES
(1, 1, 'Cara Memilih Ikan Salmon Segar', '2025-05-24 08:00:00', 'Pilih ikan salmon yang memiliki warna merah cerah dan bau yang segar. Hindari ikan yang terlihat kusam atau berbau amis.', 'salmon.jpg'),
(2, 2, 'Tips Agar Nasi Tidak Lembek', '2025-05-24 08:10:00', 'Gunakan takaran air yang tepat dan jangan terlalu sering mengaduk nasi. Biarkan nasi matang dengan api kecil setelah air mendidih.', 'nasi.jpg'),
(3, 1, 'Rahasia Puding Cokelat Lembut', '2025-05-24 08:20:00', 'Untuk mendapatkan puding yang lembut, gunakan agar-agar dengan kadar yang tepat dan jangan terlalu lama memasak adonan.', 'puding.jpg'),
(4, 3, 'Cara Membuat Jus Alpukat Creamy', '2025-05-24 08:30:00', 'Tambahkan susu kental manis dan es batu secukupnya untuk membuat jus alpukat menjadi creamy dan lebih nikmat.', 'jus.jpg'),
(5, 2, 'Teknik Memasak Daging Sapi Agar Empuk', '2025-05-24 08:40:00', 'Pilih potongan daging yang lebih muda dan masak dengan api kecil untuk mendapatkan daging yang empuk dan mudah dipotong.', 'daging.jpg'),
(6, 1, 'Cara Mengolah Tahu Agar Tidak Hancur', '2025-05-24 08:50:00', 'Peras tahu terlebih dahulu sebelum dimasak untuk mengurangi kandungan air dan agar tekstur tahu tetap padat.', 'tahu.jpg'),
(7, 4, 'Tips Memasak Sup Agar Kuahnya Lebih Kaya Rasa', '2025-05-24 09:00:00', 'Tambahkan kaldu ayam atau daging yang sudah dimasak terlebih dahulu untuk menghasilkan rasa yang lebih dalam dan gurih.', 'sup.jpg'),
(8, 3, 'Cara Menyimpan Ikan Agar Tetap Segar', '2025-05-24 09:10:00', 'Simpan ikan dalam kantong plastik tertutup rapat di dalam kulkas dan pastikan ikan disimpan pada suhu yang tepat.', 'ikan.jpg'),
(9, 1, 'Tips Menyimpan Sayuran Agar Tetap Segar', '2025-05-24 09:20:00', 'Gunakan wadah kedap udara untuk menyimpan sayuran di dalam kulkas dan jangan mencucinya sebelum disimpan.', 'sayur.jpg'),
(10, 2, 'Cara Memasak Nasi Goreng Agar Tidak Menggumpal', '2025-05-24 09:30:00', 'Pastikan nasi yang digunakan adalah nasi yang sudah dingin dan gunakan sedikit minyak saat menggoreng nasi.', 'nasigoreng.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int NOT NULL,
  `nama_user` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `nama_user`, `email`, `tanggal_lahir`, `created_at`) VALUES
(1, 'Kucing Sedih', 'tungtungtung@gmail.com', '1995-05-23', '2025-05-23 03:37:14'),
(2, 'Budi Pratama', 'budi.pratama@example.com', '1992-06-17', '2025-05-24 10:00:00'),
(3, 'Cynthia Dewi', 'cynthia.dewi@example.com', '1990-09-12', '2025-05-24 10:05:00'),
(4, 'Doni Saputra', 'doni.saputra@example.com', '1994-11-22', '2025-05-24 10:10:00'),
(5, 'Eva Riana', 'eva.riana@example.com', '1996-03-11', '2025-05-24 10:15:00'),
(6, 'Fahri Yusuf', 'fahri.yusuf@example.com', '1991-05-05', '2025-05-24 10:20:00'),
(7, 'Gita Amelia', 'gita.amelia@example.com', '1993-07-19', '2025-05-24 10:25:00'),
(8, 'Hendra Kusuma', 'hendra.kusuma@example.com', '1995-12-03', '2025-05-24 10:30:00'),
(9, 'Irma Wahyuni', 'irma.wahyuni@example.com', '1994-04-29', '2025-05-24 10:35:00'),
(10, 'Joko Widodo', 'joko.widodo@example.com', '1996-02-10', '2025-05-24 10:40:00'),
(11, 'Karla Putri', 'karla.putri@example.com', '1992-08-22', '2025-05-24 10:45:00'),
(12, 'Lia Oktaviani', 'lia.oktaviani@example.com', '1993-01-08', '2025-05-24 10:50:00'),
(13, 'Mukti Wahyu', 'mukti.wahyu@example.com', '1990-05-13', '2025-05-24 10:55:00'),
(14, 'Nadia Kartika', 'nadia.kartika@example.com', '1995-03-28', '2025-05-24 11:00:00'),
(15, 'Oka Prabowo', 'oka.prabowo@example.com', '1994-07-20', '2025-05-24 11:05:00'),
(16, 'Putri Sari', 'putri.sari@example.com', '1996-12-05', '2025-05-24 11:10:00'),
(17, 'Qori Alamsyah', 'qori.alamsyah@example.com', '1998-02-17', '2025-05-24 11:15:00'),
(18, 'Rudi Fajar', 'rudi.fajar@example.com', '1991-06-21', '2025-05-24 11:20:00'),
(19, 'Sari Ayu', 'sari.ayu@example.com', '1997-09-04', '2025-05-24 11:25:00'),
(20, 'Tina Fadila', 'tina.fadila@example.com', '1993-10-15', '2025-05-24 11:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

CREATE TABLE `wishlist` (
  `id_wishlist` int NOT NULL,
  `id_user` int DEFAULT NULL,
  `id_resep` int DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wishlist`
--

INSERT INTO `wishlist` (`id_wishlist`, `id_user`, `id_resep`, `timestamp`) VALUES
(1, 1, 1, '2025-05-24 08:00:00'),
(2, 1, 2, '2025-05-24 08:05:00'),
(3, 2, 3, '2025-05-24 08:10:00'),
(4, 2, 4, '2025-05-24 08:15:00'),
(5, 3, 6, '2025-05-24 08:20:00'),
(6, 4, 7, '2025-05-24 08:25:00'),
(7, 5, 1, '2025-05-24 08:30:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alat`
--
ALTER TABLE `alat`
  ADD PRIMARY KEY (`id_alat`),
  ADD KEY `id_resep` (`id_resep`);

--
-- Indexes for table `bahan`
--
ALTER TABLE `bahan`
  ADD PRIMARY KEY (`id_bahan`),
  ADD KEY `id_resep` (`id_resep`),
  ADD KEY `id_satuan` (`id_satuan`);

--
-- Indexes for table `discussion`
--
ALTER TABLE `discussion`
  ADD PRIMARY KEY (`id_discuss`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `reply_to` (`reply_to`);

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`id_history`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_resep` (`id_resep`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `langkah`
--
ALTER TABLE `langkah`
  ADD PRIMARY KEY (`id_langkah`),
  ADD KEY `id_prosedur` (`id_prosedur`);

--
-- Indexes for table `nutrisi`
--
ALTER TABLE `nutrisi`
  ADD PRIMARY KEY (`id_nutrisi`),
  ADD KEY `id_resep` (`id_resep`);

--
-- Indexes for table `penyakit`
--
ALTER TABLE `penyakit`
  ADD PRIMARY KEY (`id_penyakit`);

--
-- Indexes for table `prosedur`
--
ALTER TABLE `prosedur`
  ADD PRIMARY KEY (`id_prosedur`),
  ADD KEY `id_resep` (`id_resep`);

--
-- Indexes for table `resep`
--
ALTER TABLE `resep`
  ADD PRIMARY KEY (`id_resep`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`id_review`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_resep` (`id_resep`);

--
-- Indexes for table `riwayat_user`
--
ALTER TABLE `riwayat_user`
  ADD PRIMARY KEY (`id_riwayat`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_penyakit` (`id_penyakit`);

--
-- Indexes for table `satuan`
--
ALTER TABLE `satuan`
  ADD PRIMARY KEY (`id_satuan`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`id_tag`),
  ADD KEY `id_resep` (`id_resep`);

--
-- Indexes for table `tag_tips`
--
ALTER TABLE `tag_tips`
  ADD PRIMARY KEY (`id_tag_tips`),
  ADD KEY `id_tips` (`id_tips`);

--
-- Indexes for table `tips`
--
ALTER TABLE `tips`
  ADD PRIMARY KEY (`id_tips`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id_wishlist`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_resep` (`id_resep`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alat`
--
ALTER TABLE `alat`
  MODIFY `id_alat` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `bahan`
--
ALTER TABLE `bahan`
  MODIFY `id_bahan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `discussion`
--
ALTER TABLE `discussion`
  MODIFY `id_discuss` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `history`
--
ALTER TABLE `history`
  MODIFY `id_history` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `langkah`
--
ALTER TABLE `langkah`
  MODIFY `id_langkah` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `nutrisi`
--
ALTER TABLE `nutrisi`
  MODIFY `id_nutrisi` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `penyakit`
--
ALTER TABLE `penyakit`
  MODIFY `id_penyakit` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `prosedur`
--
ALTER TABLE `prosedur`
  MODIFY `id_prosedur` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `resep`
--
ALTER TABLE `resep`
  MODIFY `id_resep` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `id_review` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `riwayat_user`
--
ALTER TABLE `riwayat_user`
  MODIFY `id_riwayat` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `satuan`
--
ALTER TABLE `satuan`
  MODIFY `id_satuan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `id_tag` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `tag_tips`
--
ALTER TABLE `tag_tips`
  MODIFY `id_tag_tips` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `tips`
--
ALTER TABLE `tips`
  MODIFY `id_tips` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `id_wishlist` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alat`
--
ALTER TABLE `alat`
  ADD CONSTRAINT `alat_ibfk_1` FOREIGN KEY (`id_resep`) REFERENCES `resep` (`id_resep`);

--
-- Constraints for table `bahan`
--
ALTER TABLE `bahan`
  ADD CONSTRAINT `bahan_ibfk_1` FOREIGN KEY (`id_resep`) REFERENCES `resep` (`id_resep`),
  ADD CONSTRAINT `bahan_ibfk_2` FOREIGN KEY (`id_satuan`) REFERENCES `satuan` (`id_satuan`);

--
-- Constraints for table `discussion`
--
ALTER TABLE `discussion`
  ADD CONSTRAINT `discussion_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `discussion_ibfk_2` FOREIGN KEY (`reply_to`) REFERENCES `discussion` (`id_discuss`);

--
-- Constraints for table `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `history_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `history_ibfk_2` FOREIGN KEY (`id_resep`) REFERENCES `resep` (`id_resep`);

--
-- Constraints for table `langkah`
--
ALTER TABLE `langkah`
  ADD CONSTRAINT `langkah_ibfk_1` FOREIGN KEY (`id_prosedur`) REFERENCES `prosedur` (`id_prosedur`);

--
-- Constraints for table `nutrisi`
--
ALTER TABLE `nutrisi`
  ADD CONSTRAINT `nutrisi_ibfk_1` FOREIGN KEY (`id_resep`) REFERENCES `resep` (`id_resep`);

--
-- Constraints for table `prosedur`
--
ALTER TABLE `prosedur`
  ADD CONSTRAINT `prosedur_ibfk_1` FOREIGN KEY (`id_resep`) REFERENCES `resep` (`id_resep`);

--
-- Constraints for table `resep`
--
ALTER TABLE `resep`
  ADD CONSTRAINT `resep_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `resep_ibfk_2` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`);

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `review_ibfk_2` FOREIGN KEY (`id_resep`) REFERENCES `resep` (`id_resep`);

--
-- Constraints for table `riwayat_user`
--
ALTER TABLE `riwayat_user`
  ADD CONSTRAINT `riwayat_user_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `riwayat_user_ibfk_2` FOREIGN KEY (`id_penyakit`) REFERENCES `penyakit` (`id_penyakit`);

--
-- Constraints for table `tag`
--
ALTER TABLE `tag`
  ADD CONSTRAINT `tag_ibfk_1` FOREIGN KEY (`id_resep`) REFERENCES `resep` (`id_resep`);

--
-- Constraints for table `tag_tips`
--
ALTER TABLE `tag_tips`
  ADD CONSTRAINT `tag_tips_ibfk_1` FOREIGN KEY (`id_tips`) REFERENCES `tips` (`id_tips`);

--
-- Constraints for table `tips`
--
ALTER TABLE `tips`
  ADD CONSTRAINT `tips_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`id_resep`) REFERENCES `resep` (`id_resep`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
