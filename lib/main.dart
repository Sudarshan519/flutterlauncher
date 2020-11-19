import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:mechanicfinder/service/stateservice.dart';
import 'package:permission_handler/permission_handler.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var installedApps = [];
  List<String> allApps = [];
  var wallpaper;
  bool accessStorage;
  bool search = false;
  final TextEditingController _typeAheadController = TextEditingController();
  double height;
  @override
  void initState() {
    accessStorage = false;
    super.initState();
    LauncherAssist.getAllApps().then((var apps) {
      setState(() {
        installedApps = apps;
        print(apps.toString());
      });
      handleStoragePermission()
          .then((value) => LauncherAssist.getWallpaper().then((imageData) {
                setState(() {
                  wallpaper = imageData;
                  // ignore: unnecessary_statements
                  accessStorage != accessStorage;
                });
              }));
    });
  }

  statusbar() {}

  Future<bool> handleStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      if (await Permission.storage.request().isGranted) {
        //  print(status.isGranted);
        return true;
      } else if (status.isDenied) {
        await Permission.storage.request();
        return null;
      }
    } else if (status.isRestricted) {
      print('error');
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    if (accessStorage) {
      setState(() {});
    }
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.08),
        body: installedApps != null
            ? SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                        child: Column(
                      children: [
                        wallpaper != null
                            ? Image.memory(wallpaper, fit: BoxFit.contain)
                            : Container(),
                      ],
                    )),
                    SafeArea(
                      child: Container(
                        height: height,
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20, top: 10),
                                child: Material(
                                  elevation: 0,
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white.withOpacity(.7),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: TypeAheadField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        decoration: InputDecoration(
                                          suffix: InkWell(
                                            child: Icon(Icons.close),
                                            onTap: () {
                                              _typeAheadController.clear();
                                              FocusScope.of(context).unfocus();
                                            },
                                          ),
                                          hintText: "Search",
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 20),
                                          icon: Icon(Icons.search),
                                          border: InputBorder.none,

                                          //   prefixIcon: Icon(Icons.search),
                                        ),
                                        controller: this._typeAheadController,
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return StateService.getSuggestions(
                                            pattern, allApps);
                                      },
                                      transitionBuilder: (context,
                                          suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                          onTap: () {
                                            int i = allApps.indexOf(suggestion);
                                            LauncherAssist.launchApp(
                                                installedApps[i]['package']);
                                          },
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        this._typeAheadController.text =
                                            suggestion;
                                        LauncherAssist.launchApp('1');
                                      },
                                    ),
                                  ),
                                )),
                            Expanded(
                                child: ListView.builder(
                              itemCount: installedApps.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int i) {
                                allApps.isEmpty
                                    ? allApps.add(installedApps[i]['label'])
                                    // ignore: unnecessary_statements
                                    : null;
                              

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading:
                                        Image.memory(installedApps[i]['icon']),
                                    onTap: () => LauncherAssist.launchApp(
                                        installedApps[i]['package']),
                                    title: Text(
                                      installedApps[i]['label'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                strokeWidth: 10,
              )),
      ),
    );
  }
}
