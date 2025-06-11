import 'package:isar/isar.dart';

//part 'isar_models.g.dart'; // Assurez-vous d'exécuter build_runner

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names

// Énumérations utilisées dans les modèles

enum UserRoleIsar { admin, manager, employee }

enum SaleStatusIsar { pending, completed, returned, cancelled }

enum OrderStatusIsar { pending, processing, shipped, delivered, cancelled }

enum SupplierOrderStatusIsar {
  draft,
  sent,
  partiallyReceived,
  received,
  cancelled
}

enum InventoryMovementTypeIsar {
  initialStock, // Stock initial lors de la création du produit
  sale, // Vente d'un produit
  purchaseReceived, // Réception d'une commande fournisseur
  adjustmentIn, // Ajustement manuel positif (ex: trouvaille)
  adjustmentOut, // Ajustement manuel négatif (ex: casse, perte)
  customerReturn, // Retour d'un client
  supplierReturn, // Retour à un fournisseur
}

enum DebtStatusIsar { unpaid, partiallyPaid, paid }

//----------------------------------------------------------------------------//
// MODÈLE: Utilisateur (User)
//----------------------------------------------------------------------------//
@collection
class User {
  Id? id; // Auto-increment by Isar

  @Index(unique: true, caseSensitive: false)
  String? email; // Email de connexion, unique

  String? name; // Nom complet de l'utilisateur
  String? passwordHash; // Hash du mot de passe

  @Enumerated(EnumType.name)
  UserRoleIsar? role; // Rôle de l'utilisateur dans l'application

  DateTime? createdAt;
  DateTime? updatedAt;

