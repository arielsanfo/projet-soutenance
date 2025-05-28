import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';


class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String _selectedStatus = 'En préparation';
  final TextEditingController _trackingController = TextEditingController();
  final List<Map<String, dynamic>> _items = [
    {'name': 'Café en grains (250g)', 'qty': 2, 'price': 7.50},
    {'name': 'Thé vert bio (100g)', 'qty': 1, 'price': 4.60},
    {'name': 'Sucre de canne (1kg)', 'qty': 3, 'price': 3.00},
  ];

  double get _totalAmount {
    return _items.fold(0, (sum, item) => sum + (item['price'] * item['qty']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Détails Commande Client #C20240078',
            style: AppTypography.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacings.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientInfo(),
            SizedBox(height: AppSpacings.l),
            _buildOrderedItems(),
            SizedBox(height: AppSpacings.l),
            _buildTotalSection(),
            SizedBox(height: AppSpacings.l),
            _buildStatusTrackingSection(),
            SizedBox(height: AppSpacings.xl),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Béatrice Martin',
            style: AppTypography.titleMedium),
        SizedBox(height: AppSpacings.s),
        Text('12 Rue de la Paix, 75002 Paris',
            style: AppTypography.bodyMedium),
        Divider(height: AppSpacings.l),
      ],
    );
  }

  Widget _buildOrderedItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Articles Commandés',
            style: AppTypography.titleMedium),
        SizedBox(height: AppSpacings.l),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          separatorBuilder: (context, index) => SizedBox(height: AppSpacings.l),
          itemBuilder: (context, index) {
            final item = _items[index];
            return Row(
              children: [
                Container(
                  width: AppSpacings.s,
                  height: AppSpacings.s,
                  margin: EdgeInsets.only(right: AppSpacings.s),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text('${item['name']} x${item['qty']}',
                      style: AppTypography.bodyMedium),
                ),
                Text('${(item['price'] * item['qty']).toStringAsFixed(2)} €',
                    style: AppTypography.bodyMedium),
              ],
            );
          },
        ),
        Divider(height: AppSpacings.xxl, color: AppColors.greyMedium),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total:', 
            style: AppTypography.titleMedium),
        Text('${_totalAmount.toStringAsFixed(2)} €',
            style: AppTypography.titleLarge.apply(color: AppColors.primaryColor)),
      ],
    );
  }

  Widget _buildStatusTrackingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statut & Suivi',
            style: AppTypography.titleMedium),
        SizedBox(height: AppSpacings.xl),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacings.xl, vertical: AppSpacings.xxl),
          ),
          items: ['En préparation', 'Envoyée', 'Livrée', 'Annulée']
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status, style: AppTypography.titleSmall),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _selectedStatus = value!),
        ),
            SizedBox(height: AppSpacings.xxl),
        TextFormField(
          controller: _trackingController,
          decoration: InputDecoration(
            hintText: 'N° de suivi (si applicable)',
            filled: true,
            fillColor: AppColors.greyLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacings.xl, vertical: AppSpacings.xxl),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderDetailScreen()),
                );
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
        minimumSize: Size(double.infinity, AppSpacings.xxl *3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacings.l),
        ),
      ),
      child: Text('Mettre à Jour la Commande',
          style: AppTypography.bodyLarge.apply(color: AppColors.textOnPrimary)),
    );
  }
}