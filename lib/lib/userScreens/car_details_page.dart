import '../theme/theme.dart';
import '../theme/custom_nav_bar.dart';
import '../services/car_service.dart';
import 'package:flutter/material.dart';

class CarDetailsPage extends StatefulWidget {
  final String id;

  const CarDetailsPage({super.key, required this.id});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedColorIndex = 0;
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  final CarService _carService = CarService();
  Map<String, dynamic>? carData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCarData();
  }

  Future<void> _loadCarData() async {
    final data = await _carService.getCarById(widget.id);
    setState(() {
      carData = data;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (carData == null) {
      return const Center(child: Text('Car not found'));
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildCarHeader()),
          SliverToBoxAdapter(child: _buildTabBar()),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildSpecificationsTab(),
            _buildFeaturesTab(),
            _buildColorsTab(),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
        onTap: (index) {
          Navigator.pushReplacementNamed(
            context,
            index == 0 ? '/home' : index == 1 ? '/cars' : '/profile',
          );
        },
      ),
    );
  }


Widget _buildSliverAppBar() {
  final images = List<String>.from(carData?['images'] ?? []);

  return SliverAppBar(
    expandedHeight: MediaQuery.of(context).size.height * 0.35,
    pinned: true,
    backgroundColor: AppColors.mainButtonBackground,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: AppColors.mainButtonBackground),
      onPressed: () => Navigator.pop(context),
    ),
    actions: [
      IconButton(
        icon: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? AppColors.favoriteRed : AppColors.mainButtonBackground,
        ),
        onPressed: () => setState(() => _isFavorite = !_isFavorite),
      ),
      IconButton(
        icon: Icon(Icons.share, color: AppColors.mainButtonBackground),
        onPressed: () {},
      ),
    ],
    flexibleSpace: FlexibleSpaceBar(
      background: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemBuilder: (context, index) {
              final image = images[index];
              // If your images are URLs from Firestore, use Image.network:
              if (image.startsWith('http')) {
                return Image.network(image, fit: BoxFit.cover);
              } else {
                // Otherwise fallback to asset images
                return Image.asset(image, fit: BoxFit.cover);
              }
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? AppColors.mainButtonBackground
                          : Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


Widget _buildCarHeader() {
    final List<Map<String, dynamic>> tags = List<Map<String, dynamic>>.from(carData?['tags'] ?? []);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  carData?['name'],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.text),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(carData?['price'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
                  const Text('Showroom Price', style: TextStyle(fontSize: 12, color: AppColors.description)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tags.map((tag) {
                return _buildFeatureChip(tag['label'], tag['icon']);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mainButtonBackground),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.mainButtonBackground),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.mainButtonBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: AppColors.mainButtonBackground,
      unselectedLabelColor: AppColors.description,
      indicatorColor: AppColors.mainButtonBackground,
      tabs: const [
        Tab(text: 'Overview'),
        Tab(text: 'Specifications'),
        Tab(text: 'Features'),
        Tab(text: 'Colors'),
      ],
    );
  }

  Widget _buildOverviewTab() {
    final highlights = List<String>.from(carData?['highlights'] ?? []);
    final aboutText = carData?['about'] ??
        'This vehicle blends luxury, safety and power with premium technology. Ideal for both family and long-distance journeys.';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About This Car',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 8),
          Text(
            aboutText,
            style: const TextStyle(color: AppColors.description, fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text(
            'Highlights',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 8),
          if (highlights.isEmpty)
            const Text('No highlights available', style: TextStyle(color: AppColors.description)),
          ...highlights.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.check, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(e, style: const TextStyle(color: AppColors.text))),
              ],
            ),
          )),
        ],
      ),
    );
  }


  Widget _buildSpecificationsTab() {
    final Map<String, dynamic> specs = Map<String, dynamic>.from(carData?['specs'] ?? {});

    if (specs.isEmpty) {
      return const Center(
        child: Text('No specifications available', style: TextStyle(color: AppColors.description)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: specs.length,
      itemBuilder: (context, categoryIndex) {
        String category = specs.keys.elementAt(categoryIndex);
        Map<String, dynamic> rawItems = Map<String, dynamic>.from(specs[category] ?? {});
        // Convert all values to string safely
        Map<String, String> items = rawItems.map((key, value) => MapEntry(key, value?.toString() ?? ''));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            ...items.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(e.key, style: const TextStyle(color: AppColors.description)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Text(e.value, style: const TextStyle(color: AppColors.text)),
                  ),
                ],
              ),
            )),
            const Divider(height: 32, color: Colors.grey),
          ],
        );
      },
    );
  }


  Widget _buildColorsTab() {
    final colorsData = carData?['colors'] as List<dynamic>? ?? [];
    final colors = colorsData.cast<Map<String, dynamic>>();
    final selectedColor = colors.isNotEmpty ? colors[_selectedColorIndex] : null;

    if (selectedColor == null) {
      return const Center(
        child: Text('No color data available', style: TextStyle(color: AppColors.description)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Exterior Color',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 16),
          Center(
            child: Image.network(
              selectedColor['image'] ?? '',
              height: MediaQuery.of(context).size.height * 0.25,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedColorIndex == index;
                final colorMap = colors[index];
                // Parse color from hex string or int, fallback to grey
                Color circleColor;
                try {
                  if (colorMap['color'] is int) {
                    circleColor = Color(colorMap['color']);
                  } else if (colorMap['color'] is String) {
                    circleColor = Color(int.parse(colorMap['color'].toString().replaceAll('#', '0xff')));
                  } else {
                    circleColor = Colors.grey;
                  }
                } catch (_) {
                  circleColor = Colors.grey;
                }

                return GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.mainButtonBackground : Colors.grey,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              selectedColor['name'] ?? 'Unknown',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFeaturesTab() {
    final featuresData = (carData?['features'] as Map<String, dynamic>?) ?? {};

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: featuresData.length,
      itemBuilder: (context, index) {
        final category = featuresData.keys.elementAt(index);
        final featuresList = (featuresData[category] as List<dynamic>?) ?? [];

        return ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 8),
          initiallyExpanded: true,
          title: Text(
            category,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          children: featuresList.map<Widget>((featureItem) {
            final bool available = featureItem['available'] ?? false;
            final String featureName = featureItem['feature'] ?? 'Unknown Feature';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    available ? Icons.check_circle : Icons.cancel,
                    color: available ? Colors.green : Colors.red[300],
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      featureName,
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.bold,
                        decoration: available ? null : TextDecoration.lineThrough,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}