class StateService {
  static final List<String> apps = [];
  static List<String> getSuggestions(String query, installedApps) {
    print(installedApps.toString());
    List<String> matches = List<String>.from(installedApps);

     matches.addAll(apps);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
   //  print(apps.length);
    return matches;
  }
}
