Map<String, Map<String, String>> parseConfig(String configFile) {
  final Map<String, Map<String, String>> config = {};
  final List<String> lines = configFile.split('\n');
  String currentSection = "";

  for (final line in lines) {
    final trimmedLine = line.trim();
    if (trimmedLine.isEmpty) continue;

    if (trimmedLine.startsWith('[') && trimmedLine.endsWith(']')) {
      currentSection = trimmedLine.substring(1, trimmedLine.length - 1);
      config[currentSection] = {};
    } else {
      final parts = trimmedLine.split('=');
      if (currentSection != "" && parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();
        config[currentSection]![key] = value;
      }
    }
  }

  return config;
}
