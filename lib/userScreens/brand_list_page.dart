import 'cars_page.dart';
import '../theme/theme.dart';
import '../theme/custom_nav_bar.dart';
import '../theme/custom_app_bar.dart';
import 'package:flutter/material.dart';

class Brand {
  final String name;
  final String logoUrl;

  Brand({required this.name, required this.logoUrl});
}

class BrandListPage extends StatefulWidget {
  const BrandListPage({super.key});

  @override
  _BrandListPageState createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  final List<Brand> brands = [
    Brand(name: 'BMW', logoUrl: 'assets/BMW.png'),
    Brand(name: 'Toyota', logoUrl: 'assets/Toyota.png'),
    Brand(name: 'MG', logoUrl: 'assets/MG.png'),
    Brand(name: 'KIA', logoUrl: 'assets/KIA.png'),
    Brand(name: 'Hyundai', logoUrl: 'assets/Hyundai.png'),
  ];

  String searchText = '';
  int _currentIndex = 1; // Set to 1 since this is the Cars/Brands page

  @override
  Widget build(BuildContext context) {
    List<Brand> filteredBrands = brands
        .where((brand) =>
        brand.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Brands',
        height: 120, // You can adjust the height for different pages
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              style: TextStyle(color: AppColors.text),
              decoration: InputDecoration(
                labelText: 'Search brands',
                labelStyle: TextStyle(color: AppColors.description),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.description),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryButtonBorder),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredBrands.length,
              itemBuilder: (context, index) {
                final brand = filteredBrands[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarsPage(brand: brand.name),
                      ),
                    );
                  },
                  child: Card(
                    color: AppColors.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          brand.logoUrl,
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(height: 10),
                        Text(brand.name,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.text,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
        onTap: (_) {}, // No need to update local state, CustomNavBar handles navigation
      ),

    );
  }
}