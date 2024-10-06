import 'dart:ui';
import 'package:flutter/material.dart';

class CropInfoScreen extends StatelessWidget {
  const CropInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Info & Irrigation Tips'),
        backgroundColor: const Color.fromARGB(255, 51, 92, 63),
      ),
      backgroundColor: const Color.fromARGB(255, 118, 167, 120),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Add SingleChildScrollView to make the content scrollable
          child: Column(
            children: [
              // Glass card for Crop Irrigation Tips
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crop Irrigation Tips',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '- Water crops early in the morning or late in the evening to reduce evaporation.\n'
                          '- Use drip irrigation to save water.\n'
                          '- Monitor soil moisture regularly to avoid overwatering.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Glass card for Crop Recommendation
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crop Recommendation',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Based on your region and soil type, the recommended crops for this season are:\n'
                          '- Wheat\n'
                          '- Corn\n'
                          '- Millet',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Glass card for Soil Moisture Level
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Soil Moisture Level',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Moisture: 70%',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(
                          Icons.water_drop,
                          color: Colors.blueAccent,
                          size: 30,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Moisture is optimal for most crops.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// GlassCard Widget for the glassmorphism effect
class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}