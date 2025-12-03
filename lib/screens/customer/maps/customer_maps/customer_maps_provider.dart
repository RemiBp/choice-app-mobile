import 'package:flutter/cupertino.dart';

class CustomerMapsProvider with ChangeNotifier {
  BuildContext? context;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
}