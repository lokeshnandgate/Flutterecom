import '../../../shared/services/api_service.dart';

class ProductService {
  final ApiService apiService;

  ProductService(this.apiService);

  Future<List<dynamic>> getProducts() async {
    return await apiService.get('products');
  }

  Future<dynamic> getProduct(String productId) async {
    return await apiService.get('products/$productId');
  }

  Future<dynamic> createProduct(Map<String, dynamic> productData) async {
    return await apiService.post('products', productData);
  }

  Future<dynamic> updateProduct(String productId, Map<String, dynamic> productData) async {
    return await apiService.put('products/$productId', productData);
  }

  Future<void> deleteProduct(String productId) async {
    await apiService.delete('products/$productId');
  }
}