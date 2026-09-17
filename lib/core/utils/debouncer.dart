import 'dart:async';

/// Simple reusable debouncer, used by the search feature so we don't
/// query the (future) backend on every keystroke.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
