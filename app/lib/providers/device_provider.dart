import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_notifier.dart';
import 'device_state.dart';

final deviceProvider = NotifierProvider<DeviceNotifier, DeviceState>(
  DeviceNotifier.new,
);
