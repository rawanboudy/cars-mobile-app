import 'cars_page.dart';
import '../theme/theme.dart';
import 'car_details_page.dart';
import '../theme/custom_nav_bar.dart';
import '../theme/custom_app_bar.dart';
import 'package:flutter/material.dart';

class CarHomePage extends StatefulWidget {
  const CarHomePage({super.key});

  @override
  State<CarHomePage> createState() => _CarHomePageState();
}

class _CarHomePageState extends State<CarHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homeBody(),
      _carsBody(),
      _profileBody(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(),
      body: pages[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // All other methods remain the same
  Widget _homeBody() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildCarousel(),
        const SizedBox(height: 10),
        _buildBrandChips(),
        const SizedBox(height: 20),
        _buildSectionTitle("Popular cars"),
        _buildCarList(),
        _buildSectionTitle("New cars"),
        _buildCarList(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _carsBody() {
    return const Center(
      child: Text("Cars Page", style: TextStyle(color: AppColors.text, fontSize: 20)),
    );
  }

  Widget _profileBody() {
    return const Center(
      child: Text("Profile Page", style: TextStyle(color: AppColors.text, fontSize: 20)),
    );
  }

  Widget _buildCarousel() {
    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: PageView(
        children: [
          _offerCard("Porsche 911 GTS RS", 528.00, 'assets/car1.jpg'),
          _offerCard("Maserati Granturismo", 459.00, 'assets/car2.jpg'),
        ],
      ),
    );
  }

  Widget _offerCard(String title, double price, String imgPath) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 6),
            Text("\$${price.toStringAsFixed(2)}", style: const TextStyle(color: AppColors.description, fontSize: 15)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Image.asset(imgPath, width: 110, height: 60, fit: BoxFit.contain),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Buy Now', style: TextStyle(color: AppColors.mainButtonText)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainButtonBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CarDetailsPage(id: 'car_1'),
                      ),
                    );
                  },
                  child: const Text('Details', style: TextStyle(color: AppColors.secondaryButtonText)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondaryButtonBorder),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandChips() {
    final brands = ["All", "MG", "Hyundai", "BMW", "Toyota"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: brands.map((b) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(b, style: const TextStyle(color: AppColors.text)),
            selected: b == "All",
            selectedColor: AppColors.mainButtonBackground,
            backgroundColor: AppColors.cardBackground,
            onSelected: (_) {
              if (b != "All") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarsPage(brand: b),
                  ),
                );
              }
            },
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 16)),
          const Text("See All", style: TextStyle(color: AppColors.secondaryButtonText, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildCarList() {
    final cars = [
      {
        "name": "Maserati Granturismo",
        "price": 459.00,
        "img": "assets/car2.jpg"
      },
      {
        "name": "Porsche 911 GTS RS",
        "price": 528.00,
        "img": "assets/car1.jpg"
      }
    ];
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cars.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, idx) {
          final car = cars[idx];
          return _carCard(
            car["name"] as String,
            car["price"] as double,
            car["img"] as String,
          );
        },
      ),
    );
  }

  Widget _carCard(String name, double price, String imgPath) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imgPath, height: 50, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("\$${price.toStringAsFixed(2)}", style: const TextStyle(color: AppColors.description)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Buy now', style: TextStyle(color: AppColors.mainButtonText)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainButtonBackground,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CarDetailsPage(id: 'car_1'),
                      ),
                    );
                  },
                  child: const Text('Details', style: TextStyle(color: AppColors.secondaryButtonText)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondaryButtonBorder),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}