import 'dart:io';

import 'package:biyi_app/services/local_db/local_db.dart';
import 'package:biyi_app/utilities/env.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uni_platform/uni_platform.dart';

// 请按文件名排序放置
export './env.dart';
export './global_audio_player.dart';
export './global_key_ex.dart';
export './language_util.dart';
export './pretty_json.dart';
export './r.dart';
export './remove_nulls.dart';

final sharedEnv = Env.instance;

Directory? _dataDirectory;

Future<Directory> getAppDirectory() async {
  if (!UniPlatform.isWeb && _dataDirectory == null) {
    final docDir = await getApplicationDocumentsDirectory();

    if (UniPlatform.isLinux || UniPlatform.isWindows) {
      _dataDirectory = Directory(path.join(docDir.parent.path, '.biyi'));
      if (!_dataDirectory!.existsSync()) {
        _dataDirectory!.createSync(recursive: true);
      }
    } else {
      _dataDirectory = docDir;
    }
  }
  if (UniPlatform.isWeb && _dataDirectory == null) {
    _dataDirectory = Directory('');
  }
  return _dataDirectory!;
}

Future<Directory> getUserDataDirectory() async {
  final appDirectory = await getAppDirectory();
  final currentUser = await getCurrentUser();

  final userDataDirectory = Directory(
    path.join(
      appDirectory.path,
      currentUser.id == -1 ? 'local' : currentUser.email,
    ),
  );

  return userDataDirectory;
}
