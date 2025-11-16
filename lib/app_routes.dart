import 'package:flutter/material.dart';
import 'main.dart';
import 'cadastro_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'main_page.dart';
import 'user_points_list_page.dart';
import 'create_point_page.dart';
import 'edit_point_page.dart';

class AppRoutes {
  static const String main = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String home = '/home';

  static const String userPointsList = '/points-list';
  static const String createPoint = '/create-point';
  static const String editPoint = "/edit-point";

  static final Map<String, WidgetBuilder> routes = {
    main: (context) => const MainPage(),
    login: (context) => const LoginPage(),
    cadastro: (context) => const CadastroPage(),
    home: (context) => const HomePage(),
    userPointsList: (context) => const UserPointsListPage(),
    createPoint: (context) => const CreatePointPage(),  
    editPoint: (context) => const EditPointPage(),
  };
}