import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  Future<List<dynamic>> fetchExternalNews() async {
    const String mockUrl = "https://6970524d78fec16a63fd5d15.mockapi.io/external_news";
    try {
      final response = await http.get(Uri.parse(mockUrl));
      if (response.statusCode == 200) return json.decode(response.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  void _showNewsDetail(BuildContext context, String artist, String title, String content, String image) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF16161a),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 25),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  image, 
                  fit: BoxFit.cover, 
                  height: 250,
                  errorBuilder: (context, error, stackTrace) => Container(height: 250, color: Colors.grey[900], child: const Icon(Icons.broken_image, color: Colors.white24)),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                artist.toUpperCase(),
                style: GoogleFonts.poppins(color: const Color(0xFFE53170), fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
              ),
              const Divider(color: Colors.white10, height: 40),
              Text(
                content,
                style: GoogleFonts.poppins(color: Colors.white70, height: 1.8, fontSize: 16),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return FutureBuilder<List<dynamic>>(
      future: fetchExternalNews(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text("TRENDING NOW", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
            SizedBox(
              height: 240, 
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  String artist = (item['artis'] ?? item['artist'] ?? 'TRENDING').toString();
                  String title = (item['title'] ?? 'No Title').toString();
                  String content = (item['content'] ?? 'No content available').toString();
                  String imageUrl = (item['image'] ?? '').toString();
                  
                  return InkWell(
                    onTap: () => _showNewsDetail(context, artist, title, content, imageUrl),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(imageUrl, height: 130, width: 280, fit: BoxFit.cover, 
                                errorBuilder: (c, e, s) => Container(height: 130, color: Colors.grey[900])),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  artist.toUpperCase(),
                                  style: const TextStyle(color: Color(0xFFE53170), fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  title, 
                                  maxLines: 2, 
                                  overflow: TextOverflow.ellipsis, 
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0F0E17),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("ARTIST PORTAL", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5, color: Colors.white)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFE53170), Color(0xFF0F0E17)],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildTrendingSection(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("LATEST NEWS", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ]),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('news').orderBy('date', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return SliverToBoxAdapter(child: Center(child: Text("Error: ${snapshot.error}")));
              if (!snapshot.hasData) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: Color(0xFFE53170))));

              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var doc = snapshot.data!.docs[index];
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      
                      String artist = (data['artist'] ?? data['artis'] ?? 'General News').toString();
                      String title = (data['title'] ?? 'No Title Available').toString();
                      String content = (data['content'] ?? 'No Description Available').toString();
                      String imageUrl = (data['image'] ?? '').toString();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () => _showNewsDetail(context, artist, title, content, imageUrl),
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.network(imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(height: 250, color: Colors.grey[900])),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE53170).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(artist.toUpperCase(), style: const TextStyle(color: Color(0xFFE53170), fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                    const SizedBox(height: 8),
                                    Text(content, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                                    const SizedBox(height: 15),
                                    const Row(
                                      children: [
                                        Text("READ MORE", style: TextStyle(color: Color(0xFFE53170), fontWeight: FontWeight.bold, fontSize: 12)),
                                        SizedBox(width: 5),
                                        Icon(Icons.arrow_forward_rounded, color: Color(0xFFE53170), size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data!.docs.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}