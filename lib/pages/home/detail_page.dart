import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const DetailPage({super.key, required this.data});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String selectedCategory = "";
  String selectedPrice = "";
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    bool isNews = widget.data.containsKey('content');
    String artistName = (widget.data['artist'] ?? widget.data['artis'] ?? "EVORA ARTIST").toString();
    final dynamic rawCategories = widget.data['categories'];
    List<dynamic> categories = (rawCategories is List) ? rawCategories : [];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Hero(
                    tag: widget.data['image'] ?? '', // REVISI: Hero Animation Tag sinkron dengan HomePage
                    child: Image.network(
                      widget.data['image'] ?? '', 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.broken_image, color: Colors.white24, size: 50),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (isNews ? (widget.data['title'] ?? artistName) : artistName).toString().toUpperCase(), 
                        style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isNews ? "LATEST UPDATES" : (widget.data['tour'] ?? "WORLD TOUR 2026"), 
                        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFFE53170), fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 25),
                      if (!isNews) ...[
                        _infoRow(Icons.calendar_month, widget.data['date'] ?? "Date TBA"),
                        _infoRow(Icons.location_on, widget.data['location'] ?? "Location TBA"),
                        const SizedBox(height: 30),
                        Text("🎤 ABOUT EVENT", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 10),
                        Text(
                          widget.data['about'] ?? "No description available.",
                          style: GoogleFonts.poppins(color: Colors.white70, height: 1.6),
                        ),
                      ],
                      if (isNews) ...[
                        const Divider(color: Colors.white10, height: 40),
                        Text(
                          widget.data['content'] ?? "No content available.",
                          style: GoogleFonts.poppins(color: Colors.white70, height: 1.8, fontSize: 16),
                        ),
                      ],
                      if (!isNews) ...[
                        const SizedBox(height: 40),
                        Text("💸 SELECT TICKET CATEGORY", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 15),
                        if (categories.isEmpty)
                          const Text("No categories available", style: TextStyle(color: Colors.white54))
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              var cat = categories[index];
                              String catName = cat['name']?.toString() ?? "Category ${index + 1}";
                              String catPrice = cat['price']?.toString() ?? "Rp 0";
                              bool isSelected = selectedCategory == catName;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = catName;
                                    selectedPrice = catPrice;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFE53170).withOpacity(0.15) : Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: isSelected ? const Color(0xFFE53170) : Colors.white10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(catName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                                      Text(catPrice, style: const TextStyle(color: Color(0xFFE53170), fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 30),
                        Text("🔢 QUANTITY", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _qtyButton(Icons.remove, () {
                              if (quantity > 1) setState(() => quantity--);
                            }),
                            SizedBox(
                              width: 60,
                              child: Center(
                                child: Text("$quantity", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            _qtyButton(Icons.add, () => setState(() => quantity++)),
                          ],
                        ),
                      ],
                      const SizedBox(height: 120), 
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isNews)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0E17),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: ElevatedButton(
                  onPressed: selectedCategory.isEmpty ? null : () {
                    Navigator.pushNamed(context, '/checkout', arguments: {
                      "artist": artistName,
                      "tour": widget.data['tour'] ?? "WORLD TOUR",
                      "category": selectedCategory,
                      "price": selectedPrice,
                      "quantity": quantity,
                      "image": widget.data['image'],
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53170),
                    disabledBackgroundColor: Colors.white10,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    selectedCategory.isEmpty ? "SELECT A CATEGORY" : "CONTINUE TO CHECKOUT ($quantity)", 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: const Color(0xFFE53170)),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFE53170).withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE53170), size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}