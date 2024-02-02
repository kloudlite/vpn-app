import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class Resp {
  String out = "";
  String err = "";
}

Future<Resp> exec(String cmd, List<String> args) async {
  // return await shell.run(cmd);
  try {
    var currentPath = Platform.environment['PATH'] ?? '';
    var newPath = currentPath;

    if (Platform.isMacOS) {
      newPath = '/usr/local/bin:$currentPath';
    }

    final process = await Process.start(
      cmd,
      args,
      environment: {'PATH': newPath},
    );

    final List<String> standardOutputLines = [];
    final List<String> standardErrLines = [];

    await process.stdout
        .transform(utf8.decoder)
        .forEach(standardOutputLines.add);
    await process.stderr.transform(utf8.decoder).forEach(standardErrLines.add);

    var resp = Resp();

    resp.out = standardOutputLines.join('\n');
    resp.err = standardErrLines.join("\n");

    return resp;
  } catch (e) {
    var resp = Resp();
    resp.err = e.toString();
    return resp;
  }
}
