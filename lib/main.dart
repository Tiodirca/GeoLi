import 'package:flutter/material.dart';
import 'package:geoli/Uteis/constantes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'Uteis/rotas.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Constantes.rotaTelaSplashScreen,
      onGenerateRoute: Rotas.generateRoute,
    );
  }
}
