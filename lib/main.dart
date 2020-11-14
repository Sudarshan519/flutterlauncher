import 'package:flutter/material.dart';
import 'package:launcher_assist/launcher_assist.dart';
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
  var wallpaper;
  bool accessStorage;
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
      }
    } else if (status.isRestricted) {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (accessStorage) {
      setState(() {});
    }
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.08),
        body: installedApps != null
            ? Stack(
                children: [
                  wallpaper != null
                      ? Image.memory(wallpaper, fit: BoxFit.cover)
                      : Container(),
                  ListView.builder(
                    itemCount: installedApps.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.memory(installedApps[i]['icon']),
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
                  )
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
