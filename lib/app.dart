import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/routes/app_page.dart';
import 'package:flutter_todo_list_app/config/routes/app_route.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/modules/home/bindings/home_binding.dart';
import 'package:get/route_manager.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      //! Theme Mode
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      darkTheme: AppTheme.lightTheme,

      //! Routing
      getPages: AppRouting.route,
      initialRoute: RouteView.home.name,
      initialBinding: HomeBinding(),
    );
  }
}
