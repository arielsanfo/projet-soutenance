import 'package:get/get.dart';
import '../../data/controller/productService.dart';
import '../../data/storage.dart';

class IventoryController extends GetxController {
  final ProductService productService;
  IventoryController(this.productService);

  final RxList<Product> products = <Product>[].obs;
  final RxList<ProductCategory> categories = <ProductCategory>[].obs;

  final RxString searchQuery = ''.obs;
  final Rxn<ProductCategory> selectedCategory = Rxn<ProductCategory>();
  final RxString stockFilter = 'all'.obs; // all, in_stock, out_of_stock, low_stock

  int get totalInStock => filteredProducts.fold(0, (sum, p) => sum + (p.stockQuantity ?? 0));
  int get outOfStockCount => filteredProducts.where((p) => (p.stockQuantity ?? 0) == 0).length;
  double get totalStockValue => filteredProducts.fold(0.0, (sum, p) => sum + ((p.stockQuantity ?? 0) * (p.salePrice ?? 0)));

  List<Product> get filteredProducts {
    var list = products;
    if (selectedCategory.value != null) {
      list = list.where((p) => p.categoryLink.value?.id == selectedCategory.value!.id).toList().obs;
    }
    if (stockFilter.value == 'in_stock') {
      list = list.where((p) => (p.stockQuantity ?? 0) > 0).toList().obs;
    } else if (stockFilter.value == 'out_of_stock') {
      list = list.where((p) => (p.stockQuantity ?? 0) == 0).toList().obs;
    } else if (stockFilter.value == 'low_stock') {
      list = list.where((p) => (p.stockQuantity ?? 0) > 0 && (p.stockQuantity ?? 0) < 5).toList().obs;
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

  void setStockFilter(String filter) {
    stockFilter.value = filter;
    update();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCategories();
  }
}
