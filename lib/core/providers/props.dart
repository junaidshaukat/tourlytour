class Props {
  int state;
  String? error;
  Object? data;
  Object? initialData;

  Props({this.state = 0, this.error, this.data, this.initialData});

  String get trace {
    final stackTrace = StackTrace.current;
    final frames = stackTrace.toString().split('\n');

    if (frames.length > 1) {
      final callerFrame = frames[1].trim();
      final regex = RegExp(r'#\d+\s+(\S+)\.(\S+)\s+\(.*\)');
      final match = regex.firstMatch(callerFrame);

      if (match != null) {
        final className = match.group(1);
        final methodName = match.group(2);
        return "$className::$methodName";
      } else {
        return "$runtimeType::unknown";
      }
    } else {
      return "$runtimeType::unknown";
    }
  }

  bool get isNone => state == 0 ? true : false;
  void setNone({
    int currentState = 0,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isLoading => state == 1 ? true : false;
  void setLoading({
    int currentState = 1,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isSuccess => state == 2 ? true : false;
  void setSuccess({
    int currentState = 2,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isError => state == 3 ? true : false;
  void setError({
    int currentState = 3,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError ?? "something_went_wrong";
    data = currentData ?? initialData;
  }

  bool get isProcessing => state == 4 ? true : false;
  void setProcessing({
    int currentState = 4,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isResending => state == 5 ? true : false;
  void setResending({
    int currentState = 5,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isSending => state == 6 ? true : false;
  void setSending({
    int currentState = 6,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isUploading => state == 7 ? true : false;
  void setUploading({
    int currentState = 7,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isUnauthorized => state == 8 ? true : false;
  void setUnauthorized({
    int currentState = 8,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isInitialSession => state == 9 ? true : false;
  void setInitialSession({
    int currentState = 9,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isSignedIn => state == 10 ? true : false;
  void setSignedIn({
    int currentState = 10,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  bool get isSignedOut => state == 11 ? true : false;
  void setSignedOut({
    int currentState = 11,
    String? currentError,
    Object? currentData,
  }) {
    state = currentState;
    error = currentError;
    data = currentData ?? initialData;
  }

  void clear(Object? object) {
    state = -1;
    error = null;
    data = object;
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'error': error,
      'data': data,
      'initialData': initialData,
    };
  }
}
