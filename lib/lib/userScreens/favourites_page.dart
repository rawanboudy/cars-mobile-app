import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../theme/custom_nav_bar.dart';
import '../theme/custom_app_bar.dart';
import 'car_details_page.dart';

class Car {
  final String id;
  final String name;
  final String imageUrl;
  final String price;

  Car({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  int _currentIndex = 2; // Corresponds to "Favourites" in navbar

  final List<Car> favouriteCars = [
    Car(id: "1", name: 'MG', imageUrl: 'assets/MG.png', price: '\$60,000'),
    Car(id: "3", name: 'KIA', imageUrl: 'assets/KIA.png', price: '\$25,000'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Favourites',
        height: 100,
      ),
      body: favouriteCars.isEmpty
          ? Center(
        child: Text(
          'No favourite cars yet.',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
          ),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 1,
          mainAxisSpacing: 12,
        ),
        itemCount: favouriteCars.length,
        itemBuilder: (context, index) {
          final car = favouriteCars[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Texts & Buttons
                Expanded(
                  flex: 2,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.name,
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              car.price,
                              style: TextStyle(
                                color: AppColors.description,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    AppColors.mainButtonBackground,
                                  ),
                                  onPressed: () {
                                    // Add buy logic
                                  },
                                  child: Text(
                                    "Buy Now",
                                    style: TextStyle(color: AppColors.text),
                                  ),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color:
                                        AppColors.secondaryButtonBorder),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CarDetailsPage(id: car.id),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Details",
                                    style: TextStyle(
                                        color:
                                        AppColors.secondaryButtonText),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Image
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        car.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
