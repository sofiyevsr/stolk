import 'dart:async';

class Debounce {
  Timer? _timer;
  Duration _duration;

  Debounce({required Duration duration}) : _duration = duration;

  void run(void Function() callback) {
    if (_timer != null && _timer!.isActive) _timer!.cancel();
    _timer = Timer(_duration, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}
