import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:kloudlite_vpn/components/main.dart';
import 'package:kloudlite_vpn/screens/main_screen.dart';
import 'package:kloudlite_vpn/service/vpn_provider.dart';
import 'package:provider/provider.dart';
import 'package:system_tray/system_tray.dart';
// import 'package:kloudlite_vpn/screens/setup_flows.dart';
import 'package:window_manager/window_manager.dart';

// import 'utils/exec.dart';

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
    // size: Size(300, 480),
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

  // check if command line tools installed
  // var cliInstalled = true;
  // if (Platform.isIOS || Platform.isAndroid) {
  // } else {
  //   var resp = await exec("kl", []);
  //   cliInstalled = (resp.err == "");
  // }

  // runApp(
  //   const MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: Scaffold(
  //       backgroundColor: Colors.white,
  //       // body: (cliInstalled ? const ConnectedScreen() : const SetupScreen()),
  //       body: MainScreen(),
  //     ),
  //   ),
  // );
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (ctx) => VPNProvider())],
      child: MaterialApp(
        // key: TwService.appKey,
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

class ConnectedScreen extends StatelessWidget {
  const ConnectedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.green[700],
            padding: const EdgeInsets.all(10),
            child: const Row(
              children: [
                Text(
                  "karthik-mac.local",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                VerticalDivider(thickness: 2, color: Colors.grey, width: 20),
                Spacer(),
                Text(
                  'Connected',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.signal_cellular_4_bar,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
          BodyContainer(
            children: [
              const InfoBlock(label: 'Connected Cluster', value: 'us-west-1'),
              const InfoBlock(
                  label: 'Active Namespace', value: 'vpn-namespace'),
              InfoBlock(
                  label: 'Exposed Ports',
                  valueWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 5,
                        children: [
                          const KChip(
                            label: "8080:8080",
                          ),
                          const KChip(
                            label: "8080:8080",
                          ),
                          const KChip(
                            label: "8080:8080",
                          ),
                          const KChip(
                            label: "8080:8080",
                          ),
                          const KChip(
                            label: "8080:8080",
                          ),
                          const KChip(
                            label: "8080:8080",
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 240,
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      "Expose Port",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                        color: Colors.grey,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                            Icons.close))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: const InputBox()),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: const Text(
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    """
Ex: 8080:8080

This will allow all the services/devices in the cluster to access servers runnin on your device."""),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: const Text("Expose Port")),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  )),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 200,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.link_off),
                                    title: const Text('Disconnect'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.logout),
                                    title: const Text('Logout'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.settings))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
