import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleService {
  final Uuid serviceUuid = Uuid.parse('f3b5c2a1-9d4e-4f12-8a6b-3e2c7f1a9d0a');
  final Uuid commandCharUuid = Uuid.parse(
    'a1d9f8b7-6c4e-4e23-9b1c-2d3f4a5b6c7a',
  );
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  // Current connected device
  DiscoveredDevice? _connectedLightstick;
  StreamSubscription<ConnectionStateUpdate>? _connectionStream;

  /// Scans for a device advertising [serviceUuid] and optionally matching [name].
  /// Returns the first matching device or null if none found within [timeout].
  Future<DiscoveredDevice?> scanForLightstick({
    String? name,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    // Wait until BLE is ready
    final status = await _ble.statusStream.firstWhere(
      (s) => s == BleStatus.ready,
    );
    print('BLE ready: $status, starting scan...');

    DiscoveredDevice? foundDevice;
    late StreamSubscription<DiscoveredDevice> subscription;

    final completer = Completer<DiscoveredDevice?>();

    subscription = _ble
        .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
        .listen(
          (device) {
            print('Discovered device: ${device.name}, id: ${device.id}');
            if (name == null || device.name == name) {
              foundDevice = device;
              completer.complete(foundDevice);
              subscription.cancel();
            }
          },
          onError: (e) {
            print('Scan error: $e');
            if (!completer.isCompleted) completer.completeError(e);
          },
        );

    // Stop scanning after [timeout] if no device found
    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        completer.complete(null);
        subscription.cancel();
      }
    });

    return completer.future;
  }

  /// Connect to the given [lightstick] and set callbacks
  Future<void> connectLightstick(
    DiscoveredDevice lightstick, {
    Function()? onDisconnect,
    Function()? onConnect,
  }) async {
    _connectedLightstick = lightstick;

    _connectionStream = _ble
        .connectToDevice(
          id: lightstick.id,
          connectionTimeout: const Duration(seconds: 5),
        )
        .listen((state) {
          switch (state.connectionState) {
            case DeviceConnectionState.disconnected:
              print('Device disconnected');
              onDisconnect?.call();
              break;
            case DeviceConnectionState.connecting:
              print('Device connecting...');
              break;
            case DeviceConnectionState.connected:
              print('Device connected!');
              onConnect?.call();
              break;
            case DeviceConnectionState.disconnecting:
              print('Device disconnecting...');
              break;
          }
        });
  }

  Future<void> disconnect() async {
    await _connectionStream?.cancel();
    _connectedLightstick = null;
  }

  List<int> lightstickCommandsToIntList({
    required int command,
    int redPercent = 0,
    int greenPercent = 0,
    int bluePercent = 0,
    int brightnessPercent = 0,
    int msInterval = 100,
  }) {
    command = command.clamp(0, 255);
    redPercent = redPercent.clamp(0, 255);
    greenPercent = greenPercent.clamp(0, 255);
    bluePercent = bluePercent.clamp(0, 255);
    brightnessPercent = brightnessPercent.clamp(0, 100);
    msInterval = msInterval.clamp(0, 255);

    return [
      command,
      redPercent,
      greenPercent,
      bluePercent,
      brightnessPercent,
      msInterval,
    ];
  }

  Future<void> sendLightstickCommand({
    required List<int> value,
    bool withResponse = true,
  }) async {
    if (_connectedLightstick == null) {
      throw Exception('No device connected');
    }

    final characteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: commandCharUuid,
      deviceId: _connectedLightstick!.id,
    );

    if (withResponse) {
      await _ble.writeCharacteristicWithResponse(characteristic, value: value);
    } else {
      await _ble.writeCharacteristicWithoutResponse(
        characteristic,
        value: value,
      );
    }
  }
}
