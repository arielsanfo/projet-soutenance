import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/data/storage.dart';
import 'package:flutter_application_1/app/routes/app_pages.dart';
import 'package:flutter_application_1/helpers/app_constante.dart';

import 'package:get/get.dart';
import 'package:isar/isar.dart';

import 'management_order_controller.dart';

class ManagementOrderView extends GetView<ManagementOrderController> {
  ManagementOrderView({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('=== BUILD MANAGEMENT ORDER VIEW ===');
    print('Controller: ${controller.toString()}');
    print('IsLoading: ${controller.isLoading.value}');
    print('Orders count: ${controller.orders.length}');
    print('Supplier orders count: ${controller.supplierOrders.length}');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          title: Text('Gestion des Commandes', style: AppTypography.titleLarge),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.backgroundWhite,
          bottom: TabBar(
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.greyMedium,
            indicatorColor: AppColors.primaryColor,
            indicatorWeight: 3,
            isScrollable: true,
            onTap: (index) => controller.changeTab(index),
            tabs: [
              Obx(() => Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Commandes Clients',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${controller.orders.length}',
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Obx(() => Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            'Commandes Fournisseurs',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${controller.supplierOrders.length}',
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: Obx(() {
                print('=== REBUILD BODY ===');
                print('IsLoading: ${controller.isLoading.value}');
                print(
                    'Client orders: ${controller.filteredClientOrders.length}');
                print(
                    'Supplier orders: ${controller.filteredSupplierOrders.length}');
                print('Current tab: ${controller.currentTabIndex.value}');

                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                return TabBarView(
                  children: [
                    _buildClientOrdersTab(),
                    _buildSupplierOrdersTab(),
                  ],
                );
              }),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Obx(() {
          if (controller.currentTabIndex.value == 0) {
            return FloatingActionButton.extended(
              heroTag: 'fab_client',
              onPressed: () {
                _showAddClientOrderDialog();
              },
              icon: Icon(Icons.add_shopping_cart),
              label: Text('Nouvelle commande client'),
              backgroundColor: AppColors.primaryColor,
            );
          } else {
            return FloatingActionButton.extended(
              heroTag: 'fab_fournisseur',
              onPressed: () {
                Get.toNamed(Routes.ADD_ORDER);
              },
              icon: Icon(Icons.add_business),
              label: Text('Nouvelle commande fournisseur'),
              backgroundColor: AppColors.primaryColor,
            );
          }
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacings.l,
        vertical: AppSpacings.s,
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          controller.searchQuery.value = value;
          controller.updateFilteredLists();
        },
        decoration: InputDecoration(
          hintText: 'Rechercher par client, fournisseur, numéro...',
          prefixIcon: Icon(Icons.search, color: AppColors.greyMedium),
          filled: true,
          fillColor: AppColors.greyLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacings.l),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: AppSpacings.l,
            horizontal: AppSpacings.l,
          ),
        ),
      ),
    );
  }

  Widget _buildClientOrdersTab() {
    final clientOrders = controller.filteredClientOrders;

    if (clientOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.greyMedium,
            ),
            SizedBox(height: AppSpacings.l),
            Text(
              'Aucune commande client',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.greyMedium,
              ),
            ),
            SizedBox(height: AppSpacings.s),
            Text(
              'Les commandes clients apparaîtront ici',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.greyMedium,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: _buildClientOrdersList(clientOrders),
    );
  }

  Widget _buildSupplierOrdersTab() {
    final supplierOrders = controller.filteredSupplierOrders;

    if (supplierOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_outlined,
              size: 64,
              color: AppColors.greyMedium,
            ),
            SizedBox(height: AppSpacings.l),
            Text(
              'Aucune commande fournisseur',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.greyMedium,
              ),
            ),
            SizedBox(height: AppSpacings.s),
            Text(
              'Les commandes fournisseurs apparaîtront ici',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.greyMedium,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: _buildSupplierOrdersList(supplierOrders),
    );
  }

