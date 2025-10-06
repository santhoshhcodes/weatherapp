import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final TextEditingController cityController = TextEditingController();
  Map<String, dynamic>? weatherData;
  bool loading = false;

  Future<void> fetchWeather() async {
    final city = cityController.text.trim();
    if (city.isEmpty) return;

    setState(() => loading = true);

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=94d0003c9da942cd5cb1d42ce5e075d3&units=metric");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          weatherData = data;
          loading = false;
        });
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("City not found")),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching weather")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB6C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF69B4),
        elevation: 0,
        title: const Text(
          "Weather",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- Card Section ---
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  const Text(
                    "Check the Weather",
                    style: TextStyle(
                      color: Color(0xFFB00050),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset("assets/weather.png", height: 180),
                  const SizedBox(height: 20),
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: "City Name",
                      prefixIcon: const Icon(Icons.location_city),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: loading ? null : fetchWeather,
                    icon: const Icon(Icons.search),
                    label: const Text("Get Weather"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Weather Data Display ---
            if (weatherData != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB6C1), Color(0xFFFFC0CB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT SIDE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${weatherData!['name']}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4B0082),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.cloud, color: Colors.white, size: 22),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "Weather: ${weatherData!['weather'][0]['main']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF8B0000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Condition: ${weatherData!['weather'][0]['description']}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF8B0000),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // RIGHT SIDE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Weather Data",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFB00050),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "🌡 Temperature: ${weatherData!['main']['temp']} °C",
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          Text(
                            "⬇ Min: ${weatherData!['main']['temp_min']} °C",
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          Text(
                            "⬆ Max: ${weatherData!['main']['temp_max']} °C",
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          Text(
                            "💧 Humidity: ${weatherData!['main']['humidity']} %",
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )

            ],
          ],
        ),
      ),
    );
  }
}
