import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:mechanicfinder/service/stateservice.dart';

class AppScreen extends StatefulWidget {
  final Uint8List wallpaper;
  final List installedApps;
  //final List allApps;

  AppScreen(
    this.wallpaper,
    this.installedApps,
  );

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> allApps = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    Orientation orientation;
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Hero(
        tag: 'hero',
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                  color: Colors.white24.withOpacity(.3),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                        child: Material(
                          color: Colors.white24,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 20),
                            child: searchField(context),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: widget.installedApps.length,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (orientation == Orientation.portrait)
                                          ? 2
                                          : 3),
                          itemBuilder: (BuildContext context, int index) {
                            allApps.add(widget.installedApps[index]['label'],);
                            return Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: InkWell(
                                onTap: () {
                                  print(widget.installedApps[index]['package']);
                                  LauncherAssist.launchApp(
                                      widget.installedApps[index]['package']);
                                },
                                child: Column(
                                  children: [
                                    Image.memory(
                                      widget.installedApps[index]['icon'],
                                      height: 50,
                                      width: 50,
                                    ),
                                    Text(
                                      widget.installedApps[index]['label'],
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget searchField(context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(
          suffix: InkWell(
            child: Icon(Icons.close),
            onTap: () {
              _searchController.clear();
              FocusScope.of(context).unfocus();
            },
          ),
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.black45, fontSize: 20),
          icon: Icon(Icons.search),
          border: InputBorder.none,

          //   prefixIcon: Icon(Icons.search),
        ),
        controller: this._searchController,
      ),
      suggestionsCallback: (pattern) {
        return StateService.getSuggestions(pattern, allApps);
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            int i = allApps.indexOf(suggestion);
            LauncherAssist.launchApp(widget.installedApps[i]['package']);
          },
        );
      },
      onSuggestionSelected: (suggestion) {
        this._searchController.text = suggestion;
        LauncherAssist.launchApp('1');
      },
    );
  }
}
