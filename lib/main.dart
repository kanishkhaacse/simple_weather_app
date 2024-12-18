import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WeatherPage(),
    );
  }
}

// First Page: Welcome Screen
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1C1A44), // Dark Blue at the top
              Color(0xFF7E1B7F), // Purple at the bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  'assets/weathers.png', // Path to your image
                  width: 200,
                  height: 200,
                ),
              ),
              const Text(
                'Weather',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'ForeCasts',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFDCB59), // Yellow Color
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDCB59), // Yellow Button Color
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Get Start',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1A44), // Dark Blue text
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Second Page: Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _city = '';
  bool _isLoading = false;
  Map<String, dynamic>? _weatherData;

  // Fetch weather data
  Future<void> _fetchWeather() async {
    const String apiKey = '443c1a77cb1b8c0ae11dc214485fb9dc';
    final String url = 'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey&units=metric';

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _weatherData = null;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _weatherData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1C1A44), // Dark Blue at the top
              Color(0xFF7E1B7F), // Purple at the bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/weathers.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 320,
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF472C72),
                    hintText: 'Search city, state, country...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 180,
                child: GestureDetector(
                  onTap: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _city = _controller.text;
                      });
                      _fetchWeather();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDCB59),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'FIND',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1A44),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFFFDCB59))
                  : _weatherData != null
                      ? Column(
                          children: [
                            Text(
                              'Weather in $_city',
                              style: const TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '${_weatherData!['main']['temp']}°C',
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${_weatherData!['weather'][0]['description']}',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        )
                      : const Text(
                          'No weather data available',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
