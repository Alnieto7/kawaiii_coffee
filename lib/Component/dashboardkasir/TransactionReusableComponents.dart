import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/TransactionDetailController.dart';
import 'package:kawaiii_coffee/Component/struk/receipt_info_row.dart';
import 'package:kawaiii_coffee/Component/struk/receipt_item_title.dart';
import 'package:kawaiii_coffee/Component/struk/receipt_total_row.dart';

class DataColumnWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const DataColumnWidget({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: valueColor)),
      ],
    );
  }
}

class StatusBadgeWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const StatusBadgeWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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

class ProductDetailItemWidget extends StatelessWidget {
  final dynamic qty;
  final String name;
  final String price;
  final String subtotal;

  const ProductDetailItemWidget({
    super.key,
    required this.qty,
    required this.name,
    required this.price,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
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
              '${qty}x',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('@ $price', style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Subtotal', style: TextStyle(color: AppColors.textHint, fontSize: 10)),
              Text(
                subtotal,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReceiptDropdownWidget extends StatelessWidget {
  final TransactionDetailController c;

  const ReceiptDropdownWidget({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: ExpansionTile(
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textSecondary,
          title: const Text(
            'Lihat Nota Lengkap',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          leading: const Icon(Icons.receipt_long_outlined, color: AppColors.primary),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 20),
                  Container(
                    width: 60, height: 60,
                    decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
                    child: const Icon(Icons.coffee, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(height: 12),
                  const Text('Coffee Street', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Terima kasih telah berbelanja', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 24),
                  ReceiptInfoRow(title: 'Invoice', value: c.invoiceNumber),
                  ReceiptInfoRow(title: 'Tanggal', value: c.transactionDate),
                  ReceiptInfoRow(title: 'Kasir', value: c.cashierName),
                  ReceiptInfoRow(title: 'Pembayaran', value: c.paymentMethod),
                  const SizedBox(height: 18),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      Text('Item', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                      Spacer(),
                      Text('Subtotal', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...c.items.map((item) {
                    return ReceiptItemTile(
                      title: c.getItemName(item),
                      qtyPrice: '${c.getItemQty(item)} x ${c.formattedItemPrice(item)}',
                      subtotal: c.formattedItemSubtotal(item),
                    );
                  }).toList(),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),
                  ReceiptTotalRow(title: 'Total', value: c.formattedTotal),
                  const SizedBox(height: 10),
                  ReceiptTotalRow(title: 'Dibayar', value: c.formattedPaidAmount),
                  const SizedBox(height: 10),
                  ReceiptTotalRow(title: 'Kembalian', value: c.formattedChangeAmount, valueColor: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}