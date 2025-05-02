import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Model untuk data cuaca
class WeatherData {
  final String dayName;
  final String date;
  final int highTemp;
  final int lowTemp;
  final String condition;
  final bool isToday;

  WeatherData({
    required this.dayName,
    required this.date,
    required this.highTemp,
    required this.lowTemp,
    required this.condition,
    required this.isToday,
  });
}

// Service untuk lokasi
// Service untuk cuaca
class WeatherService {
  Future<List<WeatherData>> getWeatherForecast(
    double latitude,
    double longitude,
  ) async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();

    final cachedJson = prefs.getString('weather_cache');
    final cachedDate = prefs.getString('weather_cache_date');

    // Cek apakah cache valid
    if (cachedJson != null && cachedDate != null) {
      final cachedDateTime = DateTime.parse(cachedDate);
      final isSameDay =
          now.year == cachedDateTime.year &&
          now.month == cachedDateTime.month &&
          now.day == cachedDateTime.day;

      if (isSameDay) {
        debugPrint("📦 Menggunakan data dari SharedPreferences");
        final decoded = json.decode(cachedJson) as List;
        return decoded
            .map(
              (e) => WeatherData(
                dayName: e['dayName'],
                date: e['date'],
                highTemp: e['highTemp'],
                lowTemp: e['lowTemp'],
                condition: e['condition'],
                isToday: e['isToday'],
              ),
            )
            .toList();
      }
    }
    try {
      final apiKey = dotenv.env['WEATHER_API_KEY'];
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=imperial&appid=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];

        // Kelompokkan berdasarkan hari
        final Map<String, List<dynamic>> dailyForecasts = {};

        for (var forecast in forecastList) {
          final dateTime =
              DateTime.fromMillisecondsSinceEpoch(
                forecast['dt'] * 1000,
                isUtc: true,
              ).toLocal();

          final dateString = DateFormat('yyyy-MM-dd').format(dateTime);

          if (!dailyForecasts.containsKey(dateString)) {
            dailyForecasts[dateString] = [];
          }

          dailyForecasts[dateString]!.add(forecast);
        }

        // Dapatkan data untuk 3 hari
        final List<WeatherData> weatherData = [];
        final now = DateTime.now();
        final today = DateFormat('yyyy-MM-dd').format(now);

        // Ambil 3 hari ke depan (termasuk hari ini)
        int count = 0;
        dailyForecasts.forEach((date, forecasts) {
          if (count < 3) {
            // Cari suhu tertinggi dan terendah dalam sehari
            int highTemp = -100;
            int lowTemp = 200;
            String mainCondition = '';

            for (var forecast in forecasts) {
              final temp = forecast['main']['temp'].toInt();
              if (temp > highTemp) {
                highTemp = temp;
              }
              if (temp < lowTemp) {
                lowTemp = temp;
              }

              // Ambil kondisi cuaca dari forecast siang hari (12:00)
              final time =
                  DateTime.fromMillisecondsSinceEpoch(
                    forecast['dt'] * 1000,
                    isUtc: true,
                  ).toLocal();

              if (time.hour >= 12 && time.hour <= 14) {
                mainCondition = forecast['weather'][0]['main'];
              }
            }

            // Jika tidak ada data siang, gunakan data pertama
            if (mainCondition.isEmpty && forecasts.isNotEmpty) {
              mainCondition = forecasts[0]['weather'][0]['main'];
            }

            // Format tanggal
            final parsedDate = DateTime.parse(date);
            final dayName = DateFormat(
              'E',
            ).format(parsedDate); // Singkatan hari (Mon, Tue, etc)
            final dateFormatted = DateFormat(
              'MMM d',
            ).format(parsedDate); // Format bulan dan tanggal

            weatherData.add(
              WeatherData(
                dayName: dayName,
                date: dateFormatted,
                highTemp: highTemp,
                lowTemp: lowTemp,
                condition: mainCondition,
                isToday: date == today,
              ),
            );

            count++;
          }
        });
        final jsonToCache =
            weatherData
                .map(
                  (w) => {
                    'dayName': w.dayName,
                    'date': w.date,
                    'highTemp': w.highTemp,
                    'lowTemp': w.lowTemp,
                    'condition': w.condition,
                    'isToday': w.isToday,
                  },
                )
                .toList();
        prefs.setString('weather_cache', json.encode(jsonToCache));
        prefs.setString('weather_cache_date', now.toIso8601String());
        return weatherData;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      debugPrint('Error fetching weather data: $e');
      return [];
    }
  }
}
