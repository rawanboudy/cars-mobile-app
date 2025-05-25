import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/custom_nav_bar.dart';
import '../theme/custom_app_bar.dart';

class AboutContactPage extends StatelessWidget {
  const AboutContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'About & Contact',
        showAvatar: false,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 3,
        onTap: (_) {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(themeColor),
            const SizedBox(height: 24),
            _buildSectionHeader('COMPANY PROFILE', themeColor),
            const SizedBox(height: 16),
            _buildAboutDescription(),
            const SizedBox(height: 32),
            _buildMissionVision(themeColor),
            const SizedBox(height: 32),
            _buildSectionHeader('MEET OUR TEAM', themeColor),
            const SizedBox(height: 16),
            _buildTeamMembers(themeColor),
            const SizedBox(height: 32),
            _buildSectionHeader('OUR VALUES', themeColor),
            const SizedBox(height: 16),
            _buildValuesList(themeColor),
            const SizedBox(height: 32),
            _buildSectionHeader('GET IN TOUCH', themeColor),
            const SizedBox(height: 16),
            _buildContactOptions(themeColor),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Color themeColor) {
    return Container(
      height: 250,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/showroom.jpeg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  themeColor.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'BOUDY CAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'DRIVING EXCELLENCE SINCE 2002',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: themeColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Boudy Car stands at the forefront of the automotive industry, delivering excellence in every aspect of our operations. Founded in 2002, we have grown from a modest dealership to a comprehensive automotive solution provider, serving customers across Egypt.',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
        SizedBox(height: 16),
        Text(
          'With a passion for automobiles and a commitment to exceptional service, we provide a wide range of services including new and pre-owned vehicle sales, maintenance and repair, genuine parts, and financing solutions. Our team of experienced professionals is dedicated to ensuring that every customer drives away with complete satisfaction.',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildMissionVision(Color themeColor) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 300, // or MediaQuery.of(context).size.width * 0.9
            child: _buildCard(
              icon: Icons.flag_rounded,
              title: 'Our Mission',
              description:
              'To provide exceptional automotive solutions that exceed customer expectations while maintaining the highest standards of quality and service.',
              themeColor: themeColor,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: _buildCard(
              icon: Icons.visibility_rounded,
              title: 'Our Vision',
              description:
              'To become the most trusted name in the automotive industry, recognized for innovation, excellence, and customer satisfaction.',
              themeColor: themeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String description,
    required Color themeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: themeColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMembers(Color themeColor) {
    final List<Map<String, String>> teamMembers = [
      {
        'name': 'Ahmed Mostafa',
        'role': 'CEO & Founder',
        'image': 'assets/images/team/ceo.jpg',
      },
      {
        'name': 'Alaa Zidan',
        'role': 'Branches Manager',
        'image': 'assets/images/team/sales.jpg',
      },
      {
        'name': 'Ayat Mohamed',
        'role': 'Sales Manager',
        'image': 'assets/images/team/service.jpg',
      },
    ];

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: teamMembers.length,
        itemBuilder: (ctx, i) {
          final m = teamMembers[i];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(
                    m['image']!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      height: 140,
                      color: themeColor.withOpacity(0.2),
                      child: Icon(Icons.person, size: 60, color: themeColor.withOpacity(0.5)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        m['name']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m['role']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: themeColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildValuesList(Color themeColor) {
    final values = [
      {'title': 'Excellence', 'description': 'We pursue excellence...', 'icon': Icons.star_rounded},
      {'title': 'Integrity', 'description': 'We operate with honesty...', 'icon': Icons.verified_user_rounded},
      {'title': 'Innovation', 'description': 'We embrace new technologies...', 'icon': Icons.lightbulb_rounded},
      {'title': 'Customer Focus', 'description': 'We prioritize our customers...', 'icon': Icons.people_alt_rounded},
    ];

    return Column(
      children: values.map((v) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(v['icon'] as IconData, color: themeColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v['title'] as String,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      v['description'] as String,
                      style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactOptions(Color themeColor) {
    final contacts = [
      {'icon': Icons.location_on_rounded, 'label': 'Address', 'text': '33 Street 306 New Maadi, Cairo, Egypt'},
      {'icon': Icons.phone_rounded, 'label': 'Phone', 'text': '+201277718184'},
      {'icon': Icons.access_time_rounded, 'label': 'Working Hours', 'text': 'All Days: 9AM - 11PM'},
    ];

    return Column(
      children: contacts.map((c) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(c['icon'] as IconData, color: themeColor, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c['label'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c['text'] as String,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
