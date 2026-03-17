import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NetworkStatus { online, offline }

final connectivityProvider = StreamProvider<NetworkStatus>((ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      return NetworkStatus.offline;
    }
    return NetworkStatus.online;
  });
});
