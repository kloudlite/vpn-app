import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kloudlite_vpn/screens/tray_screen.dart';
import 'package:kloudlite_vpn/service/vpn_provider.dart';
import 'package:provider/provider.dart';
import 'package:system_tray/system_tray.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _timer;
  VPNProvider? vctx;

  @override
  void initState() {
    Provider.of<VPNProvider>(context, listen: false).init();

    var future = Future.delayed(const Duration(milliseconds: 100));

    future.asStream().listen((d) {
      AppWindow().close();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  clickHandle() {
    debugPrint("hello world");
  }

  String output = "";

  @override
  Widget build(BuildContext context) {
    vctx = Provider.of<VPNProvider>(context, listen: false);

    return const Column(
      children: [
        TrayScreen(),
        Text("Kloudlite"),
      ],
    );
  }
}
