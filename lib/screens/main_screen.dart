import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kloudlite_vpn/screens/tray_screen.dart';
import 'package:kloudlite_vpn/service/vpn_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // vctx = Provider.of<VPNProvider>(context, listen: false);
    return DragToMoveArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TrayScreen(),
            const Text(
              "Welcome to Kloudlite",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(height: 10),
            Container(
              padding: const EdgeInsets.all(40),
              child: const Text(
                "We are making everything ready for you, please wait...",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
