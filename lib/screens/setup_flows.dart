import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

import 'package:kloudlite_vpn/components/main.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Welcome to Kloudlite",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        const SizedBox(height: 10),
        const Text("Let's get you up and running",
            style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 10),
        RoundedButton(
            label: "Proceed",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DownloadClientScreen()),
              );
            },
            color: Colors.blue),
      ],
    ));
  }
}

class DownloadClientScreen extends StatefulWidget {
  const DownloadClientScreen({
    super.key,
  });

  @override
  State<DownloadClientScreen> createState() => _DownloadClientScreenState();
}

class _DownloadClientScreenState extends State<DownloadClientScreen> {
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Install the command line",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          const SizedBox(height: 40),
          const Text("> kl",
              style: TextStyle(
                  color: Colors.grey, fontSize: 48, fontFamily: "monospace")),
          const SizedBox(height: 40),
          RoundedButton(
              label: isDownloading ? "Installing..." : "Install",
              
              onPressed: () async {
                setState(() {
                  isDownloading = true;
                });
                
                var shell = Shell();
                await shell.run("""
#!/bin/bash
/usr/bin/osascript -e 'do shell script "curl https://kl.kloudlite.io/kloudlite/kl! | bash && curl 'https://kl.kloudlite.io/kloudlite/kl!?source=kli' | bash" with administrator privileges'
""");
setState(() {
                  isDownloading = false;
                });
              },
              color: Colors.blue),
          const SizedBox(height: 10),
          const Center(
            child: SizedBox(
              width: 200,
              child: Text(
                textAlign: TextAlign.center,
                "you will be prompted for administrator access",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
