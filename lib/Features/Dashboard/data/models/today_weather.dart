class TodayWeather {
  final double temp;
  final int humidity;
  final String description;
  final String icon;
  final String city;
  final String country;
  final double windSpeed;

  TodayWeather({
    required this.temp,
    required this.humidity,
    required this.description,
    required this.icon,
    required this.city,
    required this.country,
    required this.windSpeed,
  });

  factory TodayWeather.fromJson(Map<String, dynamic> json) {
    return TodayWeather(
      temp: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      city: json['name'] as String, // الاسم من API
      country: json['sys']['country'] as String, // الدولة من API
      windSpeed: (json['wind']['speed'] as num).toDouble(), // سرعة الرياح
    );
  }
}
