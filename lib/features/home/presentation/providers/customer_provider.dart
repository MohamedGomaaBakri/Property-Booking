import 'package:flutter/foundation.dart';
import '../../data/datasource/home_datasource.dart';
import '../../data/models/customer_model.dart';

class CustomerProvider with ChangeNotifier {
  List<CustomerModel> _customers = [];
  bool _isLoading = false;
  String? _error;

  List<CustomerModel> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCustomers(HomeDatasource homeDatasource) async {
    if (_customers.isNotEmpty) return; // Only fetch if list is empty

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customers = await homeDatasource.getCustomers();
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }
}
