class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountedPrice;
  final List<String> imageUrls;
  final String category;
  final int stockQuantity;
  final double? rating;
  final int? reviewCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? tags;
  final Map<String, String>? specifications;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.imageUrls,
    required this.category,
    required this.stockQuantity,
    this.rating,
    this.reviewCount,
    required this.createdAt,
    this.updatedAt,
    this.tags,
    this.specifications,
  });

  // Helper getter to check if product is on sale
  bool get isOnSale => discountedPrice != null && discountedPrice! < price;

  // Calculate discount percentage
  double? get discountPercentage => isOnSale
      ? ((price - discountedPrice!) / price * 100).roundToDouble()
      : null;

  // Factory method to create from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      discountedPrice: json['discountedPrice']?.toDouble(),
      imageUrls: List<String>.from(json['imageUrls']),
      category: json['category'],
      stockQuantity: json['stockQuantity'],
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      specifications: json['specifications'] != null 
          ? Map<String, String>.from(json['specifications'])
          : null,
    );
  }

  get ownerId => null;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'imageUrls': imageUrls,
      'category': category,
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tags': tags,
      'specifications': specifications,
    };
  }

  // Copy with method for immutability
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountedPrice,
    List<String>? imageUrls,
    String? category,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    Map<String, String>? specifications,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
    );
  }
}