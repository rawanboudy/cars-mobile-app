import '../theme/theme.dart';
import '../models/sell_request.dart';
import 'package:flutter/material.dart';
import '../services/sell_request_service.dart';

class SellRequestsPage extends StatefulWidget {
  const SellRequestsPage({super.key});

  @override
  State<SellRequestsPage> createState() => _SellRequestsPageState();
}

class _SellRequestsPageState extends State<SellRequestsPage> {
  late List<SellRequest> requests;

  @override
  void initState() {
    super.initState();
    requests = SellRequestService().getRequests();
  }

  void _approveRequest(int index) {
    setState(() {
      requests.removeAt(index);
    });
    SellRequestService().removeRequest(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request approved.')),
    );
  }

  void _rejectRequest(int index) {
    setState(() {
      requests.removeAt(index);
    });
    SellRequestService().removeRequest(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request rejected.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Sell Car Requests',
          style: TextStyle(color: AppColors.text),
        ),
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: requests.isEmpty
          ? const Center(
        child: Text(
          'No requests yet.',
          style: TextStyle(color: AppColors.description),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final r = requests[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_car, color: AppColors.mainButtonBackground),
                      const SizedBox(width: 10),
                      Text(
                        '${r.brand} ${r.model}',
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Year: ${r.year}    Price: \$${r.price}',
                    style: const TextStyle(
                      color: AppColors.description,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Condition: ${r.condition} | ${r.fuelType}, ${r.transmission}',
                    style: const TextStyle(
                      color: AppColors.description,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    r.description,
                    style: const TextStyle(
                      color: AppColors.description,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => _approveRequest(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainButtonBackground,
                          foregroundColor: AppColors.mainButtonText,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Approve'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => _rejectRequest(index),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.favoriteRed,
                          side: const BorderSide(color: AppColors.favoriteRed),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
