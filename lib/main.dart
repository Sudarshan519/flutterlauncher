import 'package:flutter/material.dart';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:mechanicfinder/screens/apps_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var installedApps = [];
  List<String> allApps = [
    'com.android.quicksearchbox',
    'com.android.gallery3d',
    'com.android.messaging',
    'com.android.quicksearchbox'
  ];
  var wallpaper;
  bool hidden = true;
  bool accessStorage;
  bool search = false;
  // double _statusBarHeight = 0.0;
  final TextEditingController _typeAheadController = TextEditingController();
  double height;
  @override
  void initState() {
    FlutterStatusbarManager.setColor(
      Colors.black.withOpacity(0),
    );
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
    // getAppName();
  }

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
      // ignore: missing_return
      onWillPop: () {
        Future(() => false);
        setState(() {
          hidden = true;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.08),
        body: installedApps != null
            ? Stack(
                children: [
                  wallpaper != null
                      ? Image.memory(
                          wallpaper,
                          height: height,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 68.0, left: 20, right: 20),
                            child: Material(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                      suffixIcon: Icon(
                                        Icons.settings,
                                        size: 30,
                                        color: Colors.grey[700],
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RotatedBox(
                                quarterTurns: 45,
                                child: Center(
                                    child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return AppScreen(
                                            wallpaper, installedApps, );
                                      },
                                    ));
                                  },
                                )),
                              ),
                              Hero(
                                tag: 'hero',
                                child: Card(
                                  color: Colors.transparent,
                                  child: Container(
                                    height: height * .16,
                                    color: Colors.white24,
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            LauncherAssist.launchApp(
                                                'com.android.gallery3d');
                                          },
                                          child: Icon(
                                            Icons.messenger,
                                            size: 60,
                                          ),
                                        ),
                                        Icon(Icons.email,
                                            size: 60, color: Colors.white),
                                        Icon(Icons.image,
                                            size: 60, color: Colors.white),
                                        Icon(Icons.explore_rounded,
                                            size: 60, color: Colors.white),
                                        Icon(Icons.camera,
                                            size: 60, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        )
                      ],
                    ),
                  )
                  // SafeArea(
                  //   child: Container(
                  //     child: Column(
                  //       children: [
                  //         Padding(
                  //             padding: const EdgeInsets.only(
                  //                 left: 20.0, right: 20, top: 10, bottom: 2),
                  //             child: Material(
                  //               elevation: 0,
                  //               color: Colors.white.withOpacity(.4),
                  //               borderRadius: BorderRadius.circular(30),
                  //               // color: Colors.black.withOpacity(.7),
                  //               child: Padding(
                  //                 padding: const EdgeInsets.only(
                  //                     left: 18.0, right: 20),
                  //                 child: TypeAheadField(
                  //                   textFieldConfiguration:
                  //                       TextFieldConfiguration(
                  //                     decoration: InputDecoration(
                  //                       suffix: InkWell(
                  //                         child: Icon(Icons.close),
                  //                         onTap: () {
                  //                           _typeAheadController.clear();
                  //                           FocusScope.of(context).unfocus();
                  //                         },
                  //                       ),
                  //                       hintText: "Search",
                  //                       hintStyle: TextStyle(
                  //                           color: Colors.black45, fontSize: 20),
                  //                       icon: Icon(Icons.search),
                  //                       border: InputBorder.none,

                  //                       //   prefixIcon: Icon(Icons.search),
                  //                     ),
                  //                     controller: this._typeAheadController,
                  //                   ),
                  //                   suggestionsCallback: (pattern) {
                  //                     return StateService.getSuggestions(
                  //                         pattern, allApps);
                  //                   },
                  //                   transitionBuilder:
                  //                       (context, suggestionsBox, controller) {
                  //                     return suggestionsBox;
                  //                   },
                  //                   itemBuilder: (context, suggestion) {
                  //                     return ListTile(
                  //                       title: Text(suggestion),
                  //                       onTap: () {
                  //                         int i = allApps.indexOf(suggestion);
                  //                         LauncherAssist.launchApp(
                  //                             installedApps[i]['package']);
                  //                       },
                  //                     );
                  //                   },
                  //                   onSuggestionSelected: (suggestion) {
                  //                     this._typeAheadController.text =
                  //                         suggestion;
                  //                     LauncherAssist.launchApp('1');
                  //                   },
                  //                 ),
                  //               ),
                  //             )),
                  //         !hidden
                  //             ? Expanded(
                  //                 child: ListView.builder(
                  //                 itemCount: installedApps.length,
                  //                 physics: BouncingScrollPhysics(),
                  //                 itemBuilder: (BuildContext context, int i) {
                  //                   allApps.add(installedApps[i]['label']);

                  //                   return Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: ListTile(
                  //                       leading: Image.memory(
                  //                           installedApps[i]['icon']),
                  //                       onTap: () => LauncherAssist.launchApp(
                  //                           installedApps[i]['package']),
                  //                       title: Text(
                  //                         installedApps[i]['label'],
                  //                         style: TextStyle(
                  //                             color: Colors.white,
                  //                             fontSize: 24,
                  //                             fontWeight: FontWeight.bold),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               ))
                  //             : Expanded(

                  //                 child: Align(
                  //                   alignment: Alignment.bottomRight,
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.only(bottom: 30,right:30),
                  //                     child: IconButton(
                  //                       icon: Icon(
                  //                         Icons.grid_view,
                  //                         size: 60,
                  //                         color: Colors.white,
                  //                       ),
                  //                       onPressed: () {
                  //                         setState(() {
                  //                           hidden = false;
                  //                         });
                  //                       },
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                strokeWidth: 10,
              )),
      ),
    );
  }
}
