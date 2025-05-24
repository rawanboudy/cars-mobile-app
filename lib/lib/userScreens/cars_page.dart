import 'package:flutter/material.dart';
import 'car_details_page.dart';
import '../theme/custom_nav_bar.dart';
import '../theme/custom_app_bar.dart';

/// Represents a car with basic attributes and additional fuel type.
class Car {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final String type;
  final String fuelType;  // Added fuel type filter

  Car({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.type,
    required this.fuelType,
  });
}

class CarsPage extends StatefulWidget {
  final String brand;
  const CarsPage({Key? key, required this.brand}) : super(key: key);

  @override
  _CarsPageState createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  int _currentIndex = 1;
  String _searchQuery = '';
  bool _sortAsc = true;
  String _selectedType = 'All';
  String _selectedFuel = 'All';
  RangeValues _priceRange = const RangeValues(0, 100000);

  late int _minPrice;
  late int _maxPrice;
  late List<String> _types;
  late List<String> _fuelTypes;

  final Map<String, List<Car>> carData = {
    'BMW': [
      Car(id: '1', name: 'BMW X5', imageUrl: 'assets/x5.png', price: 60000, type: 'SUV',  fuelType: 'Petrol'),
      Car(id: '2', name: 'BMW M3', imageUrl: 'assets/m3.png', price: 70000, type: 'Sedan',fuelType: 'Petrol'),
    ],
    'Toyota': [
      Car(id: '3', name: 'Camry', imageUrl: 'assets/camry.png', price: 25000, type: 'Sedan',fuelType: 'Hybrid'),
      Car(id: '7', name: 'RAV4', imageUrl: 'assets/rav4.png', price: 28000, type: 'SUV',  fuelType: 'Hybrid'),
    ],
    'MG': [
      Car(id: '4', name: 'MG ZS', imageUrl: 'assets/focus.png', price: 18000, type: 'SUV',  fuelType: 'Electric'),
    ],
    'KIA': [
      Car(id: '5', name: 'KIA Sportage', imageUrl: 'assets/focus.png', price: 20000, type: 'SUV',fuelType: 'Diesel'),
    ],
    'Hyundai': [
      Car(id: '6', name: 'Elantra', imageUrl: 'assets/focus.png', price: 22000, type: 'Sedan',fuelType: 'Petrol'),
    ],
  };

  @override
  void initState() {
    super.initState();
    final list = carData[widget.brand] ?? [];
    _types = ['All', ...{for (var c in list) c.type}];
    _fuelTypes = ['All', ...{for (var c in list) c.fuelType}];
    if (list.isNotEmpty) {
      final prices = list.map((c) => c.price);
      _minPrice = prices.reduce((a, b) => a < b ? a : b);
      _maxPrice = prices.reduce((a, b) => a > b ? a : b);
      _priceRange = RangeValues(_minPrice.toDouble(), _maxPrice.toDouble());
    } else {
      _minPrice = 0;
      _maxPrice = 100000;
    }
  }

  List<Car> get _filtered {
    final list = carData[widget.brand] ?? [];
    return list.where((c) {
      final matchesSearch = c.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType   = _selectedType == 'All' || c.type == _selectedType;
      final matchesFuel   = _selectedFuel == 'All' || c.fuelType == _selectedFuel;
      final inPrice       = c.price >= _priceRange.start && c.price <= _priceRange.end;
      return matchesSearch && matchesType && matchesFuel && inPrice;
    }).toList()
      ..sort((a, b) => _sortAsc ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
  }

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).scaffoldBackgroundColor;
    final cardColor   = Theme.of(context).cardColor;
    final accentColor = Theme.of(context).primaryColor;
    final textColor   = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final descColor   = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: background,
      appBar: const CustomAppBar(title: 'Cars', showAvatar: false, height: 120),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
      body: Column(
        children: [
          // Filter Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search & Sort
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search model...',
                              prefixIcon: Icon(Icons.search, color: descColor),
                              filled: true,
                              fillColor: background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (v) => setState(() => _searchQuery = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: Icon(_sortAsc ? Icons.arrow_upward : Icons.arrow_downward, color: accentColor),
                          onPressed: () => setState(() => _sortAsc = !_sortAsc),
                          tooltip: 'Toggle Price Sort',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Type Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _types.map((t) {
                          final selected = t == _selectedType;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(t),
                              selected: selected,
                              selectedColor: accentColor.withOpacity(0.2),
                              backgroundColor: background,
                              labelStyle: TextStyle(color: selected ? accentColor : textColor),
                              onSelected: (_) => setState(() => _selectedType = t),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Fuel Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _fuelTypes.map((f) {
                          final selected = f == _selectedFuel;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(f),
                              selected: selected,
                              selectedColor: accentColor.withOpacity(0.2),
                              backgroundColor: background,
                              labelStyle: TextStyle(color: selected ? accentColor : textColor),
                              onSelected: (_) => setState(() => _selectedFuel = f),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Price Slider
                    Text(
                      'Price: \$${_priceRange.start.toInt()} – \$${_priceRange.end.toInt()}',
                      style: TextStyle(color: textColor),
                    ),
                    RangeSlider(
                      values: _priceRange,
                      min: _minPrice.toDouble(),
                      max: _maxPrice.toDouble(),
                      activeColor: accentColor,
                      inactiveColor: accentColor.withOpacity(0.3),
                      labels: RangeLabels(
                        '\$${_priceRange.start.toInt()}',
                        '\$${_priceRange.end.toInt()}',
                      ),
                      onChanged: (r) => setState(() => _priceRange = r),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Results Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filtered.length} cars found',
                style: TextStyle(color: descColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Car List
          Expanded(
            child: _filtered.isEmpty
                ? Center(
              child: Text('No cars match filters', style: TextStyle(color: descColor)),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final car = _filtered[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: cardColor,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CarDetailsPage(id: car.id)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  car.name,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  car.type,
                                  style: TextStyle(color: descColor),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${car.price}',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(car.imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
