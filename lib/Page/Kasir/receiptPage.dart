import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/struk/receipt_info_row.dart';
import 'package:kawaiii_coffee/Component/struk/receipt_item_title.dart';
import 'package:kawaiii_coffee/Component/struk/receipt_total_row.dart';
import 'package:kawaiii_coffee/Controller/receipt_controller.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReceiptController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

          leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            if (Get.isRegistered<CartController>()) {
              Get.find<CartController>().resetForNewTransaction();
            }
            Get.offAllNamed('/main');
          },
        ),

        title: const Text(
          'Struk Pembayaran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }

        if (controller.detailData.isEmpty) {
          return const Center(
            child: Text(
              'Data transaksi tidak ditemukan',
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  children: [

                    // ================= HEADER =================

                    Container(
                      width: 70,
                      height: 70,

                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.coffee,
                        color: Colors.orange,
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Coffee Street',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Terima kasih telah berbelanja',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= STATUS =================

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),

                          SizedBox(width: 6),

                          Text(
                            'Pembayaran Berhasil',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= INFO =================

                    ReceiptInfoRow(
                      title: 'Invoice',
                      value: controller.invoiceNumber,
                    ),

                    ReceiptInfoRow(
                      title: 'Tanggal',
                      value: controller.transactionDate,
                    ),

                    ReceiptInfoRow(
                      title: 'Kasir',
                      value: controller.cashierName,
                    ),

                    ReceiptInfoRow(
                      title: 'Pembayaran',
                      value: controller.paymentMethod,
                    ),

                    const SizedBox(height: 18),

                    Divider(
                      color: Colors.grey[300],
                    ),

                    const SizedBox(height: 14),

                    // ================= ITEM TITLE =================

                    Row(
                      children: [

                        Text(
                          'Item',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          'Subtotal',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ================= ITEM LIST =================

                    ...controller.items.map((item) {

                      return ReceiptItemTile(
                        title: controller.getItemName(item),

                        qtyPrice:
                            '${controller.getItemQty(item)} x '
                            '${controller.currencyFormatter.format(controller.getItemPrice(item))}',

                        subtotal: controller.currencyFormatter.format(
                          controller.getItemSubtotal(item),
                        ),
                      );

                    }).toList(),

                    Divider(
                      color: Colors.grey[300],
                    ),

                    const SizedBox(height: 16),

                    // ================= TOTAL =================

                    ReceiptTotalRow(
                      title: 'Total',
                      value: controller.currencyFormatter.format(
                        controller.total,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ReceiptTotalRow(
                      title: 'Dibayar',
                      value: controller.currencyFormatter.format(
                        controller.paidAmount,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ReceiptTotalRow(
                      title: 'Kembalian',
                      value: controller.currencyFormatter.format(
                        controller.changeAmount,
                      ),
                      valueColor: Colors.orange,
                    ),

                    const SizedBox(height: 24),

                    // ================= FOOTER =================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Column(
                        children: [

                          Icon(
                            Icons.favorite,
                            color: Colors.orange,
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Terima kasih telah berbelanja di Coffee Street',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= BUTTONS =================

                    Row(
                      children: [

                        Expanded(
                          child: OutlinedButton.icon(

                            onPressed: () {
                              if (Get.isRegistered<CartController>()) {
                                Get.find<CartController>().resetForNewTransaction();
                              }
                              Get.offAllNamed('/main');
                            },

                            icon: const Icon(
                              Icons.home_outlined,
                            ),

                            label: const Text(
                              'Home',
                            ),

                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(
                                double.infinity,
                                52,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton.icon(

                            onPressed: () {

                              Get.snackbar(
                                'Info',
                                'Fitur print segera ditambahkan',
                                snackPosition: SnackPosition.BOTTOM,
                              );

                            },

                            icon: const Icon(
                              Icons.print,
                            ),

                            label: const Text(
                              'Print',
                            ),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              elevation: 0,

                              minimumSize: const Size(
                                double.infinity,
                                52,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}