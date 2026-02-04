import 'package:agriculture_app/Features/Dashboard/data/models/today_weather.dart';
import 'package:agriculture_app/Features/Dashboard/data/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'today_weather_card_content.dart';
import 'today_weather_card_error.dart';
import 'today_weather_card_loading.dart';

class TodayWeatherCard extends StatelessWidget {
  const TodayWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TodayWeather>(
      future: WeatherService().fetchTodayWeather(lat: 28.0994, lon: 30.7541),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const TodayWeatherCardLoading();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const TodayWeatherCardError();
        }

        return TodayWeatherCardContent(weather: snapshot.data!);
      },
    );
  }
}
