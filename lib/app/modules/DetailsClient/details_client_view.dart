import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/storage.dart';
// import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';
import 'package:get/get.dart';
import 'details_client_controller.dart';

class DetailsClientView extends GetView<DetailsClientController> {
  DetailsClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Obx(() => Text(
              controller.customer.value?.name != null
                  ? 'Fiche Client: ${controller.customer.value!.name}'
                  : 'Fiche Client',
              style: AppTypography.titleLarge,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(AppSpacings.s),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: AppRadius.medium,
            ),
            child: Icon(
              AppIcons.backArrow,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
            ),
          );
        }
        final customer = controller.customer.value;
        if (customer == null) {
          return Center(
            child: Text('Client introuvable', style: AppTypography.titleLarge),
          );
        }
        return SingleChildScrollView(
          padding: AppSpacings.screenPadding,
          child: Column(
            children: [
              _buildClientIdentityCard(customer),
              SizedBox(height: AppSpacings.l),
              _buildNavigationTabs(),
              SizedBox(height: AppSpacings.l),
              Obx(() {
                switch (controller.selectedTab.value) {
                  case 0:
                    return Column(
                      children: [
                        _buildAddressCard(customer),
                        SizedBox(height: AppSpacings.l),
                        _buildNotesCard(customer),
                        SizedBox(height: AppSpacings.l),
                        _buildDebtCard(),
                        SizedBox(height: AppSpacings.l),
                        _buildEditButton(),
                      ],
                    );
                  case 1:
                    return _buildSalesList();
                  case 2:
                    return _buildDebtsList();
                  default:
                    return SizedBox.shrink();
                }
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildClientIdentityCard(Customer customer) {
    final name = customer.name ?? '';
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : '?';
    return Card(
      elevation: 8,
      shadowColor: AppColors.primaryColor.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacings.xxl, horizontal: AppSpacings.xl),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.18),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primaryColor,
                    child: Text(
                      initials,
                      style: AppTypography.headline1.copyWith(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryColor.withOpacity(0.18),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(AppIcons.person, color: AppColors.textOnPrimary, size: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacings.l),
            Text(name, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: AppSpacings.s),
            if (customer.email != null && customer.email!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AppIcons.email, size: 18, color: AppColors.primaryColor),
                  SizedBox(width: AppSpacings.xs),
                  Text(customer.email!, style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryColor)),
                ],
              ),
            if (customer.phone != null && customer.phone!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AppIcons.phone, size: 18, color: AppColors.accentColor),
                  SizedBox(width: AppSpacings.xs),
                  Text(customer.phone!, style: AppTypography.bodyMedium.copyWith(color: AppColors.accentColor)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: AppRadius.large,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.06),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _buildTabItem('Infos', 0, AppIcons.info)),
              Expanded(child: _buildTabItem('Achats (${controller.sales.length})', 1, AppIcons.receipt)),
              Expanded(child: _buildTabItem('Dettes', 2, AppIcons.debt)),
            ],
          ),
        ));
  }

  Widget _buildTabItem(String text, int index, IconData icon) {
    final isSelected = controller.selectedTab.value == index;
    return InkWell(
      borderRadius: AppRadius.large as BorderRadius,
      onTap: () => controller.selectTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacings.m),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: AppRadius.large,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryColor : AppColors.greyMedium, size: 22),
            SizedBox(height: AppSpacings.xs),
            Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: isSelected ? AppColors.primaryColor : AppColors.greyMedium,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 4),
                height: 3,
                width: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(Customer customer) {
    return Card(
      elevation: 3,
      shadowColor: AppColors.primaryColor.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
      child: Padding(
        padding: AppSpacings.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(AppIcons.location, color: AppColors.primaryColor, size: 28),
            SizedBox(width: AppSpacings.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Adresse', style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium)),
                  SizedBox(height: AppSpacings.s),
                  Text(
                    customer.address?.isNotEmpty == true ? customer.address! : 'Non renseignée',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(Customer customer) {
    return Card(
      elevation: 3,
      shadowColor: AppColors.secondaryColor.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.rLarge)),
      child: Padding(
        padding: AppSpacings.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.sticky_note_2_outlined, color: AppColors.secondaryColor, size: 28),
            SizedBox(width: AppSpacings.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notes', style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium)),
                  SizedBox(height: AppSpacings.s),
                  Text(
                    customer.notes?.isNotEmpty == true ? customer.notes! : 'Aucune note',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebtCard() {
    return Obx(() {
      final debts = controller.debts;
      final unpaid = debts.where((d) => d.status != DebtStatusIsar.paid).toList();
      final total = unpaid.fold<double>(0, (sum, d) => sum + (d.remainingAmount ?? 0));
      return Card(
        elevation: 3,
        shadowColor: AppColors.warningColor.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        child: Padding(
          padding: AppSpacings.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(AppIcons.debt, color: AppColors.warningColor, size: 28),
                  SizedBox(width: AppSpacings.l),
                  Text('Solde de Dettes', style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium)),
                ],
              ),
              SizedBox(height: AppSpacings.s),
              Text(
                '${total.toStringAsFixed(2)} €',
                style: AppTypography.titleLarge.copyWith(color: AppColors.tagRedText, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacings.l),
              ElevatedButton.icon(
                onPressed: total > 0 ? () => _showPaymentDialog(Get.context!) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  minimumSize: Size(double.infinity, AppSpacings.xxxl * 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.large,
                  ),
                  elevation: 0,
                ),
                icon: Icon(AppIcons.payment, color: AppColors.textOnPrimary),
                label: Text(
                  'Enregistrer un paiement',
                  style: AppTypography.bodyMedium.apply(color: AppColors.textOnPrimary),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    String? selectedMethod;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
          title: Text('Enregistrer un paiement', style: AppTypography.titleMedium),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Montant',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rMedium)),
                ),
              ),
              SizedBox(height: AppSpacings.m),
              DropdownButtonFormField<String>(
                value: selectedMethod,
                items: const [
                  DropdownMenuItem(value: 'Espèces', child: Text('Espèces')),
                  DropdownMenuItem(value: 'Carte Bancaire', child: Text('Carte Bancaire')),
                  DropdownMenuItem(value: 'Mobile Money', child: Text('Mobile Money')),
                ],
                onChanged: (v) => selectedMethod = v,
                decoration: InputDecoration(
                  labelText: 'Mode de paiement',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.rMedium)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0;
                if (amount > 0 && selectedMethod != null) {
                  await controller.recordPayment(amount: amount, method: selectedMethod!);
                  Navigator.of(ctx).pop();
                  AppSnackbars.showSuccess('Paiement enregistré', 'Le paiement a été enregistré avec succès.');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton.icon(
      onPressed: controller.editCustomer,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(double.infinity, AppSpacings.xxxl * 2),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.large,
        ),
        elevation: 0,
      ),
      icon: Icon(AppIcons.edit, color: AppColors.textOnPrimary),
      label: Text(
        'Modifier Fiche Client',
        style: AppTypography.bodyMedium.apply(color: AppColors.textOnPrimary),
      ),
    );
  }

  Widget _buildSalesList() {
    return Obx(() {
      final sales = controller.sales;
      if (sales.isEmpty) {
        return Center(
          child: Text('Aucun achat trouvé', style: AppTypography.bodyMedium),
        );
      }
      return Column(
        children: sales.map((sale) {
          return Card(
            margin: EdgeInsets.only(bottom: AppSpacings.m),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
            elevation: 2,
            shadowColor: AppColors.primaryColor.withOpacity(0.06),
            child: ListTile(
              leading: Icon(AppIcons.receipt, color: AppColors.primaryColor),
              title: Text(sale.saleNumber ?? 'Vente', style: AppTypography.bodyMedium),
              subtitle: Text(
                sale.saleDate != null
                    ? 'Le ${sale.saleDate!.day}/${sale.saleDate!.month}/${sale.saleDate!.year}'
                    : '',
                style: AppTypography.bodySmall,
              ),
              trailing: Text(
                '${(sale.totalPrice ?? 0).toStringAsFixed(2)} €',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildDebtsList() {
    return Obx(() {
      final debts = controller.debts;
      if (debts.isEmpty) {
        return Center(
          child: Text('Aucune dette', style: AppTypography.bodyMedium),
        );
      }
      return Column(
        children: debts.map((debt) {
          return Card(
            margin: EdgeInsets.only(bottom: AppSpacings.m),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
            elevation: 2,
            shadowColor: AppColors.warningColor.withOpacity(0.06),
            child: ListTile(
              leading: Icon(AppIcons.debt, color: AppColors.warningColor),
              title: Text(
                'Dette du ${(debt.debtDate != null) ? '${debt.debtDate!.day}/${debt.debtDate!.month}/${debt.debtDate!.year}' : ''}',
                style: AppTypography.bodyMedium,
              ),
              subtitle: Text(
                debt.status == DebtStatusIsar.paid
                    ? 'Payée'
                    : debt.status == DebtStatusIsar.partiallyPaid
                        ? 'Partiellement payée'
                        : 'Non payée',
                style: AppTypography.bodySmall,
              ),
              trailing: Text(
                '${(debt.remainingAmount ?? 0).toStringAsFixed(2)} €',
                style: AppTypography.bodyMedium.copyWith(
                  color: debt.status == DebtStatusIsar.paid
                      ? AppColors.successColor
                      : AppColors.tagRedText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
