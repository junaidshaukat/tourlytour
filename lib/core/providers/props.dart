import '/core/app_export.dart';

class Props {
  int state;
  String? error;
  Object? data;
  Object? initialData;

  Props({this.state = 0, this.error, this.data, this.initialData});

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
    console.log(currentError, 'setError');
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
