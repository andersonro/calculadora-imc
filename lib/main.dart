import 'package:calculadora_imc/my_app.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await path_provider.getApplicationDocumentsDirectory();
  runApp(const MyApp());
}
