import 'package:flutter/material.dart';
import 'package:flutter_application_1/customs/app_constante.dart';


class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Farine T55',
      'theoretical': 56,
      'unit': 'unités',
      'physical': null,
      'variance': 0,
      'reason': null
    },
    {
      'name': 'Sucre en Poudre',
      'theoretical': 20,
      'unit': 'kg',
      'physical': null,
      'variance': 0,
      'reason': null
    },
    {
      'name': 'Œufs',
      'theoretical': 120,
      'unit': 'pièces',
      'physical': null,
      'variance': 0,
      'reason': null
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: Text('Prise d\'Inventaire',
            style: AppTypography.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.backgroundWhite,
      ),
      body: Padding(
        padding:  EdgeInsets.all(AppSpacings.l),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (context, index) => Divider(height: 24),
                itemBuilder: (context, index) {
                  return ProductWidget(
                    productName: products[index]['name'],
                    theoretical: products[index]['theoretical'],
                    unit: products[index]['unit'],
                    onChanged: (value) {
                      setState(() {
                        products[index]['physical'] = value;
                        products[index]['variance'] = 
                            (int.tryParse(value) ?? 0) - products[index]['theoretical'];
                      });
                    },
                    variance: products[index]['variance'],
                    reason: products[index]['reason'],
                  );
                },
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _validateInventory(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: Size(double.infinity, AppSpacings.xxxl *2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
            ),
          ),
          child: Text('Valider et Suivant',
              style: AppTypography.bodyLarge.apply(color: AppColors.textOnPrimary)),
        ),
        SizedBox(height: AppSpacings.l),
        OutlinedButton(
          onPressed: () => _finalizeInventory(),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primaryColor),
            minimumSize: Size(double.infinity, AppSpacings.xxxl *2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
            ),
          ),
          child: Text('Finaliser l\'Inventaire',
              style: AppTypography.bodyLarge.apply(color: AppColors.primaryColor)),
        ),
      ],
    );
  }
      
  }

  void _validateInventory() {
    // Logique de validation
  }

  void _finalizeInventory() {
    // Logique de finalisation
  }


class ProductWidget extends StatefulWidget {
  final String productName;
  final int theoretical;
  final String unit;
  final Function(String) onChanged;
  final int variance;
  final String? reason;

  const ProductWidget({
    required this.productName,
    required this.theoretical,
    required this.unit,
    required this.onChanged,
    required this.variance,
    this.reason,
  });

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Produit: ${widget.productName}',
                style: AppTypography.bodyMedium),
        SizedBox(height: AppSpacings.l),
        Text('Stock Théorique: ${widget.theoretical} ${widget.unit}',
            style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium)),
        SizedBox(height: AppSpacings.l),
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Stock Physique Compté',
            hintText: widget.theoretical.toString(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacings.l),
            ),
          ),
          onChanged: widget.onChanged,
        ),
        if (widget.variance != 0) ...[
          SizedBox(height: AppSpacings.l),
          Text('Écart: ${widget.variance > 0 ? '+' : ''}${widget.variance} ${widget.unit}',
              style: AppTypography.bodyMedium.apply(color: widget.variance > 0 ? AppColors.tagGreenText : AppColors.tagRedText)),
          SizedBox(height: AppSpacings.l),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Choisir une raison',
              border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(AppSpacings.l),
              ),
            ),
            items: ['Casse', 'Vol', 'Erreur']
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: AppTypography.bodyMedium.apply(color: AppColors.greyMedium)  )))
                .toList(),
            onChanged: (value) {
              //
            },
          ),
        ],
      ],
    );
  }
}