import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/History/filter_chip.dart';
import 'package:kawaiii_coffee/Component/History/sectiontitle.dart';
import 'package:kawaiii_coffee/Component/History/summary_card.dart';
import 'package:kawaiii_coffee/Component/History/transactioncard.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [

            // 🔙 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Riwayat Transaksi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(Icons.search),
                ],
              ),
            ),

            // 🔘 FILTER
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  FilterChipItem(label: "Hari Ini", selected: true),
                  FilterChipItem(label: "Kemarin"),
                  FilterChipItem(label: "7 Hari Terakhir"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 📊 SUMMARY
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SummaryCard(),
            ),

            const SizedBox(height: 12),

            // 📋 LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [

                  SectionTitle("TERBARU"),

                  TransactionCard(
                    code: "#CS-1082",
                    price: "Rp 85.000",
                    time: "14:20",
                    items: "3 items",
                    cashier: "Andi",
                    status: "done",
                  ),

                  TransactionCard(
                    code: "#CS-1081",
                    price: "Rp 32.000",
                    time: "13:45",
                    items: "1 item",
                    cashier: "Andi",
                    status: "done",
                  ),

                  TransactionCard(
                    code: "#CS-1080",
                    price: "Rp 125.000",
                    time: "13:10",
                    items: "5 items",
                    cashier: "Andi",
                    status: "void",
                  ),

                  SectionTitle("TADI PAGI"),

                  TransactionCard(
                    code: "#CS-1079",
                    price: "Rp 56.500",
                    time: "09:15",
                    items: "2 items",
                    cashier: "Andi",
                    status: "done",
                  ),

                  TransactionCard(
                    code: "#CS-1078",
                    price: "Rp 18.000",
                    time: "08:50",
                    items: "1 item",
                    cashier: "Andi",
                    status: "done",
                  ),
                ],
              ),
            ),

            // 🔽 BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton(
                onPressed: () {},
                child: const Text("Tampilkan Lebih Banyak"),
              ),
            )
          ],
        ),
      ),
    );
  }
}