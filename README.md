UAS Pemrograman Mobile 2
Nama : Sofia Risa Aulia
NPM : 23552011299
Kelas : TIF 23 CNS A
Universitas Teknologi Bandung

🎫 EVORA - Multi-Platform Event Ticket Solution
EVORA adalah aplikasi pemesanan tiket konser modern yang dirancang untuk platform Web dan Mobile menggunakan Flutter. Proyek ini mendemonstrasikan integrasi hybrid antara Firebase untuk data inti dan MockAPI untuk data dinamis, menciptakan ekosistem aplikasi yang fungsional dan responsif.

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
# Menjalankan aplikasi di Chrome tanpa proteksi keamanan CORS
flutter run -d chrome --web-browser-flag "--disable-web-security"

