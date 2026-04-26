import 'package:flutter_todo_list_app/config/routes/app_route.dart';
import 'package:flutter_todo_list_app/modules/home/bindings/home_binding.dart';
import 'package:flutter_todo_list_app/modules/home/views/home_view.dart';
import 'package:flutter_todo_list_app/modules/splash/bindings/splash_binding.dart';
import 'package:flutter_todo_list_app/modules/splash/views/splash_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class AppRouting {
  static final route = RouteView.values.map((e) {
    switch (e) {
      case RouteView.splash:
        return GetPage(
          name: "/splash",
          page: () => SplashView(),
          binding: SplashBinding(),
          transition: Transition.noTransition,
        );
      case RouteView.home:
        return GetPage(
          name: "/home",
          page: () => HomeView(),
          transition: Transition.noTransition,
          binding: HomeBinding(),
        );
    }
  }).toList();
}
