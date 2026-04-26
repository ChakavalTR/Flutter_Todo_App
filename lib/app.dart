import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/routes/app_page.dart';
import 'package:flutter_todo_list_app/config/routes/app_route.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/core/services/local_service.dart';
import 'package:flutter_todo_list_app/modules/splash/bindings/splash_binding.dart';
import 'package:get/route_manager.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        LocalServiceStorage.instance.getBool('dark_mode') == true;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      //! Theme Mode
      theme: AppTheme.lightTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: AppTheme.darkTheme,

      //! Routing
      getPages: AppRouting.route,
      initialRoute: RouteView.splash.name,
      initialBinding: SplashBinding(),
    );
  }
}
