import 'package:alfred/alfred.dart';
import 'package:flutter/material.dart';
import 'package:kloudlite_vpn/service/vpn_provider.dart';
import 'package:provider/provider.dart';

void startService(BuildContext ctx) async {
  final app = Alfred();

  var vctx = Provider.of<VPNProvider>(ctx, listen: false);

  app.get('/healthy', (req, res) => 'ok');
  app.post('/act', (req, res) async {
    final body = await req.bodyAsJsonMap;
    debugPrint(body.toString());

    var action = body["action"] as String;
    var data = body["data"];

    switch (action) {
      case "connect":
        vctx.connect(data);
      case "disconnect":
        vctx.disconnect();
      default:
        res.statusCode = 401;
        res.write("wrong action, available actions [ connect | disconnect ]");
        res.close();
    }

    return "ok";
  });

  await app.listen(17171);
}
