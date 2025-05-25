import 'sellCarPage.dart';
import '../theme/theme.dart';
import 'brand_list_page.dart';
import '../theme/custom_app_bar.dart';
import '../theme/custom_nav_bar.dart';
import 'package:flutter/material.dart';


class ChooseActionPage extends StatelessWidget {
  const ChooseActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(

        showAvatar: true,

      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1, // Highlights "Explore" tab
        onTap: (index) {
          // Navigation is handled in CustomNavBar
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 36),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.sell_outlined,
                      label: "Sell Your Car",
                      description: "List your vehicle for sale with competitive pricing",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SellCarPage()),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.directions_car_outlined,
                      label: "Buy New Car",
                      description:
                      "Explore the latest models with factory warranty",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BrandListPage()),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.car_rental_outlined,
                      label: "Buy Used Car",
                      description:
                      "Find certified pre-owned vehicles at great values",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BrandListPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "What would you like to do?",
            style: TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Choose one of the options below to continue.",
            style: TextStyle(
              color: AppColors.description,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String description,
        required VoidCallback onPressed,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.mainButtonBackground.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.mainButtonBackground,
                  AppColors.mainButtonBackground.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.mainButtonText,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.mainButtonText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mainButtonText.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.mainButtonText,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
