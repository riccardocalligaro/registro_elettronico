import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:f_logs/f_logs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:f_logs/constants/constants.dart' as flog_constants;

class Logger {
  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '─';
  static const singleDivider = '┄';

  Logger._();

  static void initialize() {
    LogsConfig config = FLog.getDefaultConfigurations()
      ..formatType = FormatType.FORMAT_SQUARE
      ..timestampFormat = 'MMMM dd, y - hh:mm:ss a';
    FLog.applyConfigurations(config);
    FlutterError.onError = (FlutterErrorDetails details) async {
      bool inDebugMode = false;
      assert(inDebugMode = true);
      if (inDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
      Zone.current.handleUncaughtError(details.exception, details.stack);
    };
  }

  static void info(
    String text, {
    DataLogType type = DataLogType.DEFAULT,
  }) {
    FirebaseCrashlytics.instance.log(text);
    FLog.info(
      text: 'ℹ️ $text',
      dataLogType: type.toString(),
    );
  }

  static void dio(
    DioError e, {
    DataLogType type = DataLogType.DEFAULT,
  }) {
    if (e.response != null) {
      FLog.error(
        text: '⛔ ${e.response.data}',
        exception: Exception(e.response.statusCode),
        dataLogType: type.toString(),
      );
    } else {
      FLog.error(
        text: '$e',
        exception: Exception(e),
        dataLogType: type.toString(),
      );
    }
  }

  /// Not connected
  static void nc({
    DataLogType type = DataLogType.DEFAULT,
  }) {
    FLog.info(
      text: 'Not connected',
      dataLogType: type.toString(),
    );
  }

  static void debug(
    String text, {
    DataLogType type = DataLogType.DEFAULT,
  }) {
    FLog.debug(
      text: '💡 $text',
      dataLogType: type.toString(),
    );
  }

  static void warning(
    String text, {
    DataLogType type = DataLogType.DEFAULT,
  }) {
    FLog.warning(
      text: '⛔️ $text',
      dataLogType: type.toString(),
    );
  }

  static void networkError(
    String text,
    Object exception, {
    StackTrace trace,
    DataLogType type = DataLogType.DEFAULT,
    String className,
    String methodName,
  }) {
    FLog.error(
      text: '⛔️ $text',
      exception: Exception(error.toString()),
      stacktrace: trace,
    );
  }

  static void e({
    String text,
    Object exception,
    StackTrace stacktrace,
    DataLogType type = DataLogType.ERRORS,
    String className,
    String methodName,
  }) {
    FirebaseCrashlytics.instance.recordError(
      Exception(error.toString()),
      StackTrace.fromString(Trace.from(stacktrace).toString()),
      reason: '⛔️ ${Trace.from(stacktrace).frames[1].member.toString()}',
    );
    FLog.error(
      className: className ??
          Trace.from(stacktrace).frames[1].uri.toString() ??
          'Unknown',
      methodName: methodName ??
          Trace.from(stacktrace).frames[1].member.toString() ??
          'Unknown',
      text: '⛔️ ${Trace.from(stacktrace).frames[1].member.toString()}',
      exception: Exception(error.toString()),
      stacktrace: stacktrace,
      dataLogType: type.toString(),
    );
  }

  static void error(
    String text,
    Object error,
    StackTrace trace, {
    DataLogType type = DataLogType.DEFAULT,
    String className,
    String methodName,
  }) {
    FirebaseCrashlytics.instance.recordError(
      Exception(error.toString()),
      StackTrace.fromString(Trace.from(trace).toString()),
      reason: text,
    );

    FLog.error(
      className:
          className ?? Trace.from(trace).frames[1].uri.toString() ?? 'Unknown',
      methodName: methodName ??
          Trace.from(trace).frames[1].member.toString() ??
          'Unknown',
      text: text,
      exception: Exception(error.toString()),
      stacktrace: StackTrace.fromString(Trace.from(trace).toString()),
      dataLogType: type.toString(),
    );
  }

  static void fatal(
    Object error,
    StackTrace trace, {
    DataLogType type = DataLogType.DEFAULT,
  }) {
    FLog.fatal(
      className: Trace.from(trace).frames[1].uri.toString() ?? 'Unknown',
      methodName: Trace.from(trace).frames[1].member.toString() ?? 'Unknown',
      text: error.toString(),
      exception: Exception(error.toString()),
      stacktrace: trace,
      dataLogType: type.toString(),
    );
  }

  static void exportLogs() {
    FLog.exportLogs();
  }

  static void clearLogs() {
    FLog.clearLogs();
  }

  static Future<File> getLogsFile() async {
    FLog.exportLogs();

    Directory directory = await _getLogsDirectory();

    if (directory == null) {
      print('Can not find directory for logs file');
      return null;
    } else {
      final path =
          directory.path + "/" + flog_constants.Constants.DIRECTORY_NAME;
      //creating directory
      await Directory(path).create()
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });

      //opening file
      var file = File("$path/flog.txt");
      var isExist = await file.exists();

      //check to see if file exist
      if (isExist) {
        print('File exists(data_manager)------------------>_getLocalFile()');
      } else {
        print('file does not exist(data_manager)---------->_getLocalFile()');
      }
      return file;
    }
  }

  static Future<Directory> _getLogsDirectory() async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    return directory;
  }
}
