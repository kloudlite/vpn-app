import 'package:flutter/material.dart';
import 'package:kloudlite_vpn/utils/parse.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class VPNProvider extends ChangeNotifier {
  final wireguard = WireGuardFlutter.instance;

  String status = "disconnected";
  String connectionError = "";

  late String name;

  init() {
    wireguard.vpnStageSnapshot.listen((event) {
      debugPrint("status changed $event");
      status = event.name;
      notifyListeners();
    });
  }

  // Future<void> initialize() async {
  //   try {
  //     await wireguard.initialize(interfaceName: name);
  //     debugPrint("initialize success");
  //   } catch (error, stack) {
  //     debugPrint("failed to initialize: $error\n$stack");
  //   }
  // }

  Future<void> connect(String conf) async {
    debugPrint("here");
    var cfg = parseConfig(conf);

    var endpoint = cfg["Peer"]!["Endpoint"].toString();
    try {
      await wireguard.startVpn(
        serverAddress: endpoint,
        wgQuickConfig: conf,
        providerBundleIdentifier: 'io.kloudlite.vpncli.WGExtension',
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
