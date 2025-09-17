import 'package:framework/base/db/x_cache.dart';

class UuidUtils {
  static String? _uuid = "";

  /**
   * Generate a random 32bit unique identifier
   */
  static String generateUUID() {
    return DateTime.now().millisecondsSinceEpoch.toRadixString(16);
  }

  static void clear() {
    _uuid = "";
    XCache.getInstance().remove("uuid");
  }

  static String getUUID() {
    if (_uuid?.isNotEmpty == true) {
      return _uuid!;
    }
    _uuid = XCache.getInstance().get("uuid");
    if (_uuid == null) {
      _uuid = generateUUID();
      XCache.getInstance().setString("uuid", _uuid!);
    }
    return _uuid!;
  }
}

class AbTestUtils {
  static int? _abTest = -1;

  /**
   * 0-1000
   */
  static int getAbTest() {
    if (_abTest != null && _abTest! > -1) {
      return _abTest!;
    }
    _abTest = XCache.getInstance().get("abTest");
    if (_abTest == null || _abTest == -1) {
      _abTest = DateTime.now().millisecond % 1000;
      XCache.getInstance().setInt("abTest", _abTest!);
    }
    return _abTest!;
  }
}
