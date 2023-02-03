import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

class FileRepository {
  late Logger logger;
  String androidManifestPath =
      '.\\android\\app\\src\\main\\AndroidManifest.xml';
  String iosInfoPlistPath = '.\\ios\\Runner\\Info.plist';
  String androidAppBuildGradlePath = '.\\android\\app\\build.gradle';
  String iosProjectPbxprojPath = '.\\ios\\Runner.xcodeproj\\project.pbxproj';
  String macosAppInfoxprojPath = '.\\macos\\Runner\\Configs\\AppInfo.xcconfig';
  String launcherIconPath = '.\\assets\\images\\launcherIcon.png';
  String linuxCMakeListsPath = '.\\linux\\CMakeLists.txt';
  String linuxAppCppPath = '.\\linux\\my_application.cc';
  String webAppPath = '.\\web\\index.html';
  String windowsAppPath = '.\\windows\\runner\\main.cpp';
  String windowsAppRCPath = '.\\windows\\runner\\Runner.rc';

  FileRepository() {
    logger = Logger(filter: ProductionFilter());
    if (Platform.isMacOS || Platform.isLinux) {
      androidManifestPath = 'android/app/src/main/AndroidManifest.xml';
      iosInfoPlistPath = 'ios/Runner/Info.plist';
      androidAppBuildGradlePath = 'android/app/build.gradle';
      iosProjectPbxprojPath = 'ios/Runner.xcodeproj/project.pbxproj';
      macosAppInfoxprojPath = 'macos/Runner/Configs/AppInfo.xcconfig';
      launcherIconPath = 'assets/images/launcherIcon.png';
      linuxCMakeListsPath = 'linux/CMakeLists.txt';
      linuxAppCppPath = 'linux/my_application.cc';
      webAppPath = 'web/index.html';
      windowsAppPath = 'windows/runner/main.cpp';
      windowsAppRCPath = 'windows/runner/Runner.rc';
    }
  }

  Future<List<String?>?> readFileAsLineByline(
      {required String filePath}) async {
    try {
      var fileAsString = await File(filePath).readAsString();
      return fileAsString.split('\n');
    } catch (e) {
      return null;
    }
  }

  Future<File> writeFile({required String filePath, required String content}) {
    return File(filePath).writeAsString(content);
  }

