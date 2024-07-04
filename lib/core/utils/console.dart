import 'dart:developer' as developer;

enum LogMode { debug, live }

class Console {
  final LogMode _logMode;

  Console(this._logMode);

  // ANSI color codes
  final String _reset = '\x1B[0m';
  final String _red = '\x1B[31m';
  final String _green = '\x1B[32m';
  final String _yellow = '\x1B[33m';
  final String _blue = '\x1B[34m';
  final String _magenta = '\x1B[35m';
  final String _cyan = '\x1B[36m';
  final String _white = '\x1B[37m';

  void _print(String message, String name, String color) {
    developer.log(message, name: _applyColor(name, color));
  }

  void log(dynamic message, [String name = '', String color = 'green']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  void internet(dynamic message, [String name = '', String color = 'magenta']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  void intent(dynamic message, [String name = '', String color = 'cyan']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  void stripe(dynamic message, [String name = '', String color = 'red']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  void authentication(dynamic message,
      [String name = '', String color = 'red']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  void custom(dynamic message, [String name = '', String color = 'blue']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  void error(dynamic message, [String name = '', String color = 'red']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  void debug(dynamic message, [String name = '', String color = 'cyan']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  void info(dynamic message, [String name = '', String color = 'green']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  void warn(dynamic message, [String name = '', String color = 'yellow']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color);
    }
  }

  String _applyColor(dynamic message, String color) {
    switch (color) {
      case 'red':
        return '$_red$message$_reset';
      case 'green':
        return '$_green$message$_reset';
      case 'yellow':
        return '$_yellow$message$_reset';
      case 'blue':
        return '$_blue$message$_reset';
      case 'magenta':
        return '$_magenta$message$_reset';
      case 'cyan':
        return '$_cyan$message$_reset';
      case 'white':
      default:
        return '$_white$message$_reset';
    }
  }
}

Console console = Console(LogMode.debug);
