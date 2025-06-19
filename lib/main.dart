import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'app/data/storage.dart';
import 'app/routes/app_pages.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtenir le répertoire de stockage
  final dir = await getApplicationDocumentsDirectory();

  // Ouvrir la base Isar avec tous tes modèles
  final isar = await Isar.open(
    [
      UserSchema,
      ProductCategorySchema,
      ProductSchema,
      CustomerSchema,
      SaleSchema,
      SaleItemSchema,
      OrderSchema,
      OrderItemSchema,
      SupplierSchema,
      SupplierOrderSchema,
      SupplierOrderItemSchema,
      InventoryMovementSchema,
      ExpenseSchema,
      DebtSchema,
      DebtPaymentSchema,
      BusinessDetailsSchema,
    ],
    directory: dir.path,
  );
  Get.put<Isar>(isar);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
    );
  }
}
