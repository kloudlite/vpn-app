const appName = "Kloudlite";

const String sampleVpnConfig = '''
[Interface]
Address = 10.13.0.2/32
PrivateKey = YqHyVrhK8w7ggdf0ZufE70Q73an1QOoFnu4t+pmjSTo=
DNS = 10.13.0.3

[Peer]
PublicKey = bSeYGbYB9mD/x6uPUwdyoSAqm1t3AxkgvKhbutE5DEk=
AllowedIPs = 10.42.0.0/16, 10.43.0.0/16, 10.13.0.0/16
Endpoint = newcluster.e2etesting-895139.tenants.devc.kloudlite.io:30104
''';
