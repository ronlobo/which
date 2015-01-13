
library which.src.is_executable;

import 'dart:async';
import 'dart:io';

import 'package:when/when.dart';

import 'has_permission.dart';

Future<bool> isExecutable(String path, bool isWindows, Future<FileStat> getStat(path)) =>
    _isExecutable(path, isWindows, getStat);

bool isExecutableSync(String path, bool isWindows, FileStat getStat(path)) =>
    _isExecutable(path, isWindows, getStat);

_isExecutable(String path, bool isWindows, getStat(path)) =>
    when(() => getStat(path), onSuccess: (stat) => isExecutableStat(stat, isWindows));

/// Tests whether the file exists and is executable.
bool isExecutableStat(FileStat stat, bool isWindows) {
  if (FileSystemEntityType.FILE != stat.type) return false;

  // There is no concept of executable on windows.
  if (isWindows) return true;

  return hasPermission(stat.mode, FilePermission.EXECUTE, role: FilePermissionRole.WORLD);
  // TODO: Also check for uid/gid permissions if/when that is supported:
  //       https://dartbug.com/22037.
}
