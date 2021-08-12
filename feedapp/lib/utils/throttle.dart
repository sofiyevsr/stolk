import 'dart:async';

class Throttler {
  final Duration _duration;
  Throttler({required Duration duration}) : _duration = duration;
  Timer? _timer;

  void run(void Function() callback) {
    if (_timer == null) {
      callback();
      _timer = Timer(_duration, () {});
    } else {
      if (!_timer!.isActive) {
        callback();
        _timer = Timer(_duration, () {});
      }
    }
  }
}
