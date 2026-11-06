import 'dart:async';

import 'package:flutter/foundation.dart';

/// Amână execuția unei acțiuni până când utilizatorul nu mai tastează
/// o perioadă ([duration]). Folosit la căutare, ca să nu filtrăm la fiecare literă.
class Debouncer {
  Debouncer(this.duration);

  final Duration duration;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void cancel() => _timer?.cancel();

  void dispose() => cancel();
}
