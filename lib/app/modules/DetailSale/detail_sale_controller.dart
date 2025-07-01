import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:pdf/pdf.dart';
import '../../data/controller/saleService.dart';
import '../../data/storage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

class DetailSaleController extends GetxController {
  late final SaleService saleService;
  final sale = Rxn<Sale>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final isar = Get.find<Isar>();
    saleService = SaleService(isar);
    final saleId = Get.arguments as Id?;
    if (saleId != null) {
      loadSale(saleId);
    }
  }

  Future<void> loadSale(Id id) async {
    isLoading.value = true;
    try {
      final s = await saleService.getSaleById(id);
      sale.value = s;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger la vente',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError);
    } finally {
      isLoading.value = false;
    }
  }

  // Impression PDF du reçu
  Future<void> printSale() async {
    await generateAndPrintPdf();
    Get.snackbar('Impression', 'Reçu généré et prêt à imprimer/partager',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary);
  }

  Future<void> generateAndPrintPdf() async {
    final s = sale.value;
    if (s == null) return;
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Reçu de Vente',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Text('Numéro : ${s.saleNumber ?? '-'}'),
            pw.Text(
                'Date : ${s.saleDate != null ? s.saleDate!.toLocal().toString().split(" ")[0] : "-"}'),
            if (s.customerLink.value?.name != null)
              pw.Text('Client : ${s.customerLink.value!.name!}'),
            if (s.paymentMethod != null)
              pw.Text('Paiement : ${s.paymentMethod}'),
            if (s.processedByLink.value?.name != null)
              pw.Text('Validée par : ${s.processedByLink.value!.name!}'),
            if (s.notes != null && s.notes!.isNotEmpty)
              pw.Text('Notes : ${s.notes!}'),
            pw.SizedBox(height: 16),
            pw.Text('Articles',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            ...s.saleItems.map((item) => pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                        child:
                            pw.Text(item.productLink.value?.name ?? 'Produit')),
                    pw.Text(
                        '${item.quantity} x ${(item.unitPriceAtSale ?? 0).toStringAsFixed(2)} f'),
                    pw.Text(
                        '${item.totalPrice?.toStringAsFixed(2) ?? '0.00'} f'),
                  ],
                )),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${s.totalPrice?.toStringAsFixed(2) ?? '0.00'} f',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            if (s.discountAmount != null && s.discountAmount! > 0)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Remise',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('-${s.discountAmount!.toStringAsFixed(2)} f',
                      style: pw.TextStyle(color: PdfColor.fromInt(0xFFFF0000))),
                ],
              ),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Action d'annulation de vente
  Future<void> cancelSale() async {
    final s = sale.value;
    if (s == null) {
      Get.snackbar(
        'Erreur',
        'Aucune vente à annuler',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Confirmation de l'utilisateur
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'Confirmer l\'annulation',
          style: TextStyle(
            color: Get.theme.colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Êtes-vous sûr de vouloir annuler cette vente ?',
              style: TextStyle(
                color: Get.theme.colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Get.theme.colorScheme.error.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vente #${s.saleNumber ?? '-'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: ${s.totalPrice?.toStringAsFixed(2) ?? '0.00'} f',
                    style: TextStyle(
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  if (s.customerLink.value?.name != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Client: ${s.customerLink.value!.name!}',
                      style: TextStyle(
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '⚠️ Cette action est irréversible et supprimera définitivement la vente.',
              style: TextStyle(
                color: Get.theme.colorScheme.error,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Annuler',
              style: TextStyle(
                color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.colorScheme.error,
              foregroundColor: Get.theme.colorScheme.onError,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (result != true) return;

    // Affichage d'un indicateur de chargement
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    try {
      // Suppression de la vente
      if (s.id != null) {
        await saleService.deleteSale(s.id!);
      }
      
      // Fermeture du dialogue de chargement
      Get.back();
      // Message de succès
      Get.snackbar(
        'Succès',
        'Vente annulée avec succès',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      
      // Retour à la page précédente
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();
      
    } catch (e) {
      // Fermeture du dialogue de chargement
      Get.back();
      
      // Message d'erreur
      Get.snackbar(
        'Erreur',
        'Impossible d\'annuler la vente: ${e.toString()}',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