  // Constructeur
  User({
    required this.email,
    required this.name,
    required this.passwordHash,
    this.role = UserRoleIsar.employee, // Rôle par défaut
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now();
}

//----------------------------------------------------------------------------//
// MODÈLE: Catégorie de Produit (Category)
//----------------------------------------------------------------------------//
@collection
class ProductCategory {
  Id? id;

  @Index(unique: true, caseSensitive: false)
  String? name; // Nom de la catégorie, unique

  String? description;

  // Liaison inverse: produits appartenant à cette catégorie
  @Backlink(to: 'categoryLink')
  final products = IsarLinks<Product>();

  // Constructeur
  ProductCategory({required this.name, this.description});
}

//----------------------------------------------------------------------------//
// MODÈLE: Produit (Product)
//----------------------------------------------------------------------------//
@collection
class Product {
  Id? id;

  @Index(type: IndexType.value, caseSensitive: false)
  String? name; // Nom du produit

  String? description;
  double? salePrice; // Prix de vente
  double? purchasePrice; // Prix d'achat (optionnel)

  @Index()
  int? stockQuantity; // Quantité actuelle en stock

  @Index(unique: true, caseSensitive: false)
  String? sku; // Stock Keeping Unit, unique si utilisé

  String? barcode; // Code-barres
  String? imageUrl; // URL ou chemin local de l'image

  DateTime? createdAt;
  DateTime? updatedAt;

  // Liaison: catégorie du produit
  final categoryLink = IsarLink<ProductCategory>();

  // Liaisons inverses pour retrouver où ce produit est utilisé
  @Backlink(to: 'productLink')
  final saleItems = IsarLinks<SaleItem>();

  @Backlink(to: 'productLink')
  final orderItems = IsarLinks<OrderItem>();

  @Backlink(to: 'productLink')
  final supplierOrderItems = IsarLinks<SupplierOrderItem>();

  @Backlink(to: 'productLink')
  final inventoryMovements = IsarLinks<InventoryMovement>();

  // Constructeur
  Product({
    required this.name,
    required this.salePrice,
    this.stockQuantity = 0,
    this.description,
    this.purchasePrice,
    this.sku,
    this.barcode,
    this.imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now();
}

//----------------------------------------------------------------------------//
// MODÈLE: Client (Customer)
//----------------------------------------------------------------------------//
@collection
class Customer {
  Id? id;

  @Index(type: IndexType.value, caseSensitive: false)
  String? name; // Nom du client

  @Index(unique: true, caseSensitive: false)
  String? email; // Email du client, unique si fourni

  String? phone;
  String? address;
  String? notes; // Notes diverses sur le client

  DateTime? createdAt;

  // Liaisons inverses
  @Backlink(to: 'customerLink')
  final sales = IsarLinks<Sale>();

  @Backlink(to: 'customerLink')
  final orders = IsarLinks<Order>();

  @Backlink(to: 'customerLink')
  final debts = IsarLinks<Debt>();

  // Constructeur
  Customer({
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.notes,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();
}

//----------------------------------------------------------------------------//
// MODÈLE: Vente (Sale) - Transaction complétée
//----------------------------------------------------------------------------//
@collection
class Sale {
  Id? id;

  @Index(unique: true)
  String? saleNumber; // Numéro de vente unique (ex: V2024-0001)

  DateTime? saleDate;
  double? totalPrice; // Prix total de la vente
  double? totalTaxAmount; // Montant total des taxes (si applicable)
  double? discountAmount; // Montant de la réduction appliquée

  @Enumerated(EnumType.name)
  SaleStatusIsar? status;

  String? paymentMethod; // Ex: "Espèces", "Carte Bancaire"
  String? notes;

  // Liaison: client associé à la vente (peut être nul pour ventes anonymes)
  final customerLink = IsarLink<Customer>();

  // Liaison: utilisateur ayant traité la vente
  final processedByLink = IsarLink<User>();

  // Liaison: articles de cette vente
  @Backlink(to: 'saleLink')
  final saleItems = IsarLinks<SaleItem>();

  // Constructeur
  Sale({
    required this.saleNumber,
    required this.saleDate,
    required this.totalPrice,
    this.totalTaxAmount = 0.0,
    this.discountAmount = 0.0,
    this.status = SaleStatusIsar.completed,
    this.paymentMethod,
    this.notes,
  });
}

//----------------------------------------------------------------------------//
// MODÈLE: Article de Vente (SaleItem) - Ligne d'une vente
//----------------------------------------------------------------------------//
@collection
class SaleItem {
  Id? id;

  int? quantity;
  double? unitPriceAtSale; // Prix unitaire au moment de la vente
  double? totalPrice; // quantity * unitPriceAtSale

  // Liaison: produit vendu
  final productLink = IsarLink<Product>();

  // Liaison: vente à laquelle cet article appartient
  final saleLink = IsarLink<Sale>();

  // Constructeur
  SaleItem({
    required this.quantity,
    required this.unitPriceAtSale,
  }) : this.totalPrice = quantity! * unitPriceAtSale!;
}

//----------------------------------------------------------------------------//
// MODÈLE: Commande Client (Order) - Pour pré-commandes, etc.
//----------------------------------------------------------------------------//
@collection
class Order {
  Id? id;

  @Index(unique: true)
  String? orderNumber; // Numéro de commande unique

  DateTime? orderDate;
  DateTime? expectedDeliveryDate;
  double? totalPrice; // Prix total estimé de la commande

  @Enumerated(EnumType.name)
  OrderStatusIsar? status;

  String? shippingAddress;
  String? notes;

  // Liaison: client ayant passé la commande
  final customerLink = IsarLink<Customer>();

  // Liaison: utilisateur ayant enregistré la commande
  final createdByLink = IsarLink<User>();

  // Liaison: articles de cette commande
  @Backlink(to: 'orderLink')
  final orderItems = IsarLinks<OrderItem>();

  // Constructeur
  Order({
    required this.orderNumber,
    required this.orderDate,
    required this.totalPrice,
    this.status = OrderStatusIsar.pending,
    this.expectedDeliveryDate,
    this.shippingAddress,
    this.notes,
  });
}

//----------------------------------------------------------------------------//
// MODÈLE: Article de Commande Client (OrderItem)
//----------------------------------------------------------------------------//
@collection
class OrderItem {
  Id? id;

  int? quantity;
  double? unitPriceAtOrder; // Prix unitaire au moment de la commande
  double? totalPrice; // quantity * unitPriceAtOrder

  // Liaison: produit commandé
  final productLink = IsarLink<Product>();

  // Liaison: commande à laquelle cet article appartient
  final orderLink = IsarLink<Order>();

  // Constructeur
  OrderItem({
    required this.quantity,
    required this.unitPriceAtOrder,
  }) : this.totalPrice = quantity! * unitPriceAtOrder!;
}

//----------------------------------------------------------------------------//
// MODÈLE: Fournisseur (Supplier)
//----------------------------------------------------------------------------//
@collection
class Supplier {
  Id? id;

  @Index(type: IndexType.value, caseSensitive: false)
  String? name; // Nom du fournisseur

  String? contactPerson;
  String? email;
  String? phone;
  String? address;
  String? notes; // Conditions de paiement, etc.

  // Liaison inverse: commandes passées à ce fournisseur
  @Backlink(to: 'supplierLink')
  final supplierOrders = IsarLinks<SupplierOrder>();

  // Constructeur
  Supplier({
    required this.name,
    this.contactPerson,
    this.email,
    this.phone,
    this.address,
    this.notes,
  });
}

//----------------------------------------------------------------------------//
// MODÈLE: Commande Fournisseur (SupplierOrder)
//----------------------------------------------------------------------------//
@collection
class SupplierOrder {
  Id? id;

  @Index(unique: true)
  String?
      orderNumber; // Numéro de commande fournisseur (peut être celui du fournisseur)

  DateTime? orderDate;
  DateTime? expectedDeliveryDate;
  DateTime? actualDeliveryDate;
  double? totalPrice; // Coût total estimé

  @Enumerated(EnumType.name)
  SupplierOrderStatusIsar? status;

  String? notes;

  // Liaison: fournisseur
  final supplierLink = IsarLink<Supplier>();

  // Liaison: utilisateur ayant créé la commande
  final createdByLink = IsarLink<User>();

  // Liaison: articles de cette commande fournisseur
  @Backlink(to: 'supplierOrderLink')
  final supplierOrderItems = IsarLinks<SupplierOrderItem>();

  // Constructeur
  SupplierOrder({
    required this.orderNumber,
    required this.orderDate,
    required this.totalPrice,
    this.status = SupplierOrderStatusIsar.draft,
    this.expectedDeliveryDate,
    this.actualDeliveryDate,
    this.notes,
  });
}

//----------------------------------------------------------------------------//
// MODÈLE: Article de Commande Fournisseur (SupplierOrderItem)
//----------------------------------------------------------------------------//
@collection
class SupplierOrderItem {
  Id? id;

  int? quantityOrdered;
  int? quantityReceived;
  double? unitCost; // Coût unitaire d'achat
  double? totalCost; // quantityOrdered * unitCost

  // Liaison: produit commandé
  final productLink = IsarLink<Product>();

  // Liaison: commande fournisseur à laquelle cet article appartient
  final supplierOrderLink = IsarLink<SupplierOrder>();

  // Constructeur
  SupplierOrderItem({
    required this.quantityOrdered,
    this.quantityReceived = 0,
    required this.unitCost,
  }) : this.totalCost = quantityOrdered! * unitCost!;
}

//----------------------------------------------------------------------------//
// MODÈLE: Mouvement d'Inventaire (InventoryMovement)
//----------------------------------------------------------------------------//
@collection
class InventoryMovement {
  Id? id;

  DateTime? movementDate;

  @Enumerated(EnumType.name)
  InventoryMovementTypeIsar? type; // Type de mouvement

  int? quantityChange; // Positif pour entrée, négatif pour sortie
  int? stockAfterMovement; // Stock du produit après ce mouvement

  String? reason; // Pour ajustements manuels
  String? relatedDocumentId; // ID de la vente, commande fournisseur, etc.

  // Liaison: produit concerné
  final productLink = IsarLink<Product>();

  // Liaison: utilisateur ayant enregistré le mouvement (si applicable)
  final processedByLink = IsarLink<User>();

  // Constructeur
  InventoryMovement({
    required this.movementDate,
    required this.type,
    required this.quantityChange,
    required this.stockAfterMovement,
    this.reason,
    this.relatedDocumentId,
  });
}

//----------------------------------------------------------------------------//
// MODÈLE: Dépense (Expense)
//----------------------------------------------------------------------------//
@collection
class Expense {
  Id? id;

  String? description;
  double? amount;
  DateTime? expenseDate;
  String? category; // Ex: "Loyer", "Fournitures", "Marketing"
  String? receiptImageUrl; // URL ou chemin local du justificatif
  String? notes;

  // Liaison: utilisateur ayant enregistré la dépense
  final recordedByLink = IsarLink<User>();

  // Constructeur
  Expense({
    required this.description,
    required this.amount,
    required this.expenseDate,
    this.category,
    this.receiptImageUrl,
    this.notes,
  });
}

//----------------------------------------------------------------------------//
// MODÈLE: Dette Client (Debt)
//----------------------------------------------------------------------------//
@collection
class Debt {
  Id? id;

  double? initialAmount; // Montant initial de la dette
  double? remainingAmount; // Montant restant dû
  DateTime? debtDate; // Date à laquelle la dette a été créée
  DateTime? dueDate; // Date d'échéance (optionnel)

  @Enumerated(EnumType.name)
  DebtStatusIsar? status;

  String? notes; // Origine de la dette, etc.

  // Liaison: client concerné
  final customerLink = IsarLink<Customer>();

  // Liaison: vente d'origine (si la dette provient d'une vente spécifique)
  final relatedSaleLink = IsarLink<Sale>();

  // Liaison: paiements effectués pour cette dette
  @Backlink(to: 'debtLink')
  final payments = IsarLinks<DebtPayment>();

  // Constructeur
  Debt({
    required this.initialAmount,
    required this.debtDate,
    this.status = DebtStatusIsar.unpaid,
    this.dueDate,
    this.notes,
  }) : this.remainingAmount = initialAmount;
}

//----------------------------------------------------------------------------//
// MODÈLE: Paiement de Dette (DebtPayment)
//----------------------------------------------------------------------------//
@collection
class DebtPayment {
  Id? id;

  double? amountPaid;
  DateTime? paymentDate;
  String? paymentMethod; // Ex: "Espèces", "Virement"
  String? notes;

  // Liaison: dette à laquelle ce paiement se rapporte
  final debtLink = IsarLink<Debt>();

  // Liaison: utilisateur ayant enregistré le paiement
  final recordedByLink = IsarLink<User>();

  // Constructeur
  DebtPayment({
    required this.amountPaid,
    required this.paymentDate,
    this.paymentMethod,
    this.notes,
  });
}

//----------------------------------------------------------------------------//
// MODÈLE: Informations de l'Entreprise (BusinessDetails) - Singleton
//----------------------------------------------------------------------------//
@collection
class BusinessDetails {
  // Utiliser un ID fixe pour s'assurer qu'il n'y a qu'une seule entrée
  static const int fixedId = 1;
  Id get id => fixedId;

  String? businessName;
  String? address;
  String? phone;
  String? email;
  String? taxId; // Numéro d'identification fiscale
  String? logoUrl;
  String? currencySymbol; // Ex: "€"
  String? currencyCode; // Ex: "EUR"
  // Autres informations pertinentes pour l'entreprise

  // Constructeur
  BusinessDetails({
    this.businessName,
    this.address,
    this.phone,
    this.email,
    this.taxId,
    this.logoUrl,
    this.currencySymbol,
    this.currencyCode,
  });
}
