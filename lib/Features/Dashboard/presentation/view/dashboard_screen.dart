import 'dart:io';

import 'package:agriculture_app/Features/Dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/manager/model_cubit.dart';
import 'package:agriculture_app/Features/Dashboard/data/services/dashboard_service.dart';
import 'package:agriculture_app/Features/Dashboard/data/services/model_service.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/view/widgets/model_detection_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/circular_sensor.dart';
import 'widgets/today_weather_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardCubit dashboardCubit;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    dashboardCubit = DashboardCubit(DashboardService());

    dashboardCubit.connectHub().then((_) {
      dashboardCubit.getSensorWithLive('room-112');
      dashboardCubit.autoFallbackHistorical(
        'room-112',
        '2025-01-01',
        '2025-12-31',
        timeoutSeconds: 3,
      );
    });
  }

  @override
  void dispose() {
    dashboardCubit.disconnectHub();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Map<String, String> _liveDataFromHistorical(
    Map<String, dynamic>? historical,
  ) {
    return {
      'temperature': '${historical?['temperature'] ?? '--'}°C',
      'humidity': '${historical?['humidity'] ?? '--'}%',
      'motion':
          historical?['motion'] != null
              ? (historical!['motion'] ? 'نعم' : 'لا')
              : '--',
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: dashboardCubit),
        BlocProvider(create: (_) => ModelCubit(ModelService())),
      ],
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          Map<String, String> liveData = {
            'temperature': '--',
            'humidity': '--',
            'motion': '--',
          };

          if (state is DashboardLiveUpdated || state is DashboardConnected) {
            final data = (state as dynamic).liveData;
            if (data != null) liveData = Map<String, String>.from(data);
          } else if (state is DashboardHistoricalLoaded &&
              state.historicalData.isNotEmpty) {
            liveData = _liveDataFromHistorical(state.historicalData.first);
          }

          if (state is DashboardLoading) {
            return const Scaffold(
              backgroundColor: Color(0xFF0A3D38),
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }

          if (state is DashboardError) {
            return Scaffold(
              backgroundColor: const Color(0xFF0A3D38),
              body: Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFF0A3D38),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    /// HEADER + LIVE SENSORS
                    Column(
                      children: [
                        const Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'FarmEye',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularSensor(
                              value: liveData['temperature'] ?? '--',
                              label: 'درجة الحرارة',
                            ),
                            CircularSensor(
                              value: liveData['humidity'] ?? '--',
                              label: 'رطوبة التربة',
                            ),
                            CircularSensor(
                              value: liveData['motion'] ?? '--',
                              label: 'حركة',
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// WHITE CONTAINER
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const TodayWeatherCard(),
                          const SizedBox(height: 24),

                          /// AI MODEL SECTION
                          ModelDetectionSection(
                            image: selectedImage,
                            onPickImage: pickImage,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
