import 'package:get/get.dart';

import '../modules/AddClient/add_client_binding.dart';
import '../modules/AddClient/add_client_view.dart';
import '../modules/AddOrder/add_order_binding.dart';
import '../modules/AddOrder/add_order_view.dart';
import '../modules/AddProduct/add_product_binding.dart';
import '../modules/AddProduct/add_product_view.dart';
import '../modules/AddSupplier/add_supplier_binding.dart';
import '../modules/AddSupplier/add_supplier_view.dart';
import '../modules/Client_List/client_list_binding.dart';
import '../modules/Client_List/client_list_view.dart';
import '../modules/Dashboard/dashboard_binding.dart';
import '../modules/Dashboard/dashboard_view.dart';
import '../modules/DetailSale/detail_sale_binding.dart';
import '../modules/DetailSale/detail_sale_view.dart';
// import '../modules/DetailSupplierOrder/detail_supplier_order_binding.dart';
import '../modules/DetailSupplierOrder/detail_supplier_order_controller.dart';
import '../modules/DetailSupplierOrder/detail_supplier_order_view.dart';
import '../modules/DetailSupplierOrder/supplier_orders_for_supplier_controller.dart';
import '../modules/DetailSupplierOrder/supplier_orders_for_supplier_view.dart';
import '../modules/Detail_Product/detail_product_binding.dart';
import '../modules/Detail_Product/detail_product_view.dart';
import '../modules/DetailsClient/details_client_binding.dart';
import '../modules/DetailsClient/details_client_view.dart';
import '../modules/DetailsOrder/details_order_binding.dart';
import '../modules/DetailsOrder/details_order_view.dart';
import '../modules/DetailsReturn/details_return_binding.dart';
import '../modules/DetailsReturn/details_return_view.dart';
import '../modules/DetailsSupplier/details_supplier_binding.dart';
import '../modules/DetailsSupplier/details_supplier_view.dart';
import '../modules/Dettes/dettes_binding.dart';
import '../modules/Dettes/dettes_view.dart';
import '../modules/Expense_Report/expense_report_binding.dart';
import '../modules/Expense_Report/expense_report_view.dart';
import '../modules/Expense_Report/add_expense_view.dart';
import '../modules/FinalInventory/final_inventory_binding.dart';
import '../modules/FinalInventory/final_inventory_view.dart';
import '../modules/History/history_binding.dart';
import '../modules/History/history_view.dart';
import '../modules/Iventory/iventory_binding.dart';
import '../modules/Iventory/iventory_view.dart';
import '../modules/ListSale/list_sale_binding.dart';
import '../modules/ListSale/list_sale_view.dart';
import '../modules/ListSupplierOrder/list_supplier_order_binding.dart';
import '../modules/ListSupplierOrder/list_supplier_order_view.dart';
import '../modules/Login/login_binding.dart';
import '../modules/Login/login_view.dart';
import '../modules/ManagementOrder/management_order_binding.dart';
import '../modules/ManagementOrder/management_order_view.dart';
import '../modules/ManagementRole/management_role_binding.dart';
import '../modules/ManagementRole/management_role_view.dart';
import '../modules/Newsale/newsale_binding.dart';
import '../modules/Newsale/newsale_view.dart';
import '../modules/Notification/notification_binding.dart';
import '../modules/Notification/notification_view.dart';
import '../modules/Order_List/order_list_binding.dart';
import '../modules/Order_List/order_list_view.dart';
import '../modules/PriseInventory/prise_inventory_binding.dart';
import '../modules/PriseInventory/prise_inventory_view.dart';
import '../modules/Product_List/product_list_binding.dart';
import '../modules/Product_List/product_list_view.dart';
import '../modules/Profile/profile_binding.dart';
import '../modules/Profile/profile_view.dart';
import '../modules/Reception/reception_binding.dart';
import '../modules/Reception/reception_view.dart';
import '../modules/Settings/settings_binding.dart';
import '../modules/Settings/settings_view.dart';
import '../modules/SignUp/sign_up_binding.dart';
import '../modules/SignUp/sign_up_view.dart';
import '../modules/Stock/stock_binding.dart';
import '../modules/Stock/stock_view.dart';
import '../modules/SupplierOrder/supplier_order_binding.dart';
import '../modules/SupplierOrder/supplier_order_view.dart';
import '../modules/Supplier_List/supplier_list_binding.dart';
import '../modules/Supplier_List/supplier_list_view.dart';
import '../modules/TrackingOrder/tracking_order_binding.dart';
import '../modules/TrackingOrder/tracking_order_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const transitionDuration = Duration(milliseconds: 1500);
  static const transitionCurve = Transition.cupertinoDialog;
  static const SUPPLIER_ORDERS_FOR_SUPPLIER = '/supplier-orders-for-supplier';
  static const DETAIL_SUPPLIER_ORDER = '/detail-supplier-order';
  static const ADD_EXPENSE = '/add-expense';

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => SignUpView(),
      binding: SignUpBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.DETAIL_PRODUCT,
      page: () => DetailProductView(),
      binding: DetailProductBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.DETAIL_PRODUCT_WITH_ID,
      page: () => DetailProductView(),
      binding: DetailProductBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.ADD_CLIENT,
      page: () => AddClientView(),
      binding: AddClientBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.ADD_ORDER,
      page: () => AddOrderView(),
      binding: AddOrderBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.ADD_PRODUCT,
      page: () => AddProductView(),
      binding: AddProductBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.ADD_SUPPLIER,
      page: () => AddSupplierView(),
      binding: AddSupplierBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.CLIENT_LIST,
      page: () => ClientListView(),
      binding: ClientListBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.DETAILS_CLIENT,
      page: () => DetailsClientView(),
      binding: DetailsClientBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.DETAILS_ORDER,
      page: () => DetailsOrderView(),
      binding: DetailsOrderBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    // GetPage(
    //   name: _Paths.DETAIL_PRODUCTS,
    //   page: () => DetailsProductsView(),
    //   binding: DetailsProductsBinding(),
    //   transition: transitionCurve,
    //   transitionDuration: transitionDuration,
    // ),
    GetPage(
      name: _Paths.DETAILS_SUPPLIER,
      page: () => DetailsSupplierView(),
      binding: DetailsSupplierBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.DETAILS_RETURN,
      page: () => DetailsReturnView(),
      binding: DetailsReturnBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.SUPPLIER_ORDERS_FOR_SUPPLIER,
      page: () => SupplierOrdersForSupplierView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SupplierOrdersForSupplierController());
      }),
    ),
    GetPage(
      name: Routes.DETAIL_SUPPLIER_ORDER,
      page: () => DetailSupplierOrderView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DetailSupplierOrderController());
      }),
    ),
    GetPage(
      name: _Paths.EXPENSE_REPORT,
      page: () => ExpenseReportView(),
      binding: ExpenseReportBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.ADD_EXPENSE,
      page: () => AddExpenseView(),
      binding: AddExpenseBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.FINAL_INVENTORY,
      page: () => FinalInventoryView(),
      binding: FinalInventoryBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => HistoryView(),
      binding: HistoryBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.INVENTORY,
      page: () => IventoryView(),
      binding: IventoryBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.LIST_SUPPLIER_ORDER,
      page: () => ListSupplierOrderView(),
      binding: ListSupplierOrderBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.MANAGEMENT_ORDER,
      page: () => ManagementOrderView(),
      binding: ManagementOrderBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.MANAGEMENT_ROLE,
      page: () => ManagementRoleView(),
      binding: ManagementRoleBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.NEWSALE,
      page: () => NewsaleView(),
      binding: NewsaleBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.ORDER_LIST,
      page: () => OrderListView(),
      binding: OrderListBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.PRISE_INVENTORY,
      page: () => PriseInventoryView(),
      binding: PriseInventoryBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => ProductListView(),
      binding: ProductListBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.RECEPTION,
      page: () => ReceptionView(),
      binding: ReceptionBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.STOCK,
      page: () => StockView(),
      binding: StockBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.SUPPLIER_LIST,
      page: () => SupplierListView(),
      binding: SupplierListBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.SUPPLIER_ORDER,
      page: () => SupplierOrderView(),
      binding: SupplierOrderBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.TRACKING_ORDER,
      page: () => TrackingOrderView(),
      binding: TrackingOrderBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.LIST_SALE,
      page: () => const ListSaleView(),
      binding: ListSaleBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_SALE,
      page: () => const DetailSaleView(),
      binding: DetailSaleBinding(),
    ),
    GetPage(
      name: _Paths.DETTES,
      page: () => const DettesView(),
      binding: DettesBinding(),
    ),
  ];
}

