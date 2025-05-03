import 'package:flutter/material.dart';
import 'package:modisch/features/home/services/location_service.dart';
import 'package:modisch/features/home/services/weather_service.dart';
import 'package:modisch/core/constants/spacing.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/typography.dart';
import 'package:modisch/features/home/widgets/weather_box.dart';

class WeatherLocationHeader extends StatefulWidget {
  const WeatherLocationHeader({super.key});

  @override
  State<WeatherLocationHeader> createState() => _WeatherLocationHeaderState();
}

class _WeatherLocationHeaderState extends State<WeatherLocationHeader> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  String _cityName = "Loading...";
  List<WeatherData> _weatherForecast = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      final location = await _locationService.getCurrentLocation();

      if (location != null) {
        final forecast = await _weatherService.getWeatherForecast(
          location.latitude,
          location.longitude,
        );
        final cityName = await _locationService.getCityName(
          location.latitude,
          location.longitude,
        );

        setState(() {
          _cityName = cityName;
          _weatherForecast = forecast;
          _isLoading = false;
        });
      } else {
        setState(() {
          _cityName = "Location unavailable";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _cityName = "Error loading weather";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lokasi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.tertiary),
              Text(
                _cityName,
                style: AppTypography.buttonLabel(
                  context,
                ).copyWith(color: AppColors.tertiary),
              ),
            ],
          ),
        ),
        verticalSpace(16),
        // Cuaca
        _isLoading
            ? const Center(
              child: CircularProgressIndicator(color: AppColors.tertiary),
            )
            : SizedBox(
              height: 88,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _weatherForecast.length,
                itemBuilder: (context, index) {
                  return WeatherBox(weatherData: _weatherForecast[index]);
                },
              ),
            ),
      ],
    );
  }
}
