import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/app.dart';
import 'package:flutter_todo_list_app/core/services/local_service.dart';

Future<void> main() async {
  //! Local Storage Initialize
  WidgetsFlutterBinding.ensureInitialized();
  await LocalServiceStorage.instance.init(); //* For Local Storage Initialize
  await Future.delayed(
    Duration(milliseconds: 2200),
  ); //* For splash screen delay
  runApp(App());
}
