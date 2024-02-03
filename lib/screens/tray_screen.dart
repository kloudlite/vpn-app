import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kloudlite_vpn/service/service.dart';
import 'package:kloudlite_vpn/service/vpn_provider.dart';
import 'package:kloudlite_vpn/utils/exec.dart';
import 'package:provider/provider.dart';
import 'package:system_tray/system_tray.dart';

String getTrayImagePath(String imageName) {
  return Platform.isWindows ? 'assets/$imageName.ico' : 'assets/$imageName.png';
}


class TrayScreen extends StatefulWidget {
  const TrayScreen({Key? key}) : super(key: key);

  @override
  State<TrayScreen> createState() => _TrayScreenState();
}

class _TrayScreenState extends State<TrayScreen> {
  final AppWindow _appWindow = AppWindow();
  final SystemTray _systemTray = SystemTray();
  final Menu _menuMain = Menu();

  Timer? _timer;

  String vpnStatus = "false";
  VPNProvider? vctx;

  @override
  void initState() {
    super.initState();
    _systemTray.initSystemTray(iconPath: getTrayImagePath("app_icon_inactive"));
    if (Platform.isWindows || Platform.isMacOS) {
      startService(context);
    }
    
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  connectHandler() async {
    var status = vctx!.getStatus();
    if (status == "connected") {
      await vctx!.disconnect();
    } else if (status == "disconnected") {
      var resp = await exec("kli", ["vpn", "start"]);
      debugPrint(resp.err);
      debugPrint(resp.out);
    }
  }

  closeHandler() async {
    var status = vctx!.getStatus();
    if (status == "connected") {
      await vctx!.disconnect();
    }
    exit(0);
  }

  Future<void> buildSystemTray() async {
    
    String getIcon() {
      switch (vctx!.status) {
        case "disconnecting":
        case "connected":
          return "app_icon_active";
        case "connecting":
        case "disconnected":
        default:
          return "app_icon_inactive";
      }
    }

    _systemTray.setToolTip("Kloudlite Client");
    await _systemTray.setImage(getTrayImagePath(getIcon()));

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick || eventName == kSystemTrayEventRightClick) {
        _systemTray.popUpContextMenu(); 
      }
    });

    String getStatusText() {
      switch (vctx!.status) {
        case "connecting":
          return "Connecting";
        case "disconnecting":
          return "Disconnecting";
        case "connected":
          return "Active";
        case "disconnected":
          return "Inactive";
        default:
          return vctx!.status;
      }
    }

    String getConnectButtonText() {
      switch (vctx!.status) {
        case "disconnecting":
        case "connected":
          return "Disconnect Vpn";
        case "connecting":
        case "disconnected":
        default:
          return "Connect Vpn";
      }
    }

    await _menuMain.buildFrom(
      [
        MenuItemLabel(
          label: "Status: ${getStatusText()}",
          enabled: vctx!.status == "connected",
        ),
        MenuSeparator(),
        MenuItemLabel(
          label: getConnectButtonText(),
          onClicked: (menuItem) => connectHandler(),
          enabled:
              vctx!.status == "connected" || vctx!.status == "disconnected",
        ),
        MenuSeparator(),
        MenuItemLabel(
            label: 'Quit Kloudlite', onClicked: (menuItem) => closeHandler()),
      ],
    );
    _systemTray.setContextMenu(_menuMain);
  }

  @override
  Widget build(BuildContext context) {
    vctx = Provider.of<VPNProvider>(context, listen: true);
    buildSystemTray();
    return Container();
  }
}
