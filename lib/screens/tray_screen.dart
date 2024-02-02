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
  final Menu _menuSimple = Menu();

  Timer? _timer;

  bool _toogleMenu = true;
  String vpnStatus = "false";
  VPNProvider? vctx;

  @override
  void initState() {
    super.initState();
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

  Future<void> initSystemTray() async {
    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray(iconPath: getTrayImagePath('app_icon'));
    _systemTray.setToolTip("Kloudlite Client");

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? _appWindow.show() : _systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? _systemTray.popUpContextMenu() : _appWindow.show();
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

    await _menuSimple.buildFrom([
      MenuItemLabel(
        label: 'Change Context Menu',
        image: getTrayImagePath('app_icon'),
        onClicked: (menuItem) {
          debugPrint("Change Context Menu");

          _toogleMenu = !_toogleMenu;
          _systemTray.setContextMenu(_toogleMenu ? _menuMain : _menuSimple);
        },
      ),
      MenuSeparator(),
      MenuItemLabel(
          label: 'Show',
          image: getTrayImagePath('app_icon'),
          onClicked: (menuItem) => _appWindow.show()),
      MenuItemLabel(
          label: 'Hide',
          image: getTrayImagePath('app_icon'),
          onClicked: (menuItem) => _appWindow.hide()),
      MenuItemLabel(
        label: 'Exit',
        image: getTrayImagePath('app_icon'),
        onClicked: (menuItem) => _appWindow.close(),
      ),
    ]);

    _systemTray.setContextMenu(_menuMain);
  }

  @override
  Widget build(BuildContext context) {
    initSystemTray();

    if (Platform.isWindows || Platform.isMacOS) {
      startService(context);
    }

    vctx = Provider.of<VPNProvider>(context, listen: true);
    return Container();
  }
}
