import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/reusable_form_components.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/TransactionDetailController.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransactionDetailController>();
    final currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (c.detailData.isEmpty) return const Center(child: Text("Data tidak ditemukan"));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // CARD 1: INFORMASI TRANSAKSI
              FormSectionCard(
                title: 'Informasi Transaksi',
                subtitle: 'Data umum terkait transaksi ini',
                icon: Icons.receipt_long_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDataColumn('Kode Transaksi', c.invoiceNumber)),
                        Expanded(child: _buildDataColumn('Tanggal Transaksi', c.transactionDate)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDataColumn('Kasir', c.cashierName)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Metode Pembayaran', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                              const SizedBox(height: 4),
                              _buildBadge(c.paymentMethod, Icons.payments, AppColors.success),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Status', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                        const SizedBox(height: 4),
                        _buildBadge('Lunas', Icons.check_circle, AppColors.success),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // CARD 2: RINGKASAN PEMBAYARAN
              FormSectionCard(
                title: 'Ringkasan Pembayaran',
                subtitle: 'Detail nominal pembayaran',
                icon: Icons.account_balance_wallet_outlined,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildDataColumn('Total Belanja', currencyFormatter.format(c.total), valueColor: AppColors.success)),
                    Expanded(child: _buildDataColumn('Jumlah Dibayar', currencyFormatter.format(c.paidAmount))),
                    Expanded(child: _buildDataColumn('Kembalian', currencyFormatter.format(c.changeAmount), valueColor: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // CARD 3: DETAIL PRODUK
              FormSectionCard(
                title: 'Detail Produk',
                subtitle: 'Daftar item yang dibeli',
                icon: Icons.shopping_bag_outlined,
                child: c.items.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: Text("Data produk tidak tersedia", style: TextStyle(color: AppColors.textHint))),
                      )
                    : Column(
                        children: c.items.map((item) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${c.getItemQty(item)}x',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c.getItemName(item), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      const SizedBox(height: 4),
                                      Text('@ ${currencyFormatter.format(c.getItemPrice(item))}', style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Subtotal', style: TextStyle(color: AppColors.textHint, fontSize: 10)),
                                    Text(
                                      currencyFormatter.format(c.getItemSubtotal(item)),
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDataColumn(String label, String value, {Color valueColor = AppColors.textPrimary}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: valueColor)),
      ],
    );
  }

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}