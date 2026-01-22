import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'success_page.dart';

class CheckoutPage extends StatefulWidget {
  // REVISI: Tambahkan field data agar sinkron dengan onGenerateRoute di main.dart
  final Map<String, dynamic>? data;
  const CheckoutPage({super.key, this.data}); // Tambahkan ke constructor

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int quantity = 1;
  String selectedMethod = "";
  bool _isInitialized = false;

  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "ATM Transfer", "icon": Icons.account_balance},
    {"name": "Debit Card", "icon": Icons.credit_card},
    {"name": "Scan QRIS", "icon": Icons.qr_code_scanner},
  ];

  @override
  Widget build(BuildContext context) {
    // REVISI: Mengambil data dari widget.data (jika ada) atau dari ModalRoute (fallback)
    final args = widget.data ?? ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    // Defensive programming: Gunakan fallback jika data null
    //
    final artist = args?['artist'] ?? args?['artis'] ?? "Unknown Event"; 
    final tour = args?['tour'] ?? "World Tour 2026";
    final category = args?['category'] ?? "General Admission";
    final priceString = args?['price']?.toString() ?? "0";
    final image = args?['image'] ?? "";

    if (!_isInitialized) {
      quantity = args?['quantity'] ?? 1;
      _isInitialized = true;
    }

    // Parsing harga yang aman dari simbol mata uang
    int pricePerTicket = 0;
    try {
      pricePerTicket = int.parse(priceString.replaceAll(RegExp(r'[^0-9]'), ''));
    } catch (e) {
      pricePerTicket = 0;
    }
    
    int totalAmount = pricePerTicket * quantity;
    String formattedTotal = "Rp ${totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        title: Text("Checkout", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ORDER SUMMARY", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), 
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  _rowSummary("Event", artist),
                  const SizedBox(height: 10),
                  _rowSummary("Tour", tour),
                  const SizedBox(height: 10),
                  _rowSummary("Category", category),
                  const Divider(color: Colors.white10, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Quantity", style: TextStyle(color: Colors.white54)),
                      Row(
                        children: [
                          _qtyButton(Icons.remove, () {
                            if (quantity > 1) setState(() => quantity--);
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text("$quantity", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          _qtyButton(Icons.add, () => setState(() => quantity++)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(formattedTotal, style: GoogleFonts.poppins(color: const Color(0xFFE53170), fontWeight: FontWeight.w900, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            Text("PAYMENT METHOD", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
            const SizedBox(height: 15),
            ...paymentMethods.map((method) {
              bool isSelected = selectedMethod == method['name'];
              return GestureDetector(
                onTap: () => setState(() => selectedMethod = method['name']),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE53170).withOpacity(0.1) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: isSelected ? const Color(0xFFE53170) : Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Icon(method['icon'], color: isSelected ? const Color(0xFFE53170) : Colors.white54),
                      const SizedBox(width: 15),
                      Text(method['name'], style: GoogleFonts.poppins(color: Colors.white)),
                      const Spacer(),
                      if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFE53170)),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: selectedMethod.isEmpty 
                    ? null 
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SuccessPage(),
                            settings: RouteSettings(
                              arguments: {
                                "artist": artist,
                                "tour": tour, 
                                "image": image,
                                "category": category,
                                "price": formattedTotal,
                                "method": selectedMethod,
                                "qty": quantity.toString(),
                              },
                            ),
                          ),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53170),
                  disabledBackgroundColor: Colors.white10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  selectedMethod.isEmpty ? "SELECT PAYMENT METHOD" : "CONFIRM & PAY",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowSummary(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE53170)), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFFE53170), size: 20),
      ),
    );
  }
}