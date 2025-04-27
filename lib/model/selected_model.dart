import 'package:flutter/material.dart';

class SelectedModel with ChangeNotifier {
  String? shirt;
  String? pants;
  String? shoes;
  String? dress;

  void selectShirt(String? value) {
    shirt = value;
    if (value != null) dress = null; // reset dress jika pilih shirt
    notifyListeners();
  }

  void selectPants(String? value) {
    pants = value;
    notifyListeners();
  }

  void selectShoes(String? value) {
    shoes = value;
    notifyListeners();
  }

  void selectDress(String? value) {
    dress = value;
    if (value != null) shirt = null; // reset shirt jika pilih dress
    notifyListeners();
  }

  void reset() {
    shirt = null;
    pants = null;
    shoes = null;
    dress = null;
    notifyListeners();
  }

  void deleteShoes() {
    shoes = null;
    notifyListeners();
  }

  void deletePants() {
    pants = null;
    shoes = null;
    notifyListeners();
  }

  void deleteShirt() {
    shirt = null;
    notifyListeners();
  }

  void deleteDress() {
    dress = null;
    notifyListeners();
  }

  String? validateTopSelection({required String target}) {
    if (target == 'shirt' && dress != null) {
      return 'Anda sudah menggunakan dress sebagai atasan.';
    }
    if (target == 'dress' && shirt != null) {
      return 'Anda sudah menggunakan shirt sebagai atasan.';
    }
    return null;
  }
}
