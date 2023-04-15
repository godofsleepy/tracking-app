import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';

class TrackingService {
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();
  @pragma('vm:entry-point')
  static void callback(LocationDto locationDto) async {
    final SendPort? send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
    print(locationDto.toJson().toString());
  }

//Optional
  @pragma('vm:entry-point')
  static void initCallback(dynamic _) {
    print('Plugin initialization');
  }

  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {
    // LocationServiceRepository myLocationCallbackRepository =
    //     LocationServiceRepository();
    // await myLocationCallbackRepository.dispose();
  }

//Optional
  @pragma('vm:entry-point')
  static void notificationCallback() {
    print('User clicked on the notification');
  }

  static void startLocationService() {
    BackgroundLocator.registerLocationUpdate(callback,
        initCallback: initCallback,
        disposeCallback: disposeCallback,
        autoStop: false,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        androidSettings: AndroidSettings(
          accuracy: LocationAccuracy.NAVIGATION,
          interval: 5,
          distanceFilter: 0,
        ));
  }
}
