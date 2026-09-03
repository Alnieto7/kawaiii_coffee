import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/History/transactioncard.dart';
import 'package:kawaiii_coffee/Controller/HistoryController.dart';
import 'package:kawaiii_coffee/Binding/TransactionDetailBinding.dart';
import 'package:kawaiii_coffee/Page/Kasir/TransactionDetailPage.dart';

class TransactionSearchDelegate extends SearchDelegate {
  final HistoryController controller;

  TransactionSearchDelegate(this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = controller.transactions.where((trx) {
      final invoice = trx.invoiceNumber?.toLowerCase() ?? '';
      final cashier = trx.cashierName?.toLowerCase() ?? '';

      return invoice.contains(query.toLowerCase()) ||
          cashier.contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('Transaksi tidak ditemukan'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: results.map((trx) {
        return GestureDetector(
          onTap: () {
            if (trx.id != null) {
              Get.to(
                () => const TransactionDetailPage(),
                binding: TransactionDetailBinding(),
                arguments: trx.id,
              );
            }
          },
          child: TransactionCard(
            code: "#${trx.invoiceNumber}",
            price: controller.formatRupiah(trx.total ?? 0),
            time: controller.formatTime(trx.createdAt!),
            items: "1 Item",
            cashier: trx.cashierName ?? "Kasir",
            status: "done",
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}