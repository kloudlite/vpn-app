import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:kloudlite_vpn/screens/main_screen.dart';
import 'package:kloudlite_vpn/service/vpn_provider.dart';
import 'package:provider/provider.dart';
import 'package:system_tray/system_tray.dart';

void main() async {
  if (Platform.isWindows) {
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      AppWindow().hide();

      return false;
    });
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => VPNProvider())],
      child: const MaterialApp(
        home: Scaffold(
          body: MainScreen(),
        ),
      ),
    ),
  );
}
