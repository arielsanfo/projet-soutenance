import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'app/data/storage.dart';
import 'app/routes/app_pages.dart';
import 'helpers/app_constante.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Application",
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: '/splash',
          page: () => SplashScreen(),
        ),
        ...AppPages.routes,
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      Get.offAllNamed(Routes.LOGIN); // Navigue toujours vers la page de login après le splash
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  AppIcons.store, // Utilise l'icône de l'application
                  size: 90,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'CommercePro',
                style: AppTypography.displayLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Votre gestion commerciale ',
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
