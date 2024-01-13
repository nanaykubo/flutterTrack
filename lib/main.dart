import 'package:flutter/material.dart';

import 'package:background_locator_2/background_locator.dart';
import 'package:location_permissions/location_permissions.dart';

import 'package:logitrack/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    if (permission == PermissionStatus.granted) {
      print('w/ location');
    } else {
      print('no location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey.shade400,
          ),
          colorScheme: const ColorScheme.light().copyWith(
            background: Colors.white,
          ),
          primarySwatch: Colors.grey,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.grey,
              selectionColor: Colors.blueGrey.shade100,
              selectionHandleColor: Colors.grey),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200)),
          )),
      home: HomePage(),
    );
  }
}
