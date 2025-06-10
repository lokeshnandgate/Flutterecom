import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_state.dart';
import '../../../models/product_model.dart';
import '../../../shared/services/api_service.dart';
import '../../../shared/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String? _error;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _profileData;
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final apiService = ApiService(StorageService());
      
      // Check if current user is viewing their own profile
      _isOwner = appState.currentUser?.id == ModalRoute.of(context)!.settings.arguments as String?;
      
      // Load profile data
      final response = await apiService.get('profile/${ModalRoute.of(context)!.settings.arguments}');
      setState(() {
        _profileData = response;
      });
      
      // Load products
      final productsResponse = await apiService.get('products?userId=${ModalRoute.of(context)!.settings.arguments}');
      setState(() {
        _products = (productsResponse as List).map((p) => ProductModel.fromJson(p)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfileChanges(Map<String, dynamic> updatedData) async {
    try {
      final apiService = ApiService(StorageService());
      await apiService.put('profile', updatedData);
      setState(() {
        _profileData = {..._profileData, ...updatedData};
        _isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isOwner ? 'Your Profile' : 'Profile'),
        actions: [
          if (_isOwner)
            IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person)),
            Tab(icon: Icon(Icons.shopping_bag)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProfileTab(),
                    _buildProductsTab(),
                  ],
                ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          _isEditing 
              ? _buildEditProfileForm() 
              : _buildProfileDetails(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _profileData['profilePic'] != null
                ? NetworkImage(_profileData['profilePic'])
                : null,
            child: _profileData['profilePic'] == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            _profileData['username'] ?? 'No username',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _profileData['email'] ?? 'No email',
            style: const TextStyle(color: Colors.grey),
          ),
          if (_profileData['businessType'] != null)
            Chip(
              label: Text(_profileData['businessType']),
              backgroundColor: Colors.blue[50],
            ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _profileData['description'] ?? 'No description provided',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(_profileData['contactNumber'] ?? 'Not provided'),
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(_profileData['address'] ?? 'Not provided'),
          ),
          if (_profileData['locationUrl'] != null)
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('View Location'),
              onTap: () => _launchUrl(_profileData['locationUrl']),
            ),
        ],
      ),
    );
  }

  Widget _buildEditProfileForm() {
    final usernameController = TextEditingController(text: _profileData['username']);
    final emailController = TextEditingController(text: _profileData['email']);
    final contactController = TextEditingController(text: _profileData['contactNumber']);
    final descriptionController = TextEditingController(text: _profileData['description']);
    final addressController = TextEditingController(text: _profileData['address']);
    final locationUrlController = TextEditingController(text: _profileData['locationUrl']);
    String? businessType = _profileData['businessType'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => 
                  value?.contains('@') ?? false ? null : 'Invalid email',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: contactController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'About'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: locationUrlController,
              decoration: const InputDecoration(labelText: 'Location URL'),
            ),
            if (businessType != null) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: businessType,
                items: ['Retail', 'Wholesale', 'Service', 'Manufacturer']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) => businessType = value,
                decoration: const InputDecoration(labelText: 'Business Type'),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _isEditing = false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveProfileChanges({
                          'username': usernameController.text,
                          'email': emailController.text,
                          'contactNumber': contactController.text,
                          'description': descriptionController.text,
                          'address': addressController.text,
                          'locationUrl': locationUrlController.text,
                          if (businessType != null) 'businessType': businessType,
                        });
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsTab() {
    if (_isLoading && _products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _isOwner ? 'You have no products' : 'No products available',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            if (_isOwner)
              TextButton(
                onPressed: () {
                  // TODO: Navigate to add product screen
                },
                child: const Text('Add your first product'),
              ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return GestureDetector(
          onTap: () {
            // TODO: Navigate to product detail
          },
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
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
                    child: product.imageUrls.isNotEmpty
                        ? Image.network(
                            product.imageUrls.first,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image, size: 48, color: Colors.grey),
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                          if (product.isOnSale)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                '₹${product.discountedPrice!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (product.isOnSale)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${product.discountPercentage!.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    // TODO: Implement URL launching
  }
}