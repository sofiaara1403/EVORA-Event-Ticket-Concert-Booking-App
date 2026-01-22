UAS Pemrograman Mobile 2
Nama : Sofia Risa Aulia
NPM : 23552011299
Kelas : TIF 23 CNS A
Universitas Teknologi Bandung

🎫 EVORA - Multi-Platform Event Ticket Solution
EVORA adalah aplikasi pemesanan tiket konser modern yang dirancang untuk platform Web dan Mobile menggunakan Flutter. Proyek ini mendemonstrasikan integrasi hybrid antara Firebase untuk data inti dan MockAPI untuk data dinamis, menciptakan ekosistem aplikasi yang fungsional dan responsif.

📱 Struktur 7+ Halaman Dinamis
Berikut adalah daftar halaman dinamis yang dikembangkan dalam proyek ini:
- Dashboard/Home Page (Dynamic): Menampilkan banner konser yang ditarik secara dinamis dari Firebase Firestore.
- Trending News Page (Dynamic): Menggunakan data dari MockAPI untuk menampilkan berita musik terbaru secara real-time.
- Search & Filter Page (Dynamic): Memungkinkan pengguna mencari artis atau kategori tiket dengan hasil yang berubah sesuai input pengguna.
- Event Detail Page (Dynamic): Menampilkan rincian spesifik konser (deskripsi, harga, lokasi) berdasarkan ID konser yang dipilih dari Firebase.
- Checkout/Booking Page (Dynamic): Halaman formulir pemesanan yang menghitung total harga secara otomatis berdasarkan kuantitas tiket yang dipilih pengguna.
- Payment Success Page (Dynamic): Menampilkan pesan sukses dengan animasi elastis dan rangkuman transaksi yang dikirim melalui state management.
- My E-Ticket Page (Dynamic): Halaman inti yang merender data transaksi (Order ID, Harga, Kategori) dan menghasilkan QR Code unik secara dinamis.

🏗️ Arsitektur Data & Alur Kerja (Hybrid Backend)
Aplikasi ini menggunakan dua sumber data berbeda untuk mengelola informasi secara efisien:

1. Firebase Cloud (Data Event Utama)
Fungsi: Digunakan sebagai penyimpanan utama untuk informasi konser/event besar.

Implementasi: Data seperti daftar artis (misal: BLACKPINK, BRUNO MARS), lokasi stadion, dan jadwal utama diambil langsung dari Firebase Firestore.

Konfigurasi: Terhubung melalui file firebase_options.dart yang menangani otentikasi API key untuk platform Web dan Android.

2. MockAPI (Trending News & Real-time Content)
Fungsi: Digunakan untuk mengelola konten yang sering berubah seperti bagian "Trending Now" atau berita musik terbaru.

Implementasi: Aplikasi melakukan HTTP Request ke MockAPI untuk menarik data JSON yang kemudian ditampilkan pada News Feed di halaman utama.

Alasan Penggunaan: Mempercepat proses prototyping dan simulasi REST API tanpa beban biaya server tambahan.

✨ Fitur Utama (Features)
- Cross-Platform Compatibility: Berjalan sempurna di browser (Web) dan perangkat mobile dengan penyesuaian UI otomatis.
- Hybrid Data Loading: Menggabungkan data statis dari Firebase dan data dinamis dari MockAPI dalam satu tampilan Dashboard.
- Advanced Animation System: Menggunakan TweenAnimationBuilder untuk memberikan efek Elastic Pop pada status sukses dan Staggered Slide pada kartu tiket.
- E-Ticket Generator & Exporter:
Menghasilkan QR Code unik untuk validasi masuk.
Fitur "Download E-Ticket" yang mengonversi widget Flutter menjadi gambar .png berkualitas tinggi menggunakan library screenshot.

🛠️ Tech Stack & Pengembangan
Framework: Flutter & Dart (Frontend & Logic).
IDE: Visual Studio Code dengan integrasi Flutter & Git Extension.
Deployment: Netlify (Hosting Web) untuk aksesibilitas publik yang cepat.
Libraries: http, google_fonts, screenshot, firebase_core.

🚀 Cara Menjalankan Aplikasi (Versi Web)
Karena aplikasi memuat aset dari berbagai domain (Firebase & MockAPI), gunakan perintah berikut untuk menghindari kendala keamanan browser (CORS) saat demonstrasi:

PowerShell
flutter run -d chrome --web-browser-flag "--disable-web-security"

🔥Tampilan Mobile (Android)🔥

❄️Login & Register
<img width="718" height="1599" alt="image" src="https://github.com/user-attachments/assets/5b9a4f81-7088-4036-b9d5-ee222ff3cf81" />
<img width="718" height="1599" alt="image" src="https://github.com/user-attachments/assets/249f78ed-8b7e-46c0-a0f0-6c0fc9e9ebc7" />

☀️Dashboard Event (Dark Mode & Light Mode)
<img width="486" height="1600" alt="image" src="https://github.com/user-attachments/assets/d9ad5023-faa0-49e9-aba2-7c796e945ea4" />
<img width="360" height="1313" alt="image" src="https://github.com/user-attachments/assets/06d87726-19e5-403b-8ee6-8ae4c80a11cd" />

🪐Booking Ticket
<img width="718" height="1599" alt="image" src="https://github.com/user-attachments/assets/c8bda690-ac72-4484-b92d-c2e36a2aa68d" />
<img width="718" height="1599" alt="image" src="https://github.com/user-attachments/assets/f114c4e4-c586-4a5e-8cd1-d0760d0add0a" />
<img width="718" height="1599" alt="image" src="https://github.com/user-attachments/assets/0e82bce6-d6df-4c24-b625-64fc13803d6b" />
<img width="718" height="1599" alt="image" src="https://github.com/user-attachments/assets/ad56a22a-a1d2-4ae9-8533-4f241783852e" />
<img width="718" height="1599" alt="image" src="https://github.com/user-attachments/assets/73f5701b-bfbb-4a13-81ec-1a996d8a73ec" />

🍭News Portal
<img width="521" height="1600" alt="image" src="https://github.com/user-attachments/assets/686d75af-5954-4e42-8ec8-eae4c782446a" />
<img width="718" height="1599" alt="image" src="https://github.com/user-attachments/assets/d9d38909-2cc5-4046-9934-46da7257efd6" />


🍒Tampilan Web🍒












flutter run -d chrome --web-browser-flag "--disable-web-security"

