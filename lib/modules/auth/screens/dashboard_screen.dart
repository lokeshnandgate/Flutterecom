import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_state.dart';
import '../../../app/routes.dart';
import '../../../models/product_model.dart';
import '../../../shared/services/api_service.dart';
import '../../../shared/services/storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _categoryFilter = '';
  ProductModel? _editingProduct;
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _categoryIcons = {
    'Electronics': '📱',
    'Fashion': '👕',
    'Home': '🏠',
    'Beauty': '💄',
    'Sports': '⚽',
    'Books': '📚',
    'Toys': '🧸',
    'Food': '🍎',
    'Other': '📦',
  };

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final apiService = ApiService(StorageService());
      final response = await apiService.get('products');
      setState(() {
        _products = (response as List).map((p) => ProductModel.fromJson(p)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<ProductModel> get _filteredProducts {
    return _products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _categoryFilter.isEmpty || product.category == _categoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      final apiService = ApiService(StorageService());
      await apiService.delete('products/$productId');
      setState(() {
        _products.removeWhere((p) => p.id == productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateProduct(ProductModel updatedProduct) async {
    try {
      final apiService = ApiService(StorageService());
      final response = await apiService.put(
        'products/${updatedProduct.id}',
        updatedProduct.toJson(),
      );

      setState(() {
        final index = _products.indexWhere((p) => p.id == updatedProduct.id);
        if (index != -1) {
          _products[index] = ProductModel.fromJson(response);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: ${e.toString()}')),
      );
    }
  }

  void _showEditProductModal(ProductModel product) {
    setState(() {
      _editingProduct = product;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _buildEditProductForm();
      },
    );
  }

  Widget _buildEditProductForm() {
    final nameController = TextEditingController(text: _editingProduct?.name);
    final descriptionController = TextEditingController(text: _editingProduct?.description);
    final priceController = TextEditingController(text: _editingProduct?.price.toString());
    final stockController = TextEditingController(text: _editingProduct?.stockQuantity.toString());
    String category = _editingProduct?.category ?? 'Other';

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: '₹',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      if (double.tryParse(value!) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      if (int.tryParse(value!) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categoryIcons.keys.map((key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text('${_categoryIcons[key]} $key'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        category = value ?? 'Other';
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            nameController.dispose();
                            descriptionController.dispose();
                            priceController.dispose();
                            stockController.dispose();
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final updatedProduct = _editingProduct!.copyWith(
                                name: nameController.text,
                                description: descriptionController.text,
                                price: double.parse(priceController.text),
                                stockQuantity: int.parse(stockController.text),
                                category: category,
                                updatedAt: DateTime.now(),
                              );
                              await _updateProduct(updatedProduct);
                              nameController.dispose();
                              descriptionController.dispose();
                              priceController.dispose();
                              stockController.dispose();
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentUserId = appState.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchProducts,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, Routes.profile),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _categoryFilter.isEmpty ? null : _categoryFilter,
                            decoration: InputDecoration(
                              hintText: 'All Categories',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            items: [
                              const DropdownMenuItem<String>(
                                value: '',
                                child: Text('All Categories'),
                              ),
                              ..._categoryIcons.keys.map((key) {
                                return DropdownMenuItem<String>(
                                  value: key,
                                  child: Text('${_categoryIcons[key]} $key'),
                                );
                              }).toList(),
                            ],
                            onChanged: (value) => setState(() => _categoryFilter = value ?? ''),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.filter_alt_off),
                          tooltip: 'Clear filters',
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _categoryFilter = '';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${_filteredProducts.length} products found',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                if (_categoryFilter.isNotEmpty)
                  Chip(
                    label: Text(_categoryFilter),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _categoryFilter = ''),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text('Error: $_error'))
                      : _filteredProducts.isEmpty
                          ? _buildEmptyState()
                          : GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = _filteredProducts[index];
                                final isOwner = product.ownerId == currentUserId;
                                return _buildProductCard(product, isOwner);
                              },
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.addProduct),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, bool isOwner) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.productDetail,
        arguments: product.id,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.imageUrls.isNotEmpty
                    ? Image.network(
                        product.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      if (product.isOnSale) ...[
                        const SizedBox(width: 8),
                        Text(
                          '₹${product.discountedPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discountPercentage?.toStringAsFixed(0)}% OFF',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.category,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.category,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        product.stockQuantity > 0 ? Icons.check_circle : Icons.cancel,
                        size: 12,
                        color: product.stockQuantity > 0 ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.stockQuantity > 0 ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          color: product.stockQuantity > 0 ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (isOwner) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _showEditProductModal(product),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              side: BorderSide.none,
                            ),
                            child: const Text(
                              'EDIT',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _deleteProduct(product.id),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              side: BorderSide.none,
                            ),
                            child: const Text(
                              'DELETE',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            _products.isEmpty ? 'No products yet' : 'No matching products',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or add a new product',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, Routes.addProduct),
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}
