import 'package:agriculture_app/Features/Dashboard/data/models/today_weather.dart';
import 'package:agriculture_app/core/utils/weather_utils.dart';
import 'package:flutter/material.dart';
import 'today_weather_card_info_card.dart';

class TodayWeatherCardContent extends StatelessWidget {
  final TodayWeather weather;

  const TodayWeatherCardContent({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF66BB6A),
            const Color(0xFF2E7D32).withOpacity(0.9),
            const Color(0xFF1B5E20),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade900.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header with Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طقس اليوم',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    WeatherUtils.getTodayDate(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.sunny,
                  color: Colors.yellowAccent.shade100,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Main Weather Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Temperature Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${weather.temp.round()}',
                        style: const TextStyle(
                          fontSize: 56,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 0.9,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          '°م',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Text(
                      WeatherUtils.toEgyptian(weather.description),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              /// Weather Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Image.network(
                      'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                      width: 70,
                      height: 70,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          /// Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Additional Info Cards
          Row(
            children: [
              /// الرطوبة
              Expanded(
                child: TodayWeatherCardInfoCard(
                  icon: Icons.water_drop,
                  iconColor: Colors.lightBlue.shade100,
                  title: 'الرطوبة',
                  value: '${weather.humidity}%',
                  subtitle:
                      weather.humidity < 30
                          ? 'جاف'
                          : (weather.humidity <= 60 ? 'مثالي للزراعة' : 'رطب'),
                ),
              ),
              const SizedBox(width: 10),

              /// الموقع
              Expanded(
                child: TodayWeatherCardInfoCard(
                  icon: Icons.location_on,
                  iconColor: Colors.orange.shade100,
                  title: 'الموقع',
                  value: weather.city,
                  subtitle: 'مصر',
                ),
              ),
              const SizedBox(width: 10),

              /// الرياح
              Expanded(
                child: TodayWeatherCardInfoCard(
                  icon: Icons.air,
                  iconColor: Colors.grey.shade100,
                  title: 'الرياح',
                  value: '${weather.windSpeed} كم/س',
                  subtitle:
                      weather.windSpeed < 5
                          ? 'هادئة'
                          : (weather.windSpeed <= 15 ? 'معتدلة' : 'قوية'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