  Future<String?> getIosBundleId() async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: iosProjectPbxprojPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Ios BundleId could not be changed because,
      The related file could not be found in that path:  $iosProjectPbxprojPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_BUNDLE_IDENTIFIER')) {
        return (contentLineByLine[i] as String).split('=').last.trim();
      }
    }
  }

  Future<File?> changeIosBundleId({String? bundleId}) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: iosProjectPbxprojPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Ios BundleId could not be changed because,
      The related file could not be found in that path:  $iosProjectPbxprojPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_BUNDLE_IDENTIFIER')) {
        contentLineByLine[i] = '				PRODUCT_BUNDLE_IDENTIFIER = $bundleId;';
      }
    }
    var writtenFile = await writeFile(
      filePath: iosProjectPbxprojPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('IOS BundleIdentifier changed successfully to : $bundleId');
    return writtenFile;
  }

  Future<String?> getMacOsBundleId() async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: macosAppInfoxprojPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      macOS BundleId could not be changed because,
      The related file could not be found in that path:  $macosAppInfoxprojPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_BUNDLE_IDENTIFIER')) {
        return (contentLineByLine[i] as String).split('=').last.trim();
      }
    }
  }

  Future<File?> changeMacOsBundleId({String? bundleId}) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: macosAppInfoxprojPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      macOS BundleId could not be changed because,
      The related file could not be found in that path:  $macosAppInfoxprojPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_BUNDLE_IDENTIFIER')) {
        contentLineByLine[i] = 'PRODUCT_BUNDLE_IDENTIFIER = $bundleId;';
      }
    }
    var writtenFile = await writeFile(
      filePath: macosAppInfoxprojPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('MacOS BundleIdentifier changed successfully to : $bundleId');
    return writtenFile;
  }

  Future<String?> getAndroidBundleId() async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: androidAppBuildGradlePath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Android BundleId could not be changed because,
      The related file could not be found in that path:  $androidAppBuildGradlePath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('applicationId')) {
        return (contentLineByLine[i] as String).split('"').elementAt(1).trim();
      }
    }
  }

  Future<File?> changeAndroidBundleId({String? bundleId}) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: androidAppBuildGradlePath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Android BundleId could not be changed because,
      The related file could not be found in that path:  $androidAppBuildGradlePath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('applicationId')) {
        contentLineByLine[i] = '        applicationId \"$bundleId\"';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: androidAppBuildGradlePath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('Android bundleId changed successfully to : $bundleId');
    return writtenFile;
  }

  Future<String?> getLinuxBundleId() async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: linuxCMakeListsPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Linux BundleId could not be changed because,
      The related file could not be found in that path:  $linuxCMakeListsPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('set(APPLICATION_ID')) {
        return (contentLineByLine[i] as String).split('"').elementAt(1).trim();
        ;
      }
    }
  }

  Future<File?> changeLinuxBundleId({String? bundleId}) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: linuxCMakeListsPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Linux BundleId could not be changed because,
      The related file could not be found in that path:  $linuxCMakeListsPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('set(APPLICATION_ID')) {
        contentLineByLine[i] = 'set(APPLICATION_ID \"$bundleId\")';
      }
    }
    var writtenFile = await writeFile(
      filePath: linuxCMakeListsPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('Linux BundleIdentifier changed successfully to : $bundleId');
    return writtenFile;
  }

  Future<File?> changeIosAppName(String? appName, String? flavor) async {
    if (flavor != null) {
      // replace filename that follows the patter filename.plist to filename-$flavor.plist
      iosInfoPlistPath = iosInfoPlistPath!.replaceAll(
        '.plist',
        '-$flavor.plist',
      );
    }
    List? contentLineByLine = await readFileAsLineByline(
      filePath: iosInfoPlistPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Ios AppName could not be changed because,
      The related file could not be found in that path:  $iosInfoPlistPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('<key>CFBundleName</key>')) {
        contentLineByLine[i + 1] = '\t<string>$appName</string>\r';
        break;
      }
    }

    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('<key>CFBundleDisplayName</key>')) {
        contentLineByLine[i + 1] = '\t<string>$appName</string>\r';
        break;
      }
    }

    var writtenFile = await writeFile(
      filePath: iosInfoPlistPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('IOS appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<File?> changeMacOsAppName(String? appName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: macosAppInfoxprojPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      macOS AppName could not be changed because,
      The related file could not be found in that path:  $macosAppInfoxprojPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_NAME')) {
        contentLineByLine[i] = 'PRODUCT_NAME = $appName;';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: macosAppInfoxprojPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('MacOS appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<File?> changeAndroidAppName(String? appName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: androidManifestPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Android AppName could not be changed because,
      The related file could not be found in that path:  $androidManifestPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('android:label=')) {
        contentLineByLine[i] = '        android:label=\"$appName\"';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: androidManifestPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('Android appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<bool> changeLinuxCppName(String? appName, String oldAppName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: linuxAppCppPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Linux AppName could not be changed because,
      The related file could not be found in that path:  $linuxAppCppPath
      ''');
      return false;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      contentLineByLine[i] =
          contentLineByLine[i].replaceAll(oldAppName, appName);
    }
    return true;
  }

  Future<File?> changeLinuxAppName(String? appName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: linuxCMakeListsPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Linux AppName could not be changed because,
      The related file could not be found in that path:  $linuxCMakeListsPath
      ''');
      return null;
    }
    String? oldAppName;
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].startsWith('set(BINARY_NAME')) {
        oldAppName = RegExp(r'set\(BINARY_NAME "(\w+)"\)')
            .firstMatch(contentLineByLine[i])
            ?.group(1);
        contentLineByLine[i] = 'set(BINARY_NAME \"$appName\")';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: linuxCMakeListsPath,
      content: contentLineByLine.join('\n'),
    );
    if (oldAppName != null) {
      if (await changeLinuxCppName(appName, oldAppName) == false) {
        return null;
      }
    }
    logger.i('Linux appname changed successfully to : $appName');
    return writtenFile;
  }

  // ignore: missing_return
  Future<String?> getCurrentIosAppName() async {
    var contentLineByLine = await (readFileAsLineByline(
      filePath: iosInfoPlistPath,
    ) as FutureOr<List<dynamic>>);
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('<key>CFBundleName</key>')) {
        return (contentLineByLine[i + 1] as String).trim().substring(5, 5);
      }
    }
  }

  // ignore: missing_return
  Future<String?> getCurrentAndroidAppName() async {
    var contentLineByLine = await (readFileAsLineByline(
      filePath: androidManifestPath,
    ) as FutureOr<List<dynamic>>);
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('android:label')) {
        return (contentLineByLine[i] as String).split('"')[1];
      }
    }
  }

  bool checkFileExists(List? fileContent) {
    return fileContent == null || fileContent.isEmpty;
  }

  Future<String?> getWebAppName() async {}

  Future<File?> changeWebAppName(String? appName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: webAppPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Web appname could not be changed because,
      The related file could not be found in that path:  $webAppPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('<title>') &&
          contentLineByLine[i].contains('</title>')) {
        contentLineByLine[i] = '  <title>$appName</title>';
        break;
      }
    }
    var writtenFile = await writeFile(
      filePath: webAppPath,
      content: contentLineByLine.join('\n'),
    );
    logger.i('Web appname changed successfully to : $appName');
    return writtenFile;
  }

  Future<String?> getWindowsAppName() async {}

  Future<void> changeWindowsAppName(String? appName) async {
    await changeWindowsCppName(appName);
    await changeWindowsRCName(appName);
    logger.i('Windows appname changed successfully to : $appName');
  }

  Future<void> changeWindowsCppName(String? appName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: windowsAppPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Windows appname could not be changed because,
      The related file could not be found in that path:  $windowsAppPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('window.CreateAndShow')) {
        contentLineByLine[i] =
            contentLineByLine[i].replaceAllMapped(RegExp(r'CreateAndShow\(L"([^"]+")'), (match) { return 'CreateAndShow(L"$appName"'; });
        break;
      }
    }
    await writeFile(
      filePath: windowsAppPath,
      content: contentLineByLine.join('\n'),
    );
  }

  Future<void> changeWindowsRCName(String? appName) async {
    List? contentLineByLine = await readFileAsLineByline(
      filePath: windowsAppRCPath,
    );
    if (checkFileExists(contentLineByLine)) {
      logger.w('''
      Windows appname could not be changed because,
      The related file could not be found in that path:  $windowsAppRCPath
      ''');
      return null;
    }
    for (var i = 0; i < contentLineByLine!.length; i++) {
      if (contentLineByLine[i].contains('VALUE "InternalName"')) {
        contentLineByLine[i] = '            VALUE "InternalName", "$appName" "\\0"';
      }
      else if (contentLineByLine[i].contains('VALUE "FileDescription"')) {
        contentLineByLine[i] = '            VALUE "FileDescription", "$appName" "\\0"';
      }
      else if (contentLineByLine[i].contains('VALUE "ProductName"')) {
        contentLineByLine[i] = '            VALUE "ProductName", "$appName" "\\0"';
      }
    }
    await writeFile(
      filePath: windowsAppRCPath,
      content: contentLineByLine.join('\n'),
    );
  }
}
