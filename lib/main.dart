import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart'; // For LatLng
import 'package:thesusitain/splashscreen.dart';
import 'package:url_launcher/url_launcher.dart'; // For launchUrl
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUSTAIN',
      theme: ThemeData(
        primaryColor: Colors.blue[900], // Dark blue theme color
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MapController mapController;
  LatLng? currentLocation;
  List<Marker> markers = [];
  String _response = '';
  TextEditingController queryController = TextEditingController();
  final TextEditingController messageController = TextEditingController(); // For chatbot input

  List<Map<String, dynamic>> chatMessages = []; // List to store chat messages

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      mapController.move(currentLocation!, 15.0); // Zoom level 15
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Full screen chat dialog function
  void _showFullScreenChat() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Llama2 Chatbot'),
            backgroundColor: Colors.blue[900],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    final chat = chatMessages[index];
                    final isUser = chat['sender'] == 'user';

                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          chat['message'],
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        String message = messageController.text;
                        if (message.isNotEmpty) {
                          _callLlama2API(message);
                          messageController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to show a dialog box with a list of crops
  void _showCropsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Crop'),
          content: SizedBox(
            height: 200, // Set a specific height for the content
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Wheat'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Rice'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Corn'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Cotton'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                // Add more crops as needed
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SUSTAIN", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          onTap: (tapPosition, point) {
            setState(() {
              markers.clear();
              markers.add(Marker(
                width: 80.0,
                height: 80.0,
                point: point,
                builder: (ctx) =>
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ));
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
            'https://api.mapbox.com/styles/v1/devarsh-13/cm1x3nntq018s01pe3he6dsxt/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGV2YXJzaC0xMyIsImEiOiJjbTF1b296ZHQwMjN4MmlzNzZzODM5cW81In0.ajTKxmZkem8lYnVbKWwOlQ',
            userAgentPackageName: 'com.example.app',
            additionalOptions: {
              'accessToken':
              'pk.eyJ1IjoiZGV2YXJzaC0xMyIsImEiOiJjbTF1b296ZHQwMjN4MmlzNzZzODM5cW81In0.ajTKxmZkem8lYnVbKWwOlQ',
            },
          ),
          MarkerLayer(
            markers: markers,
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                onPressed: _getCurrentLocation,
                label: const Text("My Location",
                    style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.my_location),
                backgroundColor: Colors.blue[900],
              ),
              const SizedBox(width: 10),
              FloatingActionButton.extended(
                onPressed: _showCropsDialog, // Show crops dialog when clicked
                label: const Text(
                    "Crops", style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.agriculture),
                backgroundColor: Colors.blue[900],
              ),
            ],
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _showFullScreenChat,
            label: const Text("Llama2 Assistant",
                style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.chat),
            backgroundColor: Colors.blue[900],
          ),
        ],
      ),
    );
  }

  // Function to call Llama2 API (dummy for now)
  Future<void> _callLlama2API(String message) async {
    // Add user's message to the chat history
    setState(() {
      chatMessages.add({'sender': 'user', 'message': message});
    });

    // Simulate a delay as if waiting for the Llama2 API response
    await Future.delayed(const Duration(seconds: 2));

    // Dummy response from the Llama2 API
    String botResponse = "This is a dummy response from Llama2 API.";

    // Add the bot's response to the chat history
    setState(() {
      chatMessages.add({'sender': 'bot', 'message': botResponse});
    });
  }
}
