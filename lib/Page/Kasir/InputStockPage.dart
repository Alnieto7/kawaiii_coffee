import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/reusable_form_components.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/InputStockController.dart';
import 'package:kawaiii_coffee/Model/IngredientModel.dart';

class InputStokPage extends StatelessWidget {
  const InputStokPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<InputStokController>();

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
          'Create Pergerakan Stok',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              FormSectionCard(
                title: 'Detail Pergerakan Stok',
                subtitle: 'Catat bahan baku yang masuk atau keluar.',
                icon: Icons.sync_alt,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FormLabel('Bahan Baku', isRequired: true),
                    const SizedBox(height: 8),
                    CustomDropdown<IngredientModel>(
                      hint: 'Select an option',
                      value: c.selectedIngredient.value,
                      items: c.ingredients.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text('${item.name} (Sisa: ${item.stock} ${item.unit})'),
                        );
                      }).toList(),
                      onChanged: (val) => c.selectedIngredient.value = val,
                    ),
                    const SizedBox(height: 16),

                    const FormLabel('Jenis Pergerakan', isRequired: true),
                    const SizedBox(height: 8),
                    CustomDropdown<String>(
                      hint: 'Select an option',
                      value: c.selectedType.value,
                      items: c.movementTypes.map((type) {
                        return DropdownMenuItem(
                          value: type['value'],
                          child: Text(type['label']!),
                        );
                      }).toList(),
                      onChanged: (val) => c.selectedType.value = val,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FormLabel('Jumlah', isRequired: true),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: c.qtyController,
                                hint: '0',
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const FormLabel('Referensi'),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: c.refController,
                                hint: 'PO-2024-001',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              FormSectionCard(
                title: 'Dicatat Oleh',
                subtitle: 'Pengguna yang melakukan pencatatan stok.',
                icon: Icons.person_outline,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FormLabel('Nama Pengguna', isRequired: true),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Text(
                        c.userName.value,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              FormSectionCard(
                title: 'Keterangan',
                subtitle: 'Tambahkan catatan tambahan jika diperlukan.',
                icon: Icons.chat_bubble_outline,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FormLabel('Catatan'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: c.notesController,
                      hint: 'Contoh: Restock mingguan dari supplier utama',
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: c.isSubmitting.value ? null : c.submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: c.isSubmitting.value
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.textOnPrimary, strokeWidth: 2))
                          : const Text('Create', style: TextStyle(color: AppColors.textOnPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}