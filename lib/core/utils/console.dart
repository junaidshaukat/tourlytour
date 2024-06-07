import 'dart:developer' as developer;

enum LogMode { debug, live }

class Console {
  final LogMode _logMode;
  Console(this._logMode);

  void log(dynamic message, [String name = '']) {
    if (_logMode == LogMode.debug) {
      developer.log("$message", name: name);
    }
  }
}

Console console = Console(LogMode.debug);
