import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  // Adjusted subscription type to match the mapped stream.
  StreamSubscription<ConnectivityResult>? _subscription;

  /// Initializes the connectivity listener.
  void initialize(Function onOnline) {
    _subscription = _connectivity.onConnectivityChanged
        .map((results) =>
            results.isNotEmpty
                ? results.first
                : ConnectivityResult.none)
        .listen((result) {
      if (result != ConnectivityResult.none) {
        onOnline();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}