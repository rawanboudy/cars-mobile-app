import 'package:flutter/material.dart';
import '../models/sell_request.dart';
import '../services/sell_request_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String _selectedView = 'Dashboard';
  final List<Car> _cars = [];

  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carBrandController = TextEditingController();
  final TextEditingController _carPriceController = TextEditingController();

  void _addCar() {
    final name = _carNameController.text.trim();
    final brand = _carBrandController.text.trim();
    final price = double.tryParse(_carPriceController.text.trim());
    if (name.isNotEmpty && brand.isNotEmpty && price != null) {
      setState(() {
        _cars.add(Car(name: name, brand: brand, price: price));
        _carNameController.clear();
        _carBrandController.clear();
        _carPriceController.clear();
      });
    }
  }

  void _removeCar(int index) {
    setState(() => _cars.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      drawer: _AppDrawer(
        onItemSelected: (view) {
          setState(() => _selectedView = view);
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildSelectedView(),
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedView) {
      case 'Manage Cars':
        return _buildManageCars();
      case 'Dashboard':
        return const _KpiGrid();
      default:
        return const Center(
          child: Text('Welcome to the Admin Dashboard', style: TextStyle(color: Colors.white70)),
        );
    }
  }

  Widget _buildManageCars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Add New Car', style: TextStyle(fontSize: 18, color: Colors.white)),
        const SizedBox(height: 10),
        TextField(
          controller: _carNameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Car Name', labelStyle: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _carBrandController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Brand', labelStyle: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _carPriceController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Price', labelStyle: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _addCar,
          icon: const Icon(Icons.add),
          label: const Text('Add Car'),
        ),
        const SizedBox(height: 20),
        const Text('Cars List', style: TextStyle(fontSize: 18, color: Colors.white)),
        Expanded(
          child: _cars.isEmpty
              ? const Center(child: Text('No cars added yet.', style: TextStyle(color: Colors.white70)))
              : ListView.builder(
            itemCount: _cars.length,
            itemBuilder: (context, index) {
              final car = _cars[index];
              return Card(
                child: ListTile(
                  title: Text(car.name),
                  subtitle: Text('Brand: ${car.brand} | Price: \$${car.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeCar(index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Car {
  final String name;
  final String brand;
  final double price;

  Car({required this.name, required this.brand, required this.price});
}

class _AppDrawer extends StatelessWidget {
  final ValueChanged<String> onItemSelected;

  const _AppDrawer({required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF003366)),
            child: Text('Body cars', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
            onTap: () => onItemSelected('Dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment, color: Colors.white),
            title: const Text('Sell Requests', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sellRequests');
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.white),
            title: const Text('Manage Cars', style: TextStyle(color: Colors.white)),
            onTap: () => onItemSelected('Manage Cars'),
          ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid();

  static const List<_KpiData> _data = [
    _KpiData('Cars in Stock', 42, Icons.car_rental, Colors.blue),
    _KpiData('Sold Today', 5, Icons.sell, Colors.green),
    _KpiData('Monthly Revenue', 12500, Icons.attach_money, Colors.purple),
    _KpiData('Low Inventory', 3, Icons.warning, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: _data.length,
      itemBuilder: (context, i) => _KpiCard(_data[i]),
    );
  }
}

class _KpiData {
  final String label;
  final num value;
  final IconData icon;
  final Color color;
  const _KpiData(this.label, this.value, this.icon, this.color);
}

class _KpiCard extends StatelessWidget {
  final _KpiData kpi;
  const _KpiCard(this.kpi);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C2C),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: kpi.color.withOpacity(.15),
              child: Icon(kpi.icon, color: kpi.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(kpi.label, style: const TextStyle(fontSize: 13, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(
                    kpi.value.toString(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
