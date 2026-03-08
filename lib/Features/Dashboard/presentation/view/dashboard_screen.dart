import 'dart:io';
import 'package:agriculture_app/Features/Auth/presentation/manager/auth_cubit.dart';
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

    /// Start fetching sensor data
    dashboardCubit.startFetchingData();
  }

  @override
  void dispose() {
    dashboardCubit.stopFetchingData();
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
            'soil': '--',
          };

          if (state is DashboardLiveUpdated || state is DashboardConnected) {
            final data = (state as dynamic).liveData;
            if (data != null) liveData = Map<String, String>.from(data);
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

                    /// HEADER
                    Stack(
                      children: [
                        Center(
                          child: Column(
                            children: const [
                              SizedBox(height: 8),
                              Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'FarmEye',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('تسجيل الخروج'),
                                      content: const Text(
                                        'هل تريد تسجيل الخروج؟',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('إلغاء'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            context.read<AuthCubit>().logout();
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/loginScreen',
                                            );
                                          },
                                          child: const Text('تأكيد'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// LIVE SENSOR DATA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularSensor(
                          value: liveData['temperature'] ?? '--',
                          label: 'درجة الحرارة',
                        ),
                        CircularSensor(
                          value: liveData['humidity'] ?? '--',
                          label: 'الرطوبة',
                        ),
                        CircularSensor(
                          value: liveData['soil'] ?? '--',
                          label: 'رطوبة التربة',
                        ),
                        CircularSensor(
                          value: liveData['motion'] ?? '--',
                          label: 'حركة',
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

                          /// AI MODEL
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