class Routes {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
  static const SIGN_UP = '/sign-up';
  static const DETAIL_PRODUCT = '/detail-product';
  static const DETAIL_PRODUCT_WITH_ID = '/detail-product/:id';
  static const ADD_CLIENT = '/add-client';
  static const ADD_ORDER = '/add-order';
  static const ADD_PRODUCT = '/add-product';
  static const ADD_SUPPLIER = '/add-supplier';
  static const CLIENT_LIST = '/client-list';
  static const DETAILS_CLIENT = '/details-client';
  static const DETAILS_ORDER = '/details-order';
  static const DETAIL_PRODUCTS = '/detail-products';
  static const DETAILS_SUPPLIER = '/details-supplier';
  static const DETAILS_RETURN = '/details-return';
  static const SUPPLIER_ORDERS_FOR_SUPPLIER = '/supplier-orders-for-supplier';
  static const DETAIL_SUPPLIER_ORDER = '/detail-supplier-order';
  static const EXPENSE_REPORT = '/expense-report';
  static const FINAL_INVENTORY = '/final-inventory';
  static const HISTORY = '/history';
  static const INVENTORY = '/inventory';
  static const LIST_SUPPLIER_ORDER = '/list-supplier-order';
  static const MANAGEMENT_ORDER = '/management-order';
  static const MANAGEMENT_ROLE = '/management-role';
  static const NEWSALE = '/newsale';
  static const NOTIFICATION = '/notification';
  static const ORDER_LIST = '/order-list';
  static const PRISE_INVENTORY = '/prise-inventory';
  static const PRODUCT_LIST = '/product-list';
  static const PROFILE = '/profile';
  static const RECEPTION = '/reception';
  static const SETTINGS = '/settings';
  static const STOCK = '/stock';
  static const SUPPLIER_LIST = '/supplier-list';
  static const SUPPLIER_ORDER = '/supplier-order';
  static const TRACKING_ORDER = '/tracking-order';
  static const LIST_SALE = '/list-sale';
  static const DETAIL_SALE = '/detail-sale';
  static const ADD_EXPENSE = '/add-expense';
  static const DETTES = '/dettes';
}
