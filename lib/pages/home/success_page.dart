import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessPage extends StatelessWidget {
  final Map<String, dynamic>? data;
  const SuccessPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final args = data ?? ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    final artist = args?['artist'] ?? "Unknown Event";
    final tour = args?['tour'] ?? "World Tour 2026";
    final category = args?['category'] ?? "Category Name";
    final price = args?['price'] ?? "Rp 0";
    final method = args?['method'] ?? "Payment Method";
    final qty = args?['qty'] ?? "1";
    // Tambahan detail baru
    final orderId = args?['order_id'] ?? "EVR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final purchaseDate = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          children: [
            // 1. ANIMASI ICON: Dibuat lebih membal (Elastic)
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.elasticOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE53170).withValues(alpha: 0.3),
                          blurRadius: 20 * value,
                          spreadRadius: 5 * value,
                        )
                      ],
                    ),
                    child: const Icon(Icons.check_circle, color: Color(0xFFE53170), size: 100),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),

            // 2. ANIMASI TEKS: Muncul perlahan dari bawah (Fade & Slide)
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 10, end: 0),
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Opacity(
                    opacity: (10 - value) / 10,
                    child: Text(
                      "PAYMENT SUCCESSFUL",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            
            // 3. ANIMASI KARTU TIKET: Efek Slide Up
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 500),
              tween: Tween<double>(begin: 50, end: 0),
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Opacity(opacity: (50 - value) / 50, child: child),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53170),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("EVENT E-VOUCHER", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                              Text(orderId, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(artist.toUpperCase(), 
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                          Text(tour.toUpperCase(), 
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(Icons.confirmation_number_outlined, "Order ID", orderId),
                          _buildInfoRow(Icons.calendar_month_outlined, "Purchase Date", purchaseDate),
                          _buildInfoRow(Icons.location_on_outlined, "Venue", "Official Stadium International"),
                          const Divider(color: Colors.black12, height: 30),
                          
                          // Detail Isi Tiket Lebih Lengkap
                          _buildDetailRow("Ticket Category", category),
                          _buildDetailRow("Quantity", "$qty Ticket(s)"),
                          _buildDetailRow("Price per Ticket", price), // Menambah detail harga
                          _buildDetailRow("Payment Method", method),
                          
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text("STATUS: PAID / BERHASIL", 
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                          const Divider(color: Colors.black12, height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Payment", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                              Text(price, style: const TextStyle(color: Color(0xFFE53170), fontWeight: FontWeight.w900, fontSize: 22)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Variasi Guntingan Tiket di Bawah
                    Row(
                      children: List.generate(15, (index) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 15,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F0E17), 
                            borderRadius: index.isEven 
                                ? const BorderRadius.vertical(top: Radius.circular(10)) 
                                : const BorderRadius.vertical(bottom: Radius.circular(10))
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Navigasi
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/my-tickets', arguments: args),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53170),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: const Text("VIEW MY E-TICKET", 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper tetap sama dengan penyesuaian style sedikit
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFE53170).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: const Color(0xFFE53170)),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600)),
          ])
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}