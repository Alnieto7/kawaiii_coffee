import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/POS/category_chip.dart';
import 'package:kawaiii_coffee/Component/POS/productcard.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [

            // 🔽 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCECDD),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.coffee, color: Color(0xFFD97706)),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Coffee Street",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Kasir: Ahmad Fauzi",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_none)
                ],
              ),
            ),

            // 🔍 SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "Cari menu kopi...",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🏷 CATEGORY
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  CategoryChip(label: "Semua", selected: true),
                  CategoryChip(label: "Espresso Base"),
                  CategoryChip(label: "Manual Brew"),
                  CategoryChip(label: "Non Coffee"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🛍 PRODUCT GRID
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  ProductCard(
                    title: "Espresso Double",
                    price: "Rp 18.000",
                    image: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Joko_Widodo_2014_official_portrait.jpg/250px-Joko_Widodo_2014_official_portrait.jpg",
                  ),
                  ProductCard(
                    title: "Caffè Latte",
                    price: "Rp 25.000",
                    image: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Joko_Widodo_2014_official_portrait.jpg/250px-Joko_Widodo_2014_official_portrait.jpg",
                  ),
                  ProductCard(
                    title: "Cold Brew Signature",
                    price: "Rp 28.000",
                    image: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Joko_Widodo_2014_official_portrait.jpg/250px-Joko_Widodo_2014_official_portrait.jpg",
                  ),
                  ProductCard(
                    title: "Cappuccino",
                    price: "Rp 24.000",
                    image: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Joko_Widodo_2014_official_portrait.jpg/250px-Joko_Widodo_2014_official_portrait.jpg",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}