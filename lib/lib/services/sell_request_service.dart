import 'package:hive/hive.dart';
import '../models/sell_request.dart';

class SellRequestService {
  static final SellRequestService _instance = SellRequestService._internal();
  factory SellRequestService() => _instance;

  late final Box<SellRequest> _box;

  SellRequestService._internal() {
    _box = Hive.box<SellRequest>('sellRequests');
  }

  void addRequest(SellRequest request) {
    _box.add(request);
  }

  List<SellRequest> getRequests() {
    return _box.values.toList();
  }

  void removeRequest(int index) {
    final key = _box.keyAt(index);
    _box.delete(key);
  }

  void clear() {
    _box.clear();
  }
}
