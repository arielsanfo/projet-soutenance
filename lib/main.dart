import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'app/data/storage.dart';
import 'app/routes/app_pages.dart';
import 'helpers/app_constante.dart';
import 'package:path_provider/path_provider.dart';
import 'app/data/controller/userServices.dart';
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

  // Initialiser le gestionnaire de session global
  SessionManager.init();
  
  // Debug: Vérifier l'état de la session au démarrage
  final isLoggedIn = await SessionManager.isLoggedIn();
  print('=== DÉMARRAGE APP ===');
  print('Session active: $isLoggedIn');
  if (isLoggedIn) {
    final user = await SessionManager.getCurrentUser();
    print('Utilisateur connecté: ${user?.name} (${user?.email})');
  }
  
  // Créer un utilisateur par défaut si aucun utilisateur n'existe
  await _createDefaultUserIfNeeded();

  runApp(const MyApp());
}

/// Créer un utilisateur par défaut si aucun utilisateur n'existe
Future<void> _createDefaultUserIfNeeded() async {
  try {
    final isar = Get.find<Isar>();
    final userService = UserService(isar);
    
    // Vérifier s'il y a des utilisateurs dans la base
    final users = await userService.getAllUsers();
    print('Nombre d\'utilisateurs dans la base: ${users.length}');
    
    if (users.isEmpty) {
      print('Aucun utilisateur trouvé, création d\'un utilisateur par défaut...');
      
      // Créer un utilisateur admin par défaut
      final defaultUser = User(
        name: 'Admin',
        email: 'admin@commercepro.com',
        passwordHash: '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', // 'admin'
        role: UserRoleIsar.admin,
      );
      
      await userService.saveUser(defaultUser);
      print('Utilisateur par défaut créé: ${defaultUser.name} (${defaultUser.email})');
      print('Mot de passe par défaut: admin');
    }
  } catch (e) {
    print('Erreur lors de la création de l\'utilisateur par défaut: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "CommercePro",
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: '/splash',
          page: () => SplashScreen(),
          middlewares: [SessionMiddleware()],
        ),
        ...AppPages.routes,
      ],
      // Middleware global pour toutes les routes
      routingCallback: (routing) {
        // Log pour debug
        print('Navigation vers: ${routing?.current}');
      },
      // Gestionnaire de cycle de vie de l'application
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            // Fermer le clavier quand on tape en dehors
            FocusScope.of(context).unfocus();
          },
          child: child!,
        );
      },
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
  bool _isNavigating = false;

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
    if (_isNavigating) return;
    _isNavigating = true;
    
    print('=== SPLASH SCREEN ===');
    print('Début de la navigation...');
    
    // Attendre l'animation du splash
    await Future.delayed(Duration(seconds: 3));
    
    if (mounted) {
      try {
        // Vérifier la session directement
        final isLoggedIn = await SessionManager.isLoggedIn();
        print('Vérification session dans splash: $isLoggedIn');
        
        String initialRoute;
        if (isLoggedIn) {
          initialRoute = '/dashboard';
          print('Session active, redirection vers dashboard');
        } else {
          initialRoute = '/login';
          print('Aucune session, redirection vers login');
        }
        
        // Navigation avec transition fluide
        Get.offAllNamed(initialRoute);
      } catch (e) {
        // En cas d'erreur, rediriger vers login
        print('Erreur lors de la vérification de session: $e');
        Get.offAllNamed('/login');
      }
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
                  AppIcons.store,
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
                'Votre gestion commerciale simplifiée',
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              // Indicateur de chargement
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
