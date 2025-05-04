import 'package:flutter/material.dart';
import 'package:modisch/core/constants/colors.dart';
import 'package:modisch/core/constants/spacing.dart';
import 'package:modisch/features/home/services/weather_service.dart';

class WeatherBox extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherBox({required this.weatherData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.weatherBox,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  weatherData.isToday ? 'Today' : weatherData.dayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  weatherData.date,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            verticalSpace(16),
            Row(
              children: [
                Text(
                  '${weatherData.highTemp}° / ${weatherData.lowTemp}°F',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                horizontalSpace(24),
                _getWeatherIcon(weatherData.condition),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String condition) {
    IconData iconData;

    switch (condition.toLowerCase()) {
      case 'clear':
        iconData = Icons.wb_sunny;
        break;
      case 'clouds':
        iconData = Icons.cloud;
        break;
      case 'rain':
        iconData = Icons.beach_access;
        break;
      case 'thunderstorm':
        iconData = Icons.flash_on;
        break;
      default:
        iconData = Icons.cloud;
    }

    return Icon(iconData, size: 24, color: AppColors.secondary);
  }
}
