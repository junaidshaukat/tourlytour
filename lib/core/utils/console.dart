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

  void _print(String message, String color) {
    final stackTrace = StackTrace.current;
    final frames = stackTrace.toString().split('\n');

    if (frames.length > 1) {
      // The first frame is the current method (_logError), the second is the caller
      final callerFrame = frames[1].trim();

      // Regex to extract the class and method names from the stack trace line
      final regex = RegExp(r'#\d+\s+(\S+)\.(\S+)\s+\(.*\)');
      final match = regex.firstMatch(callerFrame);

      if (match != null) {
        final className = match.group(1);
        final methodName = match.group(2);
        developer.log(
          message,
          name: _applyColor("$className::$methodName", color),
        );
      } else {
        developer.log(message, name: _applyColor("unknown", color));
      }
    } else {
      developer.log(message, name: _applyColor("insufficient", color));
    }
  }

  void log(Object message, [String name = '', String color = 'white']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  void internet(Object message, [String name = '', String color = 'magenta']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  void intent(Object message, [String name = '', String color = 'magenta']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  void stripe(Object message, [String name = '', String color = 'red']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  void authentication(Object message,
      [String name = '', String color = 'cyan']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  void custom(Object message, [String name = '', String color = 'blue']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  void error(Object message, [String name = '', String color = 'red']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  void debug(Object message, [String name = '', String color = 'cyan']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  void info(Object message, [String name = '', String color = 'green']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  void warn(Object message, [String name = '', String color = 'yellow']) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), color);
    }
  }

  String _applyColor(Object message, String color) {
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
