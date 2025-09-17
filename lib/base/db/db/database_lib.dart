import '../../utils/platfrom_utils.dart';
import 'database_creator.dart';

import 'database_native.dart' if (dart.library.io) 'database_native.dart';
import 'database_web.dart' if (dart.library.html) 'database_web.dart';

DatabaseCreator getDatabase(String dbname) {
  if (PlatformUtils.isNative) {
    return DatabaseNative(dbname);
  } else {
    return DatabaseWeb(dbname);
  }
}
