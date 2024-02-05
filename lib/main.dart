import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:kloudlite_vpn/screens/main_screen.dart';
import 'package:kloudlite_vpn/service/vpn_provider.dart';
import 'package:provider/provider.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  if (Platform.isWindows) {
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      AppWindow().hide();
      return false;
    });
  }
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(300, 480),
    center: true,
    backgroundColor: Colors.transparent,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();

    var future = Future.delayed(const Duration(seconds: 3));

    future.asStream().listen((d) async {
      await windowManager.hide();
    });
  });

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => VPNProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.transparent,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const MainScreen(),
          ),
        ),
      ),
    ),
  );
}
