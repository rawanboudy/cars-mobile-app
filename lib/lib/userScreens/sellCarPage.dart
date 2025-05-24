import 'dart:io';
import '../theme/theme.dart';
import '../models/sell_request.dart';
import '../theme/custom_app_bar.dart';
import '../theme/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../services/sell_request_service.dart';
import 'package:image_picker/image_picker.dart';

class SellCarPage extends StatefulWidget {
  const SellCarPage({super.key});

  @override
  State<SellCarPage> createState() => _SellCarPageState();
}

class _SellCarPageState extends State<SellCarPage> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _priceController = TextEditingController();
  final _mileageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCondition = 'Excellent';
  String _selectedFuelType = 'Petrol';
  String _selectedTransmission = 'Automatic';
  final List<String> _conditions = ['Excellent', 'Good', 'Fair', 'Poor'];
  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];
  final List<String> _transmissions = ['Automatic', 'Manual'];

  final List<File> _imageFiles = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _mileageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> selectedImages = await picker.pickMultiImage(
      imageQuality: 80,
    );

    if (selectedImages.isNotEmpty) {
      setState(() {
        for (var image in selectedImages) {
          _imageFiles.add(File(image.path));
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one image of your car')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate a network delay
      await Future.delayed(const Duration(seconds: 2));

      // Create SellRequest object and save it
      final newRequest = SellRequest(
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: _yearController.text.trim(),
        condition: _selectedCondition,
        fuelType: _selectedFuelType,
        transmission: _selectedTransmission,
        price: _priceController.text.trim(),
        mileage: _mileageController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      SellRequestService().addRequest(newRequest);

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Success',
            style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Your car listing has been submitted for review. Our admin team will contact you shortly.',
            style: TextStyle(color: AppColors.description),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back
              },
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.mainButtonBackground),
              ),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        showAvatar: true,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // Navigation is handled in CustomNavBar
        },
      ),
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingIndicator()
            : Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildSectionTitle('Sell Your Car'),
              const SizedBox(height: 24),
              _buildImageSection(),
              const SizedBox(height: 32),
              _buildCarDetailsSection(),
              const SizedBox(height: 32),
              _buildPricingSection(),
              const SizedBox(height: 32),
              _buildAdditionalInfoSection(),
              const SizedBox(height: 40),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainButtonBackground),
          ),
          const SizedBox(height: 16),
          const Text(
            'Submitting your listing...',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.mainButtonBackground.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sell_outlined,
              color: AppColors.mainButtonBackground,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Fill in the details below to list your car for sale',
                  style: TextStyle(
                    color: AppColors.description,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Photos',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload clear images of your car (up to 6)',
          style: TextStyle(
            color: AppColors.description,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              if (_imageFiles.length < 6)
                _buildAddImageButton(),
              ..._imageFiles.asMap().entries.map((entry) => _buildImagePreview(entry.key, entry.value)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.mainButtonBackground.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: AppColors.mainButtonBackground,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photos',
              style: TextStyle(
                color: AppColors.mainButtonBackground,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(int index, File image) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.cardBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: AppColors.favoriteRed,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Car Details',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: _brandController,
          label: 'Brand',
          hint: 'e.g. Toyota',
          prefixIcon: Icons.branding_watermark,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: _modelController,
          label: 'Model',
          hint: 'e.g. Camry',
          prefixIcon: Icons.directions_car,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: _yearController,
          label: 'Year',
          hint: 'e.g. 2020',
          prefixIcon: Icons.calendar_today,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Condition',
          value: _selectedCondition,
          items: _conditions,
          icon: Icons.auto_fix_high,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCondition = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pricing & Specifications',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: _priceController,
          label: 'Price (\$)',
          hint: 'e.g. 25000',
          prefixIcon: Icons.attach_money,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: _mileageController,
          label: 'Mileage (km)',
          hint: 'e.g. 45000',
          prefixIcon: Icons.speed,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'Fuel Type',
                value: _selectedFuelType,
                items: _fuelTypes,
                icon: Icons.local_gas_station,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFuelType = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                label: 'Transmission',
                value: _selectedTransmission,
                items: _transmissions,
                icon: Icons.settings,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedTransmission = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Information',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            style: const TextStyle(color: AppColors.text),
            decoration: InputDecoration(
              hintText: 'Describe your car\'s features, condition, history, etc.',
              hintStyle: TextStyle(color: AppColors.description.withOpacity(0.6)),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, bottom: 60),
                child: Icon(
                  Icons.description_outlined,
                  color: AppColors.description,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please provide a description';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppColors.text),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.description.withOpacity(0.6)),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: InputBorder.none,
              prefixIcon: Icon(
                prefixIcon,
                color: AppColors.description,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.description,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: InputBorder.none,
              prefixIcon: Icon(
                icon,
                color: AppColors.description,
              ),
            ),
            dropdownColor: AppColors.cardBackground,
            style: const TextStyle(color: AppColors.text),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.mainButtonBackground,
        foregroundColor: AppColors.mainButtonText,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.send_rounded, size: 20),
          SizedBox(width: 10),
          Text(
            'Submit for Review',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}