import 'dart:math';
import 'dart:typed_data';

class Functions {
  String orderNumber() {
    String alphabets = String.fromCharCodes(
      List.generate(2, (index) => Random().nextInt(26) + 65),
    ).toUpperCase();

    // Generate random numbers
    String numbers = '';
    for (int i = 0; i < 5; i++) {
      numbers += Random().nextInt(10).toString(); // Random numbers 0-9
    }

    // Concatenate alphabets and numbers
    String code = alphabets + numbers;

    return code;
  }

  Uint8List generateObjectId() {
    final rand = Random.secure();

    // Timestamp (4 bytes)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final timestampBytes = Uint8List(4);
    for (int i = 0; i < 4; i++) {
      timestampBytes[i] = (timestamp >> (i * 8)) & 0xFF;
    }

    // Machine identifier (3 bytes)
    final machineId = rand.nextInt(pow(2, 24).toInt());
    final machineIdBytes = Uint8List(3);
    for (int i = 0; i < 3; i++) {
      machineIdBytes[i] = (machineId >> (i * 8)) & 0xFF;
    }

    // Process identifier (2 bytes)
    final processId = rand.nextInt(pow(2, 16).toInt());
    final processIdBytes = Uint8List(2);
    for (int i = 0; i < 2; i++) {
      processIdBytes[i] = (processId >> (i * 8)) & 0xFF;
    }

    // Random incrementing counter (3 bytes)
    final counterBytes = Uint8List(3);
    for (int i = 0; i < 3; i++) {
      counterBytes[i] = rand.nextInt(256);
    }

    // Concatenate all bytes
    final objectIdBytes = Uint8List.fromList([
      ...timestampBytes,
      ...machineIdBytes,
      ...processIdBytes,
      ...counterBytes,
    ]);

    return objectIdBytes;
  }

  String objectIdToString(Uint8List objectId) {
    return objectId.map((byte) {
      return byte.toRadixString(16).padLeft(2, '0');
    }).join('');
  }

  String objectId() {
    final object = generateObjectId();
    return objectIdToString(object);
  }
}

Functions fn = Functions();
