import 'package:get/get.dart';
import 'package:isar/isar.dart';
import '../../data/controller/productService.dart';
import '../../data/storage.dart';

class FinalInventoryController extends GetxController {
  final ProductService productService;
  FinalInventoryController(this.productService);

  final RxList<Product> products = <Product>[].obs;
  final RxList<ProductCategory> categories = <ProductCategory>[].obs;
  final RxString searchQuery = ''.obs;
  final Rxn<ProductCategory> selectedCategory = Rxn<ProductCategory>();

  final RxMap<Id, int> physicalCounts = <Id, int>{}.obs;
  final RxMap<Id, String?> reasons = <Id, String?>{}.obs;

  List<Product> get filteredProducts {
    var list = products;
    if (selectedCategory.value != null) {
      list = list.where((p) => p.categoryLink.value?.id == selectedCategory.value!.id).toList().obs;
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list.where((p) => (p.name?.toLowerCase().contains(q) ?? false) || (p.sku?.toLowerCase().contains(q) ?? false)).toList().obs;
    }
    return list;
  }

  Future<void> loadProducts() async {
    final loaded = await productService.getAllProducts();
    for (final p in loaded) {
      await p.categoryLink.load();
    }
    products.assignAll(loaded);
    update();
  }

  Future<void> loadCategories() async {
    final cats = await productService.getAllCategories();
    categories.assignAll(cats);
    update();
  }

  void setCategory(ProductCategory? cat) {
    selectedCategory.value = cat;
    update();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    update();
  }

  int getVariance(Product p) {
    final physical = physicalCounts[p.id] ?? p.stockQuantity ?? 0;
    return physical - (p.stockQuantity ?? 0);
  }

  void setPhysicalCount(Product p, int value) {
    physicalCounts[p.id!] = value;
    update();
  }

  void setReason(Product p, String? value) {
    reasons[p.id!] = value;
    update();
  }

  Future<void> saveInventoryAdjustments() async {
    for (final p in products) {
      final physical = physicalCounts[p.id] ?? p.stockQuantity ?? 0;
      final variance = physical - (p.stockQuantity ?? 0);
      if (variance != 0) {
        await productService.updateStock(
          productId: p.id!,
          quantityChange: variance,
          movementType: variance > 0 ? InventoryMovementTypeIsar.adjustmentIn : InventoryMovementTypeIsar.adjustmentOut,
          reason: reasons[p.id],
        );
      }
    }
    await loadProducts();
  }

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
  }
}
