import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/provider/buatPaketSoalProv.dart';
import 'src/provider/buatsoalprov.dart';
import 'src/provider/jawabanprov.dart';
import 'src/provider/materiprov.dart';
import 'src/provider/newloginprov.dart';
import 'src/provider/searchprov.dart';
import 'src/provider/soalRepositoryProv.dart';
import 'src/ui/login/logincasepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'QSmart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => JawabanProv()),
        ChangeNotifierProvider(create: (_) => SearchProv()),
        ChangeNotifierProvider(create: (_) => BuatPaketSoalProv()),
        ChangeNotifierProvider(create: (_) => BuatSoalProv()),
        ChangeNotifierProvider(create: (_) => SoalRepositoryProv()),
        ChangeNotifierProvider(create: (_) => NewLoginProv()),
        ChangeNotifierProvider(create: (_) => MateriProv())

        // ChangeNotifierProvider(
        //   builder: (_)=> UserRepository.instance(),
        // ),
      ],
    );
  }
}

/// Component UI
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 4500), navigatorPage);
  }

  /// To navigate layout change
  void navigatorPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginCasePage()));
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    startTime();
  }

  /// Code Create UI Splash Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/YBfwz.png"), fit: BoxFit.fill)),
          child: Center(
            child: Image.asset(
              "images/logoo.png",
              width: 250,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
