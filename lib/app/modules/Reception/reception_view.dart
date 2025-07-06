import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';

import 'reception_controller.dart';

class ReceptionView extends GetView<ReceptionController> {
   ReceptionView({super.key}){
    Get.lazyPut(()=>ReceptionView());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.supplierOrder.value?.orderNumber != null
              ? 'Réception ${controller.supplierOrder.value!.orderNumber}'
              : 'Réception',
        )),
        centerTitle: true,
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppSpacings.l),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSupplierCard(),
                        SizedBox(height: AppSpacings.l),
                        _buildProductsSection(),
                      ],
                    ),
                  ),
                ),
                _buildValidationButton(context),
              ],
            )),
    );
  }

  Widget _buildSupplierCard() {
    return Obx(() {
      final order = controller.supplierOrder.value;
      if (order == null) return SizedBox();
      final supplier = order.supplierLink.value;
      return Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacings.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fournisseur', style: AppTypography.bodyMedium.apply(color: AppColors.greyDark)),
              SizedBox(height: AppSpacings.s),
              Text(supplier?.name ?? '', style: AppTypography.titleMedium),
              SizedBox(height: AppSpacings.s),
              if (supplier?.email != null)
                Text(supplier!.email!, style: AppTypography.bodyMedium.apply(color: AppColors.greyDark)),
              if (supplier?.phone != null)
                Text(supplier!.phone!, style: AppTypography.bodyMedium.apply(color: AppColors.greyDark)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProductsSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Produits à Réceptionner', style: AppTypography.titleMedium),
        SizedBox(height: AppSpacings.s),
        ...controller.orderItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacings.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.productLink.value?.name ?? '',
                        style: AppTypography.bodyMedium,
                      ),
                    ),
                    _buildStatusIndicator(controller.getStatus(item)),
                  ],
                ),
                SizedBox(height: AppSpacings.s),
                Text(
                  'Qté Commandée: ${item.quantityOrdered}',
                  style: AppTypography.bodyMedium.apply(
                    color: AppColors.greyDark,
                  ),
                ),
                SizedBox(height: AppSpacings.s),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: item.quantityOrdered.toString(),
                          labelText: 'Qté Réceptionnée',
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                          text: (item.quantityReceived ?? 0) > 0
                              ? item.quantityReceived.toString()
                              : '',
                        ),
                        onChanged: (value) => controller.updateReceivedQty(index, value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () => controller.incrementQty(index),
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacings.s),
                // Champ numéro de lot
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Numéro de lot',
                  ),
                  controller: TextEditingController(text: item.lotNumber ?? ''),
                  onChanged: (v) => controller.updateLotNumber(index, v),
                ),
                SizedBox(height: AppSpacings.s),
                // Champ date de péremption
                Row(
                  children: [
                    Text('Date de péremption : ', style: AppTypography.bodySmall),
                    Text(item.expirationDate != null ? '${item.expirationDate!.day.toString().padLeft(2, '0')}/${item.expirationDate!.month.toString().padLeft(2, '0')}/${item.expirationDate!.year}' : 'Non renseignée', style: AppTypography.bodySmall),
                    IconButton(
                      icon: Icon(Icons.calendar_today, size: 18),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: Get.context!,
                          initialDate: item.expirationDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          controller.updateExpirationDate(index, picked);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: AppSpacings.s),
                // Champ commentaire par produit
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Commentaire (optionnel)',
                  ),
                  controller: TextEditingController(text: item.comment ?? ''),
                  onChanged: (v) => controller.updateItemComment(index, v),
                ),
                SizedBox(height: AppSpacings.l),
                Divider(height: AppSpacings.s, color: AppColors.greyLight),
              ],
            ),
          );
        }).toList(),
      ],
    ));
  }

  Widget _buildStatusIndicator(String status) {
    switch (status) {
      case 'complete':
        return Icon(Icons.check_circle, color: AppColors.accentColor);
      case 'partial':
        return Row(
          children: [
            Icon(Icons.warning_amber, color: AppColors.accentColor),
            SizedBox(width: AppSpacings.s),
            Text('Écart', style: AppTypography.bodyMedium.apply(color: AppColors.accentColor)),
          ],
        );
      case 'missing':
        return Icon(Icons.error_outline, color: AppColors.errorColor);
      default:
        return SizedBox();
    }
  }

  Widget _buildValidationButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacings.l),
      child: Column(
        children: [
          // Champ commentaire global
          Obx(() => TextField(
            decoration: InputDecoration(
              labelText: 'Commentaire global de réception (optionnel)',
            ),
            controller: TextEditingController(text: controller.receptionComment.value),
            onChanged: controller.updateReceptionComment,
          )),
          SizedBox(height: AppSpacings.s),
          Obx(() => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: Size(double.infinity, AppSpacings.xxxl*1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacings.m),
              ),
            ),
            onPressed: controller.isLoading.value
                ? null
                : () async {
                    final canValidate = await controller.canValidateReception();
                    if (!canValidate) {
                      final force = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Validation stricte'),
                          content: Text('Une quantité reçue dépasse la quantité commandée. Voulez-vous forcer la validation ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Annuler'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Forcer'),
                            ),
                          ],
                        ),
                      );
                      if (force == true) {
                        await controller.validateReception(force: true);
                      }
                    } else {
                      await controller.validateReception();
                    }
                  },
            child: controller.isLoading.value
                ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text('Valider la Réception', style: AppTypography.bodyMedium.apply(color: Colors.white)),
          )),
          SizedBox(height: AppSpacings.s),
          // Historique des validations
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.validationHistory.isNotEmpty)
                ...controller.validationHistory.map((h) => Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('Validation le ${h['date']} par ${h['user']} - ${h['details']}', style: AppTypography.bodySmall),
                )),
            ],
          )),
        ],
      ),
    );
  }
}

