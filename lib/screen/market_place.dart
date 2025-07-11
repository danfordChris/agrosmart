import 'package:agrosmart/models/market_product_model.dart';
import 'package:agrosmart/provider/cart_provider.dart';
import 'package:agrosmart/repositories/market_product_repository.dart';
import 'package:agrosmart/screen/cart_screen.dart';
import 'package:agrosmart/services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrosmart/models/crop_products.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<MarketProductModel> _products = [];
  List<MarketProductModel> _recommendations = [];

  @override
  void initState() {
    _loadProducts();
    _products = SessionManager.instance.products;
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() async {
    final product = await MarketProductRepository.instance.all;
    _products = product;
    _recommendations = product;
    if (product.isNotEmpty) {
      SessionManager.instance.setMarketProducts(product);
    }
  }

  // // Sample products data
  // final List<MarketProductModel> _products = [
  // ];

  // Sample crop recommendations data
  // final List<CropRecommendation> _recommendations = [
  //   CropRecommendation(
  //     name: 'Soybeans',
  //     description:
  //         'Grows well in warm climates with well-drained soils. Nitrogen-fixing crop.',
  //     idealTemperature: '20°C - 30°C',
  //     imageUrl: 'assets/images/soybeans.png',
  //     suitability: 'High',
  //   ),
  //   CropRecommendation(
  //     name: 'Wheat',
  //     description:
  //         'Best in cool climates with moderate rainfall. Requires fertile soil.',
  //     idealTemperature: '15°C - 25°C',
  //     imageUrl: 'assets/images/wheat.png',
  //     suitability: 'Medium',
  //   ),
  //   CropRecommendation(
  //     name: 'Rice',
  //     description:
  //         'Thrives in flooded conditions. Requires abundant water and warm temperatures.',
  //     idealTemperature: '20°C - 35°C',
  //     imageUrl: 'assets/images/rice.png',
  //     suitability: 'High',
  //   ),
  //   CropRecommendation(
  //     name: 'Maize',
  //     description:
  //         'Versatile crop that grows in various conditions. Needs regular watering.',
  //     idealTemperature: '20°C - 32°C',
  //     imageUrl: 'assets/images/maize.png',
  //     suitability: 'High',
  //   ),
  // ];

  List<MarketProductModel> get _filteredProducts {
    if (_searchQuery.isEmpty) return _products;
    return _products.where((product) {
      return product.name!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description!.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          product.seller!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.location!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crop Marketplace',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              if (cartProvider.cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartProvider.cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for crops...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),

          // Product listings
          Expanded(
            child:
                _filteredProducts.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results for "$_searchQuery"',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Container(
                            color: Colors.white,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.0),
                              onTap: () {
                                _showProductDetail(context, product);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        product.imageUrl!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  color: Colors.grey.shade100,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Product details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name!,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.description!.length > 50
                                                ? '${product.description!.substring(0, 50)}...'
                                                : product.description!,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                size: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                product.seller!,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Spacer(),
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                product.location!,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'TZS ${product.price}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                product.date!,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
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
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _showCropRecommendationScreen(context);
        },
        child: const Icon(Icons.agriculture, color: Colors.white),
      ),
    );
  }

  void _showProductDetail(BuildContext context, MarketProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: EdgeInsets.only(bottom: 24),
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        product.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 200,
                              color: Colors.grey.shade100,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey.shade400,
                              ),
                            ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        child: IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {
                            // Share product
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sharing product...'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Product information
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getSuitabilityColor(
                                product.suitability!,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Suitability: ${product.suitability}',
                              style: TextStyle(
                                color: _getSuitabilityColor(
                                  product.suitability!,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'TZS ${product.price}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Seller information
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green.shade100,
                                child: Text(
                                  product.seller![0],
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.seller!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Location: ${product.location}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: Colors.green.shade700,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Messaging ${product.seller}...',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Product description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description!,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Growing information
                      const Text(
                        'Growing Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.thermostat,
                        'Ideal Temperature',
                        product.idealTemperature!,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Listing Date',
                        product.date!,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Provider.of<CartProvider>(
                              context,
                              listen: false,
                            ).addToCart(product);
                            Navigator.pop(context);
                            _showSuccessMessage('Product added to cart');
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Provider.of<CartProvider>(
                              context,
                              listen: false,
                            ).addToCart(product);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 20),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value),
      ],
    );
  }

  Color _getSuitabilityColor(String suitability) {
    switch (suitability.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    final sellerController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Product'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sellerController,
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final newProduct = MarketProductModel(
                      // id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      description: descController.text,
                      idealTemperature: '20°C - 30°C',
                      imageUrl: 'assets/images/default_product.png',
                      suitability: 'High',
                      price: priceController.text,
                      seller: sellerController.text,
                      location: locationController.text,
                      date:
                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    );

                    setState(() {
                      _products.insert(0, newProduct);
                    });

                    Navigator.pop(context);
                    _showSuccessMessage('Product added successfully');
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showCropRecommendationScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                surfaceTintColor: Colors.white,
                title: const Text('Crop Recommendations'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              body: Container(
                color: Colors.white,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _recommendations.length,
                  itemBuilder: (context, index) {
                    final crop = _recommendations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    crop.imageUrl!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 80,
                                              height: 80,
                                              color: Colors.grey.shade100,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            crop.name!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getSuitabilityColor(
                                                crop.suitability!,
                                              ).withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              crop.suitability!,
                                              style: TextStyle(
                                                color: _getSuitabilityColor(
                                                  crop.suitability!,
                                                ),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.thermostat,
                                            size: 16,
                                            color: Colors.orange.shade800,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            crop.idealTemperature!,
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              crop.description!,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _searchController.text = crop.name!;
                                    _searchQuery = crop.name!;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text(
                                  'Find Products',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      ),
    );
  }
}
