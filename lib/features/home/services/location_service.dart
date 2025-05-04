import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  SharedPreferencesWithCache? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{'cached_city_names'},
      ),
    );
  }

  Future<Position?> getCurrentLocation() async {
    final permission = await Permission.location.request();

    if (permission.isGranted) {
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
      } catch (e) {
        debugPrint('Error getting location: $e');
        return null;
      }
    } else {
      debugPrint('Location permission denied');
      return null;
    }
  }

  Future<String> getCityName(double latitude, double longitude) async {
    await init();

    final key =
        '${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}';
    final cacheData = _prefs?.getString('cached_city_names');

    Map<String, dynamic> cacheMap =
        cacheData != null ? json.decode(cacheData) : {};

    if (cacheMap.containsKey(key)) {
      debugPrint('City name loaded from cache');
      return cacheMap[key];
    }

    try {
      final apiKey = dotenv.env['WEATHER_API_KEY'];
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/geo/1.0/reverse?lat=$latitude&lon=$longitude&limit=1&appid=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final cityName = data[0]['name'];
          cacheMap[key] = cityName;
          _prefs?.setString('cached_city_names', json.encode(cacheMap));
          return cityName;
        }
      }
      return 'Unknown Location';
    } catch (e) {
      debugPrint('Error getting city name: $e');
      return 'Unknown Location';
    }
  }
}