  Widget _buildClientOrdersList(List<Order> orders) {
    final pad = AppSpacings.l;
    return ListView.separated(
      padding: EdgeInsets.all(pad),
      itemCount: orders.length,
      separatorBuilder: (context, index) => Divider(height: pad * 1.5),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildAnimatedOrderCard(order, Get.context!, pad, index);
      },
    );
  }

  Widget _buildSupplierOrdersList(List<SupplierOrder> orders) {
    final pad = AppSpacings.l;
    return ListView.separated(
      padding: EdgeInsets.all(pad),
      itemCount: orders.length,
      separatorBuilder: (context, index) => Divider(height: pad * 1.5),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildAnimatedSupplierOrderCard(order, pad, Get.context!, index);
      },
    );
  }

  Widget _buildOrderCard(Order order, BuildContext context, [double? pad]) {
    final fontSize = 14.0;
    final padding = pad ?? AppSpacings.l;
    final debt = controller.getDebtForOrder(order);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(padding * 0.8),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: AppColors.primaryColor,
                      size: fontSize + 2,
                    ),
                  ),
                  SizedBox(width: padding * 0.8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                order.orderNumber ?? '',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (order.status != OrderStatusIsar.pending)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: padding * 0.4,
                                  vertical: padding * 0.2,
                                ),
                                decoration: BoxDecoration(
                                  color: controller
                                      .getOrderStatusColor(order.status)
                                      .withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(padding * 0.3),
                                  border: Border.all(
                                    color: controller
                                        .getOrderStatusColor(order.status),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  order.status?.toString().toUpperCase() ?? '',
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: fontSize * 0.7,
                                    color: controller
                                        .getOrderStatusColor(order.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: padding * 0.3),
                        Text(
                          'Client: ${order.customerLink.value?.name ?? 'N/A'}',
                          style: AppTypography.bodyMedium
                              .apply(
                                color: AppColors.greyMedium,
                              )
                              .copyWith(fontSize: fontSize * 0.9),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: fontSize * 0.8,
                              color: AppColors.greyMedium,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                controller.formatDate(order.orderDate),
                                style: AppTypography.bodyMedium
                                    .apply(
                                      color: AppColors.greyMedium,
                                    )
                                    .copyWith(fontSize: fontSize * 0.8),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (order.expectedDeliveryDate != null) ...[
                              SizedBox(width: padding * 0.5),
                              Icon(
                                Icons.local_shipping,
                                size: fontSize * 0.8,
                                color: AppColors.greyMedium,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  controller
                                      .formatDate(order.expectedDeliveryDate),
                                  style: AppTypography.bodyMedium
                                      .apply(
                                        color: AppColors.greyMedium,
                                      )
                                      .copyWith(fontSize: fontSize * 0.8),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.inventory_2,
                              size: fontSize * 0.8,
                              color: AppColors.greyMedium,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${controller.getOrderItemsCount(order)} article(s)',
                                style: AppTypography.bodyMedium
                                    .apply(
                                      color: AppColors.greyMedium,
                                    )
                                    .copyWith(fontSize: fontSize * 0.8),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: padding * 0.5),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${order.totalPrice?.toStringAsFixed(2) ?? '0.00'} €',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: padding * 0.3),
                        if (order.createdByLink.value != null)
                          Text(
                            'Par ${order.createdByLink.value!.name}',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: fontSize * 0.7,
                              color: AppColors.greyMedium,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (debt != null) ...[
                SizedBox(height: padding * 0.8),
                Divider(height: 1),
                SizedBox(height: padding * 0.4),
                Text(
                  'Dette associée:',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize * 0.85,
                  ),
                ),
                SizedBox(height: padding * 0.4),
                Container(
                  margin: EdgeInsets.only(bottom: padding * 0.4),
                  padding: EdgeInsets.all(padding * 0.4),
                  decoration: BoxDecoration(
                    color: (debt.remainingAmount ?? 0) > 0
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (debt.remainingAmount ?? 0) > 0
                          ? Colors.red.shade200
                          : Colors.green.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        (debt.remainingAmount ?? 0) > 0
                            ? Icons.warning
                            : Icons.check_circle,
                        color: (debt.remainingAmount ?? 0) > 0
                            ? Colors.red
                            : Colors.green,
                        size: fontSize + 2,
                      ),
                      SizedBox(width: padding * 0.4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dette #${debt.id}',
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: fontSize * 0.9,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Montant restant: ${(debt.remainingAmount ?? 0).toStringAsFixed(2)} €',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: fontSize * 0.8,
                                color: (debt.remainingAmount ?? 0) > 0
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if ((debt.remainingAmount ?? 0) > 0)
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showDebtPaymentSheet(Get.context!, order, debt);
                            },
                            icon: Icon(Icons.payment, size: fontSize * 0.8),
                            label: Text('Payer',
                                style: TextStyle(fontSize: fontSize * 0.8)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: padding * 0.4,
                                vertical: padding * 0.2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          // IconButton de suppression à droite
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              tooltip: 'Supprimer la commande',
              onPressed: () {
                _showDeleteClientOrderConfirmation(order);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierOrderCard(dynamic order,
      [double? pad, BuildContext? context]) {
    pad ??= context != null ? getResponsivePadding(context) : AppSpacings.l;
    final fontSize =
        context != null ? getResponsiveFontSize(context, 16) : 16.0;
    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(pad),
        border: Border.all(color: AppColors.greyLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(pad * 0.8),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      color: AppColors.primaryColor,
                      size: fontSize + 2,
                    ),
                  ),
                  SizedBox(width: pad * 0.8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                order.orderNumber ?? '',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (order.status != SupplierOrderStatusIsar.draft)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: pad * 0.4,
                                  vertical: pad * 0.2,
                                ),
                                decoration: BoxDecoration(
                                  color: controller
                                      .getSupplierOrderStatusColor(order.status)
                                      .withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(pad * 0.3),
                                  border: Border.all(
                                    color:
                                        controller.getSupplierOrderStatusColor(
                                            order.status),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  order.status?.toString().toUpperCase() ?? '',
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: fontSize * 0.7,
                                    color:
                                        controller.getSupplierOrderStatusColor(
                                            order.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: pad * 0.3),
                        Text(
                          'Fournisseur: ${order.supplierLink.value?.name ?? 'N/A'}',
                          style: AppTypography.bodyMedium
                              .apply(
                                color: AppColors.greyMedium,
                              )
                              .copyWith(fontSize: fontSize * 0.9),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: fontSize * 0.8,
                              color: AppColors.greyMedium,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                controller.formatDate(order.orderDate),
                                style: AppTypography.bodyMedium
                                    .apply(
                                      color: AppColors.greyMedium,
                                    )
                                    .copyWith(fontSize: fontSize * 0.8),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (order.expectedDeliveryDate != null) ...[
                              SizedBox(width: pad * 0.5),
                              Icon(
                                Icons.local_shipping,
                                size: fontSize * 0.8,
                                color: AppColors.greyMedium,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  controller
                                      .formatDate(order.expectedDeliveryDate),
                                  style: AppTypography.bodyMedium
                                      .apply(
                                        color: AppColors.greyMedium,
                                      )
                                      .copyWith(fontSize: fontSize * 0.8),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.inventory_2,
                              size: fontSize * 0.8,
                              color: AppColors.greyMedium,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${controller.getSupplierOrderItemsCount(order)} article(s)',
                                style: AppTypography.bodyMedium
                                    .apply(
                                      color: AppColors.greyMedium,
                                    )
                                    .copyWith(fontSize: fontSize * 0.8),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (order.actualDeliveryDate != null) ...[
                              SizedBox(width: pad * 0.5),
                              Icon(
                                Icons.check_circle,
                                size: fontSize * 0.8,
                                color: Colors.green,
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Reçue le ${controller.formatDate(order.actualDeliveryDate)}',
                                  style: AppTypography.bodyMedium
                                      .apply(
                                        color: Colors.green,
                                      )
                                      .copyWith(fontSize: fontSize * 0.8),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: pad * 0.5),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${order.totalPrice?.toStringAsFixed(2) ?? '0.00'} €',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: pad * 0.3),
                        if (order.createdByLink.value != null)
                          Text(
                            'Par ${order.createdByLink.value!.name}',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: fontSize * 0.7,
                              color: AppColors.greyMedium,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          // IconButton de suppression à droite
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              tooltip: 'Supprimer la commande',
              onPressed: () {
                _showDeleteConfirmation(order);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedOrderCard(
      Order order, BuildContext context, double pad, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + index * 40),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 30),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _showOrderDetails(order),
        onLongPress: () => _showClientOrderActions(order),
        child: _buildOrderCard(order, context, pad),
      ),
    );
  }

  Widget _buildAnimatedSupplierOrderCard(
      dynamic order, double pad, BuildContext context, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + index * 40),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 30),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _showSupplierOrderDetails(order),
        onLongPress: () => _showSupplierOrderActions(order),
        child: _buildSupplierOrderCard(order, pad, context),
      ),
    );
  }

  void _showDebtPaymentSheet(BuildContext context, Order order, Debt debt) {
    final controller = TextEditingController(
        text: debt.remainingAmount?.toStringAsFixed(2) ?? '');
    String paymentMethod = 'Espèces';
    final focusNode = FocusNode();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final mq = MediaQuery.of(ctx);
        final isMobile = mq.size.width < 500;
        final dialogMaxWidth = isMobile ? mq.size.width * 0.95 : 400.0;
        
        return SafeArea(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: dialogMaxWidth,
                minHeight: 200,
              ),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payment, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('Paiement de dette', style: AppTypography.titleLarge),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 16),
                  Text('Montant à payer', style: AppTypography.titleMedium),
                  SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.euro, color: AppColors.greyMedium),
                    ),
                    autofocus: true,
                  ),
                  SizedBox(height: 16),
                  Text('Méthode de paiement', style: AppTypography.titleMedium),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyLight),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: paymentMethod,
                      isExpanded: true,
                      underline: SizedBox(),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      items: [
                        DropdownMenuItem(value: 'Espèces', child: Text('Espèces')),
                        DropdownMenuItem(value: 'Carte', child: Text('Carte')),
                        DropdownMenuItem(value: 'Virement', child: Text('Virement')),
                      ],
                      onChanged: (v) {
                        if (v != null) paymentMethod = v;
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text('Annuler'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final amount = double.tryParse(controller.text) ?? 0;
                            if (amount <= 0) {
                              Get.snackbar('Erreur', 'Montant invalide', 
                                backgroundColor: Colors.red, colorText: Colors.white);
                              return;
                            }
                            await Get.find<ManagementOrderController>()
                                .recordDebtPaymentForOrder(
                                    order, amount, paymentMethod);
                            Navigator.of(ctx).pop();
                            Get.snackbar('Succès', 'Paiement enregistré',
                              backgroundColor: AppColors.primaryColor, colorText: Colors.white);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Valider le paiement'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDynamicNewOrderButton() {
    return Obx(() {
      if (controller.currentTabIndex.value == 0) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
          child: Flexible(
            child: ElevatedButton.icon(
              onPressed: () {
                _showAddClientOrderDialog();
              },
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: AppSpacings.s,
                    color: AppColors.textOnPrimary,
                  ),
                  SizedBox(width: AppSpacings.xs),
                  Icon(
                    Icons.shopping_cart,
                    size: AppSpacings.s,
                    color: AppColors.textOnPrimary,
                  ),
                ],
              ),
              label: Flexible(
                child: Text(
                  'Nouvelle Commande Client',
                  style: AppTypography.bodyMedium
                      .apply(color: AppColors.textOnPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.l),
                ),
              ),
            ),
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacings.l),
          child: Flexible(
            child: ElevatedButton.icon(
              onPressed: () {
                _showAddSupplierOrderDialog();
              },
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: AppSpacings.s,
                    color: AppColors.textOnPrimary,
                  ),
                  SizedBox(width: AppSpacings.xs),
                  Icon(
                    Icons.local_shipping,
                    size: AppSpacings.s,
                    color: AppColors.textOnPrimary,
                  ),
                ],
              ),
              label: Flexible(
                child: Text(
                  'Nouvelle Commande Fournisseur',
                  style: AppTypography.bodyMedium
                      .apply(color: AppColors.textOnPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: AppSpacings.l),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacings.l),
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  double getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 400) return 8;
    if (width < 600) return 12;
    return AppSpacings.l;
  }

  double getResponsiveFontSize(BuildContext context, double base) {
    final width = MediaQuery.of(context).size.width;
    if (width < 400) return base * 0.9;
    if (width < 600) return base * 0.95;
    return base;
  }

  void _showOrderDetails(Order order) {
    final controller = Get.find<ManagementOrderController>();
    
    showDialog(
      context: Get.context!,
      builder: (context) {
        final mq = MediaQuery.of(context);
        final isMobile = mq.size.width < 500;
        final dialogMaxWidth = isMobile ? mq.size.width * 0.95 : 600.0;
        final dialogMaxHeight = isMobile ? mq.size.height * 0.9 : 700.0;
        
        return SafeArea(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: dialogMaxWidth,
                maxHeight: dialogMaxHeight,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.shopping_cart, color: AppColors.primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Détails de la commande',
                            style: AppTypography.titleLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Numéro', order.orderNumber ?? 'N/A'),
                          _buildDetailRow('Client',
                              order.customerLink.value?.name ?? 'N/A'),
                          _buildDetailRow(
                              'Date', controller.formatDate(order.orderDate)),
                          if (order.expectedDeliveryDate != null)
                            _buildDetailRow('Livraison prévue',
                                controller.formatDate(order.orderDate)),
                          _buildDetailRow(
                              'Statut', order.status?.toString() ?? 'N/A'),
                          _buildDetailRow('Prix total',
                              '${order.totalPrice?.toStringAsFixed(2) ?? '0.00'} €'),
                          if (order.createdByLink.value != null)
                            _buildDetailRow('Créée par',
                                order.createdByLink.value!.name ?? 'N/A'),
                          if (order.notes?.isNotEmpty == true)
                            _buildDetailRow('Notes', order.notes!),
                          SizedBox(height: 16),
                          Text(
                            'Articles (${order.orderItems.length})',
                            style: AppTypography.titleMedium,
                          ),
                          SizedBox(height: 8),
                          ...order.orderItems
                              .map((item) => _buildOrderItemTile(item)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSupplierOrderDetails(SupplierOrder order) {
    final controller = Get.find<ManagementOrderController>();
    
    showDialog(
      context: Get.context!,
      builder: (context) {
        final mq = MediaQuery.of(context);
        final isMobile = mq.size.width < 500;
        final dialogMaxWidth = isMobile ? mq.size.width * 0.95 : 600.0;
        final dialogMaxHeight = isMobile ? mq.size.height * 0.9 : 700.0;
        
        return SafeArea(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: dialogMaxWidth,
                maxHeight: dialogMaxHeight,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping, color: AppColors.primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Détails de la commande fournisseur',
                            style: AppTypography.titleLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Numéro', order.orderNumber ?? 'N/A'),
                          _buildDetailRow('Fournisseur',
                              order.supplierLink.value?.name ?? 'N/A'),
                          _buildDetailRow(
                              'Date', controller.formatDate(order.orderDate)),
                          if (order.expectedDeliveryDate != null)
                            _buildDetailRow(
                                'Livraison prévue',
                                controller
                                    .formatDate(order.expectedDeliveryDate)),
                          if (order.actualDeliveryDate != null)
                            _buildDetailRow(
                                'Livraison effective',
                                controller
                                    .formatDate(order.actualDeliveryDate)),
                          _buildDetailRow(
                              'Statut', order.status?.toString() ?? 'N/A'),
                          _buildDetailRow('Prix total',
                              '${order.totalPrice?.toStringAsFixed(2) ?? '0.00'} €'),
                          if (order.createdByLink.value != null)
                            _buildDetailRow('Créée par',
                                order.createdByLink.value!.name ?? 'N/A'),
                          if (order.notes?.isNotEmpty == true)
                            _buildDetailRow('Notes', order.notes!),
                          SizedBox(height: 16),
                          Text(
                            'Articles (${order.supplierOrderItems.length})',
                            style: AppTypography.titleMedium,
                          ),
                          SizedBox(height: 8),
                          ...order.supplierOrderItems
                              .map((item) => _buildSupplierOrderItemTile(item)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.greyMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemTile(OrderItem item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(Icons.inventory_2, color: AppColors.primaryColor),
        title: Text(
          item.productLink.value?.name ?? 'Produit inconnu',
          style: AppTypography.bodyMedium,
        ),
        subtitle: Text(
          'Quantité: ${item.quantity}',
          style: AppTypography.bodySmall,
        ),
        trailing: Text(
          '${item.totalPrice?.toStringAsFixed(2) ?? '0.00'} €',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierOrderItemTile(SupplierOrderItem item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(Icons.inventory_2, color: AppColors.primaryColor),
        title: Text(
          item.productLink.value?.name ?? 'Produit inconnu',
          style: AppTypography.bodyMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commandé: ${item.quantityOrdered}',
              style: AppTypography.bodySmall,
            ),
            if (item.quantityReceived != null && item.quantityReceived! > 0)
              Text(
                'Reçu: ${item.quantityReceived}',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.green,
                ),
              ),
          ],
        ),
        trailing: Text(
          '${item.totalCost?.toStringAsFixed(2) ?? '0.00'} €',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  void _showAddClientOrderDialog() {
    final customerController = TextEditingController();
    final notesController = TextEditingController();
    final List<Map<String, dynamic>> items = [];
    String? selectedCustomer;
    List<Customer> customers = [];
    List<Product> products = [];
    final focusNode = FocusNode();

    showDialog(
      context: Get.context!,
      barrierColor: Colors.black.withOpacity(0.15),
      builder: (context) {
        final mq = MediaQuery.of(context);
        final isMobile = mq.size.width < 500;
        final dialogMaxWidth = isMobile ? mq.size.width * 0.98 : 500.0;
        final dialogMaxHeight = isMobile ? mq.size.height * 0.92 : 700.0;
        final dialogPadding = isMobile ? 8.0 : 24.0;
        return SafeArea(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 350),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 40),
                  child: child,
                ),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: dialogMaxWidth,
                  maxHeight: dialogMaxHeight,
                  minHeight: 200,
                ),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 32,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Illustration/Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 24, bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.08),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.shopping_cart_checkout,
                              size: 48, color: AppColors.primaryColor),
                          SizedBox(height: 8),
                          Text('Nouvelle Commande Client',
                              style: AppTypography.titleLarge
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: AppColors.greyLight),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: dialogPadding, vertical: 16),
                        child: StatefulBuilder(
                          builder: (context, setState) => FutureBuilder(
                            future: () async {
                              try {
                                final customers = await controller
                                    .isar.customers
                                    .where()
                                    .findAll();
                                final products = await controller.isar.products
                                    .where()
                                    .findAll();
                                return [customers, products];
                              } catch (e) {
                                print(
                                    'Erreur lors de la récupération des données: $e');
                                return [[], []];
                              }
                            }(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasData && snapshot.data != null) {
                                customers = snapshot.data![0] as List<Customer>;
                                products = snapshot.data![1] as List<Product>;
                              }
                              // Clients favoris (chips)
                              final recentClients = customers.take(4).toList();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text('Client',
                                      style: AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 6),
                                  if (recentClients.isNotEmpty)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Wrap(
                                        spacing: 8,
                                        children: [
                                          ...recentClients.map((c) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 0.0),
                                                child: ActionChip(
                                                  label: Text(
                                                    c.name ?? '',
                                                    style: AppTypography
                                                        .bodySmall
                                                        .copyWith(fontSize: 12),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  avatar: Icon(Icons.person,
                                                      size: 16,
                                                      color: AppColors
                                                          .primaryColor),
                                                  backgroundColor: AppColors
                                                      .primaryColor
                                                      .withOpacity(0.12),
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedCustomer = c.name;
                                                      customerController.text =
                                                          c.name ?? '';
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              focusNode);
                                                    });
                                                  },
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.greyLight.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: selectedCustomer,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        labelText: 'Sélectionner client',
                                        labelStyle: AppTypography.bodySmall
                                            .copyWith(fontSize: 13),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        prefixIcon: Icon(Icons.person,
                                            color: AppColors.greyMedium,
                                            size: 18),
                                        suffixIcon: Tooltip(
                                          message:
                                              'Choisissez un client existant ou saisissez-en un nouveau',
                                          child: Icon(Icons.info_outline,
                                              color: AppColors.greyMedium,
                                              size: 16),
                                        ),
                                      ),
                                      style: AppTypography.bodySmall
                                          .copyWith(fontSize: 13),
                                      items: [
                                        ...customers.map((customer) =>
                                            DropdownMenuItem(
                                              value: customer.name,
                                              child: Text(customer.name ?? '',
                                                  style: AppTypography.bodySmall
                                                      .copyWith(fontSize: 13),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            )),
                                        DropdownMenuItem(
                                          value: 'custom',
                                          child: Text(
                                              'Autre (saisir manuellement)',
                                              style: AppTypography.bodySmall
                                                  .copyWith(fontSize: 13)),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCustomer = value;
                                          if (value != 'custom') {
                                            customerController.text =
                                                value ?? '';
                                          } else {
                                            customerController.clear();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  if (selectedCustomer == 'custom') ...[
                                    SizedBox(height: 12),
                                    TextField(
                                      controller: customerController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        labelText: 'Nom du client',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        prefixIcon: Icon(Icons.person_add,
                                            color: AppColors.greyMedium),
                                        helperText:
                                            'Saisissez le nom du client',
                                      ),
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                    ),
                                  ],
                                  SizedBox(height: 16),
                                  Text('Notes',
                                      style: AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 6),
                                  TextField(
                                    controller: notesController,
                                    decoration: InputDecoration(
                                      labelText: 'Notes (optionnel)',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      prefixIcon: Icon(Icons.note,
                                          color: AppColors.greyMedium),
                                    ),
                                    maxLines: 2,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Icon(Icons.inventory_2,
                                          color: AppColors.primaryColor),
                                      SizedBox(width: 8),
                                      Text('Articles de la commande',
                                          style: AppTypography.titleMedium
                                              .copyWith(
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  if (items.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.info_outline,
                                              color: AppColors.greyMedium),
                                          SizedBox(width: 8),
                                          Expanded(
                                              child: Text(
                                                  'Ajoutez au moins un article à la commande.',
                                                  style:
                                                      AppTypography.bodySmall)),
                                        ],
                                      ),
                                    ),
                                  if (items.isNotEmpty) ...[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.greyLight),
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppColors.greyLight
                                            .withOpacity(0.15),
                                      ),
                                      child: Column(
                                        children: [
                                          for (int i = 0; i < items.length; i++)
                                            _buildOrderItemTileForDialog(
                                                items[i], items, setState, i),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                  ],
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: products.isEmpty
                                              ? null
                                              : () {
                                                  _showAddItemDialog(items,
                                                      setState, products);
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 300),
                                                      () {
                                                    Get.snackbar(
                                                        'Article ajouté',
                                                        'L’article a été ajouté à la commande',
                                                        backgroundColor:
                                                            AppColors
                                                                .primaryColor,
                                                        colorText: Colors.white,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        duration: Duration(
                                                            seconds: 1));
                                                  });
                                                },
                                          icon: Icon(Icons.add,
                                              color: Colors.white, size: 18),
                                          label: Text('Ajouter un article',
                                              style: AppTypography.bodySmall
                                                  .copyWith(
                                                      fontSize: 13,
                                                      color: AppColors
                                                          .textOnPrimary)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            minimumSize: Size(0, 36),
                                          ),
                                        ),
                                      ),
                                      if (products.isEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Tooltip(
                                            message:
                                                'Aucun produit disponible. Rafraîchir la liste.',
                                            child: IconButton(
                                              icon: Icon(Icons.refresh,
                                                  color:
                                                      AppColors.primaryColor),
                                              onPressed: () {
                                                controller.refreshData();
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (products.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.warning_amber,
                                              color: Colors.orange),
                                          SizedBox(width: 8),
                                          Expanded(
                                              child: Text(
                                                  'Aucun produit disponible. Veuillez en ajouter ou rafraîchir.',
                                                  style:
                                                      AppTypography.bodySmall)),
                                        ],
                                      ),
                                    ),
                                  if (items.isNotEmpty) ...[
                                    SizedBox(height: 16),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.greyLight
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total:',
                                              style: AppTypography.titleMedium
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          Text(
                                              '${_calculateTotal(items).toStringAsFixed(2)} €',
                                              style: AppTypography.titleMedium
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .primaryColor)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 24),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Sticky validation button
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                          dialogPadding, 0, dialogPadding, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Annuler'),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              final customerName = selectedCustomer == 'custom'
                                  ? customerController.text
                                  : selectedCustomer;
                              if (customerName == null ||
                                  customerName.isEmpty) {
                                Get.snackbar(
                                  'Erreur',
                                  'Veuillez sélectionner ou saisir un client',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                );
                                return;
                              }
                              if (items.isEmpty) {
                                Get.snackbar(
                                  'Erreur',
                                  'Veuillez ajouter au moins un article',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                );
                                return;
                              }
                              controller.createClientOrder(
                                customerName: customerName,
                                items: items,
                                notes: notesController.text.isEmpty
                                    ? null
                                    : notesController.text,
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Créer la commande'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateTotal(List<Map<String, dynamic>> items) {
    return items.fold(0.0, (sum, item) {
      final quantity = item['quantity'] as int? ?? 0;
      final price = item['unitPrice'] as double? ?? 0.0;
      return sum + (quantity * price);
    });
  }

  Widget _buildOrderItemTileForDialog(
      Map<String, dynamic> item,
      List<Map<String, dynamic>> items,
      void Function(void Function()) setState,
      int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          item['productName'] ?? '',
          style: AppTypography.bodySmall
              .copyWith(fontWeight: FontWeight.w600, fontSize: 13),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantité: ${item['quantity']}',
                style: AppTypography.bodySmall.copyWith(fontSize: 12)),
            Text('Prix unitaire: ${item['unitPrice']} €',
                style: AppTypography.bodySmall.copyWith(fontSize: 12)),
            Text(
              'Total: ${(item['quantity'] * item['unitPrice']).toStringAsFixed(2)} €',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red, size: 18),
          onPressed: () => setState(() => items.remove(item)),
        ),
      ),
    );
  }

  void _showAddItemDialog(List<Map<String, dynamic>> items,
      void Function(void Function()) setState, List<Product> products) {
    final productController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    Product? selectedProduct;

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.add_shopping_cart, color: AppColors.primaryColor),
            SizedBox(width: 8),
            Text('Ajouter un article'),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, dialogSetState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sélectionner un produit',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<Product>(
                  value: selectedProduct,
                  decoration: InputDecoration(
                    labelText: 'Produit',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    prefixIcon:
                        Icon(Icons.inventory_2, color: AppColors.greyMedium),
                  ),
                  items: [
                    ...products.map((product) => DropdownMenuItem(
                          value: product,
                          child: Text(product.name ?? ''),
                        )),
                    DropdownMenuItem(
                      value: null,
                      child: Text('Autre (saisir manuellement)'),
                    ),
                  ],
                  onChanged: (product) {
                    dialogSetState(() {
                      selectedProduct = product;
                      if (product != null) {
                        productController.text = product.name ?? '';
                        priceController.text =
                            (product.salePrice ?? 0).toString();
                      } else {
                        productController.clear();
                        priceController.clear();
                      }
                    });
                  },
                ),
              ),
              if (selectedProduct == null) ...[
                SizedBox(height: 12),
                TextField(
                  controller: productController,
                  decoration: InputDecoration(
                    labelText: 'Nom du produit',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.edit, color: AppColors.greyMedium),
                  ),
                ),
              ],
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantité',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon:
                            Icon(Icons.numbers, color: AppColors.greyMedium),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Prix unitaire (€)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon:
                            Icon(Icons.euro, color: AppColors.greyMedium),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              if (quantityController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.greyLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:'),
                      Text(
                        '${_calculateItemTotal(quantityController.text, priceController.text)} €',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final productName =
                  selectedProduct?.name ?? productController.text;
              final quantity = int.tryParse(quantityController.text);
              final price = double.tryParse(priceController.text);

              if (productName.isEmpty || quantity == null || price == null) {
                Get.snackbar(
                  'Erreur',
                  'Veuillez remplir tous les champs correctement',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }

              setState(() {
                items.add({
                  'productName': productName,
                  'quantity': quantity,
                  'unitPrice': price,
                });
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  String _calculateItemTotal(String quantity, String price) {
    final qty = int.tryParse(quantity) ?? 0;
    final prc = double.tryParse(price) ?? 0.0;
    return (qty * prc).toStringAsFixed(2);
  }

  void _showClientOrderActions(Order order) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        final mq = MediaQuery.of(context);
        final isMobile = mq.size.width < 500;
        final dialogMaxWidth = isMobile ? mq.size.width * 0.95 : 400.0;
        
        return SafeArea(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: dialogMaxWidth,
                minHeight: 200,
              ),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.more_vert, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Actions pour la commande',
                          style: AppTypography.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.visibility, color: AppColors.primaryColor),
                    title: Text('Voir les détails'),
                    onTap: () {
                      Navigator.pop(context);
                      _showOrderDetails(order);
                    },
                  ),
                  if (order.status != OrderStatusIsar.delivered)
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Marquer comme livrée'),
                      onTap: () {
                        Navigator.pop(context);
                        controller.markClientOrderAsDelivered(order);
                      },
                    ),
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Supprimer'),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteClientOrderConfirmation(order);
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Fermer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteClientOrderConfirmation(Order order) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content:
            Text('Êtes-vous sûr de vouloir supprimer cette commande client ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteClientOrder(order);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showSupplierOrderActions(SupplierOrder order) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        final mq = MediaQuery.of(context);
        final isMobile = mq.size.width < 500;
        final dialogMaxWidth = isMobile ? mq.size.width * 0.95 : 400.0;
        
        return SafeArea(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: dialogMaxWidth,
                minHeight: 200,
              ),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.more_vert, color: AppColors.primaryColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Actions pour la commande',
                          style: AppTypography.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.visibility, color: AppColors.primaryColor),
                    title: Text('Voir les détails'),
                    onTap: () {
                      Navigator.pop(context);
                      _showSupplierOrderDetails(order);
                    },
                  ),
                  if (order.status != SupplierOrderStatusIsar.received)
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Marquer comme reçue'),
                      onTap: () {
                        Navigator.pop(context);
                        controller.markSupplierOrderAsReceived(order);
                      },
                    ),
                  ListTile(
                    leading: Icon(Icons.inventory_2, color: Colors.blue),
                    title: Text('Réceptionner'),
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(Routes.RECEPTION, arguments: order.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Supprimer'),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(order);
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Fermer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(SupplierOrder order) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text(
            'Êtes-vous sûr de vouloir supprimer cette commande fournisseur ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteSupplierOrder(order);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showAddSupplierOrderDialog() {
    final supplierController = TextEditingController();
    final notesController = TextEditingController();
    final List<Map<String, dynamic>> items = [];

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Nouvelle Commande Fournisseur'),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: supplierController,
                  decoration: InputDecoration(
                    labelText: 'Nom du fournisseur',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optionnel)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Text('Articles:', style: AppTypography.titleMedium),
                SizedBox(height: 8),
                Column(
                  children: [
                    for (var item in items)
                      _buildSupplierOrderItemTileForDialog(
                          item, items, setState),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _showAddSupplierItemDialog(items, setState),
                      icon: Icon(Icons.add),
                      label: Text('Ajouter un article'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (supplierController.text.isEmpty) {
                Get.snackbar(
                  'Erreur',
                  'Veuillez saisir le nom du fournisseur',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              if (items.isEmpty) {
                Get.snackbar(
                  'Erreur',
                  'Veuillez ajouter au moins un article',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              controller.createSupplierOrder(
                supplierName: supplierController.text,
                items: items,
                notes:
                    notesController.text.isEmpty ? null : notesController.text,
              );
              Navigator.pop(context);
            },
            child: Text('Créer'),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierOrderItemTileForDialog(
      Map<String, dynamic> item,
      List<Map<String, dynamic>> items,
      void Function(void Function()) setState) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(item['productName'] ?? ''),
        subtitle:
            Text('Quantité: ${item['quantity']} - Prix: ${item['unitCost']} €'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => setState(() => items.remove(item)),
        ),
      ),
    );
  }

  void _showAddSupplierItemDialog(List<Map<String, dynamic>> items,
      void Function(void Function()) setState) {
    final productController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un article'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productController,
              decoration: InputDecoration(
                labelText: 'Nom du produit',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantité',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Prix unitaire (€)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text);
              final price = double.tryParse(priceController.text);
              if (productController.text.isEmpty ||
                  quantity == null ||
                  price == null) {
                Get.snackbar(
                  'Erreur',
                  'Veuillez remplir tous les champs correctement',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              setState(() {
                items.add({
                  'productName': productController.text,
                  'quantity': quantity,
                  'unitCost': price,
                });
              });
              Navigator.pop(context);
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
