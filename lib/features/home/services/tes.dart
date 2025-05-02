//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weather Box Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final WeatherService _weatherService = WeatherService();
//   final LocationService _locationService = LocationService();
//
//   String _cityName = "Loading...";
//   List<WeatherData> _weatherForecast = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadWeatherData();
//   }
//
//   Future<void> _loadWeatherData() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       // Cek lokasi tersimpan atau dapatkan lokasi baru
//       final location = await _locationService.getCurrentLocation();
//
//       if (location != null) {
//         // Dapatkan data cuaca untuk 3 hari
//         final forecast = await _weatherService.getWeatherForecast(
//           location.latitude,
//           location.longitude,
//         );
//
//         // Dapatkan nama kota
//         final cityName = await _locationService.getCityName(
//           location.latitude,
//           location.longitude,
//         );
//
//         setState(() {
//           _weatherForecast = forecast;
//           _cityName = cityName;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _cityName = "Location unavailable";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _cityName = "Error loading weather";
//         _isLoading = false;
//       });
//       debugPrint('Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//       return Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 25,
//                   backgroundColor: Colors.grey,
//                   child: Icon(Icons.person, color: Colors.white),
//                 ),
//                 const SizedBox(width: 12),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'username',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'See public profile',
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // Location indicator
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.location_on_outlined, color: Colors.grey),
//                 const SizedBox(width: 4),
//                 Text(_cityName),
//                 const Spacer(),
//                 TextButton(
//                   onPressed: () {},
//                   child: Row(
//                     children: const [
//                       Text(
//                         'OOTD calendar',
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 14,
//                         color: Colors.blue,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Weather forecast
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Container(
//                 height: 100,
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: _weatherForecast.length,
//                   itemBuilder: (context, index) {
//                     final weather = _weatherForecast[index];
//                     return WeatherBox(weatherData: weather);
//                   },
//                 ),
//               ),
//
//           // Rest of the app UI
//           // ...
//         ],
//       ),
//     );
//   }
// }
