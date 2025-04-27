import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/wardrobe_item.dart';

class WardrobeService {
  static Future<List<WardrobeItem>> loadWardrobeItems() async {
    final String response = await rootBundle.loadString('assets/data/wardrobe.json');
    final Map<String, dynamic> data = json.decode(response); // Directly decode to Map
    return (data['WardrobeItems'] as List)
        .map((item) => WardrobeItem.fromJson(item))
        .toList();
  }
}
