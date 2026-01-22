import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:evora_app/dummy_html.dart' if (dart.library.html) 'dart:html' as html;

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  ScreenshotController screenshotController = ScreenshotController();

  void _downloadTicket(String artistName) async {
    try {
      final imageBytes = await screenshotController.capture();
      if (imageBytes != null) {
        if (kIsWeb) {
          final blob = html.Blob([imageBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final html.AnchorElement anchor = html.AnchorElement(href: url)
            ..setAttribute("download", "EVORA-Ticket-$artistName.png")
            ..click(); 
          html.Url.revokeObjectUrl(url);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Download only supported on Web version")),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Download error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    
    // REVISI: Ambil lebih banyak detail dari args agar tidak kosong
    final String artist = args['artist']?.toString() ?? "BRUNO MARS";
    final String tour = args['tour']?.toString() ?? "The Romantic Tour 2026";
    final String category = args['category']?.toString() ?? "Gold VIP Package";
    final String qty = args['qty']?.toString() ?? "1";
    final String image = args['image']?.toString() ?? "";
    final String price = args['price']?.toString() ?? "Rp 0";
    final String orderId = args['order_id'] ?? "EVR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFE53170)),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        title: Text("My E-Ticket", 
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // BAGIAN GAMBAR HEADER (SESUAI REFERENSI)
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20), 
                          topRight: Radius.circular(20)
                        ),
                        image: image.isNotEmpty 
                          ? DecorationImage(image: NetworkImage(image), fit: BoxFit.cover) 
                          : null,
                      ),
                      child: image.isEmpty 
                        ? const Center(child: Icon(Icons.broken_image, color: Colors.white54)) 
                        : null,
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(artist.toUpperCase(), 
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.black)),
                          Text(tour, 
                            style: GoogleFonts.poppins(color: const Color(0xFFE53170), fontSize: 14, fontWeight: FontWeight.bold)),
                          
                          const SizedBox(height: 30),
                          
                          // INFO UTAMA (VENUE & DATE)
                          _buildEventDetail(Icons.location_on, "Venue", "Stadium International"),
                          _buildEventDetail(Icons.calendar_today, "Date", "29 Nov 2026"),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Colors.black12, thickness: 1),
                          ),
                          
                          // QR CODE (UKURAN DIPERBESAR)
                          Image.network(
                            'https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=$orderId',
                            height: 140,
                            errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.qr_code, size: 100, color: Colors.black),
                          ),
                          
                          const SizedBox(height: 10),
                          const Text("SCAN AT ENTRANCE", 
                            style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 4)),
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Colors.black12, thickness: 1),
                          ),
                          
                          // DETAIL TIKET (SESUAI REFERENSI BAWAH TIKET)
                          _buildInfoRow("Order ID", orderId),
                          _buildInfoRow("Category", category),
                          _buildInfoRow("Quantity", "$qty Ticket(s)"),
                          const Divider(height: 30, color: Colors.transparent),
                          _buildInfoRow("Total Paid", price, isBold: true), // MENAMBAH HARGA
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 35),
            
            // TOMBOL DOWNLOAD
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => _downloadTicket(artist),
                icon: const Icon(Icons.file_download_outlined, color: Colors.white),
                label: const Text("DOWNLOAD E-VOUCHER", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53170),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: const Color(0xFFE53170).withValues(alpha: 0.1), 
                shape: BoxShape.circle
            ),
            child: Icon(icon, size: 14, color: const Color(0xFFE53170)),
          ),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontSize: 14, color: Colors.black54)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black))),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          Text(value, 
            style: TextStyle(
              color: isBold ? const Color(0xFFE53170) : Colors.black, 
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold, 
              fontSize: isBold ? 18 : 14
            )
          ),
        ],
      ),
    );
  }
}