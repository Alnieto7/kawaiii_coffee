import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/TransactionReusableComponents.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/reusable_form_components.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/TransactionDetailController.dart';

class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransactionDetailController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (c.detailData.isEmpty)
          return const Center(child: Text("Data tidak ditemukan"));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ── CARD 1: INFORMASI TRANSAKSI ──
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
                        Expanded(
                          child: DataColumnWidget(
                            label: 'Kode Transaksi',
                            value: c.invoiceNumber,
                          ),
                        ),
                        Expanded(
                          child: DataColumnWidget(
                            label: 'Tanggal Transaksi',
                            value: c.transactionDate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DataColumnWidget(
                            label: 'Kasir',
                            value: c.cashierName,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Metode Pembayaran',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textHint,
                                ),
                              ),
                              const SizedBox(height: 4),
                              StatusBadgeWidget(
                                text: c.paymentMethod,
                                icon: Icons.payments,
                                color: AppColors.success,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 4),
                        StatusBadgeWidget(
                          text: 'Lunas',
                          icon: Icons.check_circle,
                          color: AppColors.success,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── CARD 2: RINGKASAN PEMBAYARAN ──
              FormSectionCard(
                title: 'Ringkasan Pembayaran',
                subtitle: 'Detail nominal pembayaran',
                icon: Icons.account_balance_wallet_outlined,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DataColumnWidget(
                        label: 'Total Belanja',
                        value: c.formattedTotal,
                        valueColor: AppColors.success,
                      ),
                    ),
                    Expanded(
                      child: DataColumnWidget(
                        label: 'Jumlah Dibayar',
                        value: c.formattedPaidAmount,
                      ),
                    ),
                    Expanded(
                      child: DataColumnWidget(
                        label: 'Kembalian',
                        value: c.formattedChangeAmount,
                        valueColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── CARD 3: DETAIL PRODUK ──
              FormSectionCard(
                title: 'Detail Produk',
                subtitle: 'Daftar item yang dibeli',
                icon: Icons.shopping_bag_outlined,
                child: c.items.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            "Data produk tidak tersedia",
                            style: TextStyle(color: AppColors.textHint),
                          ),
                        ),
                      )
                    : Column(
                        children: c.items.map((item) {
                          return ProductDetailItemWidget(
                            qty: c.getItemQty(item),
                            name: c.getItemName(item),
                            price: c.formattedItemPrice(item),
                            subtotal: c.formattedItemSubtotal(item),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 24),

              // ── DROPDOWN LIHAT NOTA ──
              ReceiptDropdownWidget(c: c),
              const SizedBox(height: 16),

              // ── BUTTON PRINT ──
              Obx(() => ElevatedButton.icon(
                onPressed: c.isPrinting.value ? null : () => c.printStruk(),
                icon: c.isPrinting.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textOnPrimary,
                        ),
                      )
                    : const Icon(Icons.print),
                label: Text(c.isPrinting.value ? 'Mencetak...' : 'Print Nota'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}