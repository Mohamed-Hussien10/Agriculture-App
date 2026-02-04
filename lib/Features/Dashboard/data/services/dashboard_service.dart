import 'dart:async';
import 'package:signalr_core/signalr_core.dart';

class DashboardService {
  final String hubUrl = 'https://agricultur.runasp.net/liveDataHub';

  late HubConnection _connection;

  bool get isConnected => _connection.state == HubConnectionState.connected;

  // =========================
  // Init & Connection
  // =========================
  Future<void> initConnection() async {
    print('[Service] 🔗 Initializing Hub connection...');
    _connection =
        HubConnectionBuilder()
            .withUrl(
              hubUrl,
              HttpConnectionOptions(transport: HttpTransportType.webSockets),
            )
            .withAutomaticReconnect()
            .build();

    _connection.onclose(
      (error) => print('[Service][Hub] ❌ Connection closed: $error'),
    );
    _connection.onreconnecting(
      (error) => print('[Service][Hub] 🔄 Reconnecting: $error'),
    );
    _connection.onreconnected(
      (connectionId) =>
          print('[Service][Hub] ✅ Reconnected, ConnectionId: $connectionId'),
    );

    try {
      await _connection.start();
      print('[Service] ✅ Hub connected successfully');
    } catch (e) {
      print('[Service][Error] ❌ Failed to start Hub: $e');
      rethrow;
    }
  }

  Future<void> closeConnection() async {
    if (_connection.state == HubConnectionState.connected ||
        _connection.state == HubConnectionState.reconnecting) {
      print('[Service] 🔌 Stopping Hub connection...');
      await _connection.stop();
      print('[Service] ✅ Hub connection stopped');
    }
  }

  // =========================
  // Hub Methods
  // =========================
  Future<void> getSensorDataWithLive(String sensorId, int historyLimit) async {
    if (!isConnected)
      throw Exception('Cannot invoke GetSensorDataWithLive: Hub not connected');

    try {
      print(
        '[Service] 🎯 Invoking GetSensorDataWithLive for $sensorId with historyLimit=$historyLimit',
      );
      await _connection.invoke(
        'GetSensorDataWithLive',
        args: [sensorId, historyLimit],
      );
      print('[Service] 🌱 GetSensorDataWithLive request sent successfully');
    } catch (e) {
      print('[Service][Error] ❌ GetSensorDataWithLive failed: $e');
      rethrow;
    }
  }

  // =========================
  // Event Listeners
  // =========================
  void onLiveData(void Function(dynamic data) onData) {
    _connection.on('LiveData', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments.first;
        if (data is Map<String, dynamic>) {
          final mappedData = {
            'temperature': data['temperature'],
            'humidity': data['humidity'],
            'motion': data['motion'],
          };
          print('[Service][Hub] 🌱 LiveData mapped: $mappedData');
          onData(mappedData);
        }
      }
    });
  }

  void onHistoricalData(void Function(dynamic records) onData) {
    _connection.on('HistoricalData', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments.first;
        if (data is List) {
          final mappedRecords =
              data
                  .map(
                    (item) => {
                      'temperature': item['temperature'],
                      'humidity': item['humidity'],
                      'motion': item['motion'],
                    },
                  )
                  .toList();
          print('[Service][Hub] 📜 HistoricalData mapped: $mappedRecords');
          onData(mappedRecords);
        }
      }
    });
  }

  void onError(void Function(String error) onError) {
    _connection.on('Error', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        onError(arguments.first.toString());
      }
    });
  }
}
