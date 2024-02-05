import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kloudlite_vpn/utils/parse.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';
import 'package:uuid/uuid.dart';

class VPNProvider extends ChangeNotifier {
  final wireguard = WireGuardFlutter.instance;
  bool serviceStatus = false;

  String status = "disconnected";
  String connectionError = "";

  setSvcStatus(bool svcStatus) {
    serviceStatus = true;
    notifyListeners();
  }

  init() async {
    wireguard.vpnStageSnapshot.listen((event) {
      debugPrint("status changed $event");
      status = event.name;
      notifyListeners();
    });
  }

  Future<void> connect(String conf) async {
    if (Platform.isWindows) {
      try {
        var uuid = const Uuid();
        await wireguard.initialize(
            interfaceName: "wg_vpn${uuid.v4().substring(0, 5)}");
        debugPrint("initialize success");
      } catch (error, stack) {
        debugPrint("failed to initialize: $error\n$stack");
      }
    }
    var cfg = parseConfig(conf);

    var endpoint = cfg["Peer"]!["Endpoint"].toString();

    var id = "kloudlite";

    if (Platform.isMacOS) {
      id = "io.kloudlite.vpncli.WGExtension";
    }

    try {
      await wireguard.startVpn(
        serverAddress: endpoint,
        wgQuickConfig: conf,
        providerBundleIdentifier: id,
      );

      status = "connected";
      notifyListeners();
    } catch (error, stack) {
      connectionError = error.toString();
      debugPrint("failed to start $error\n$stack");
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    try {
      await wireguard.stopVpn();
      status = "disconnected";
    } catch (e, str) {
      connectionError = e.toString();
      debugPrint('Failed to disconnect $e\n$str');
      notifyListeners();
    }
  }

  Future<String> getStage() async {
    final stage = await wireguard.stage();
    return stage.toString();
  }

  String getStatus() {
    return status;
  }
}
