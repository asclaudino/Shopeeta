import 'package:flutter/material.dart';
import 'package:shopeeta_frontend/pages/home_page.dart';

import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'pages/signin_page.dart';
import 'pages/home_page.dart';
import 'pages/my_profile_page.dart';
import 'pages/register_product_page.dart';
import 'pages/wait_for_connection_page.dart';
import 'pages/product_detail_page.dart';
import 'models/product_detail_page_arguments.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => const WelcomePage(title: 'Shopeeta'),
    WaitForConnectionPage.pageRouteName: (BuildContext context) =>
        const WaitForConnectionPage(),
    LoginPage.pageRouteName: (BuildContext context) => const LoginPage(),
    SigninPage.pageRouteName: (BuildContext context) => const SigninPage(),
    HomePage.pageRouteName: (BuildContext context) => const HomePage(),
    MyProfilePage.pageRouteName: (BuildContext context) =>
        const MyProfilePage(),
    RegisterProductPage.pageRouteName: (BuildContext context) =>
        const RegisterProductPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopeeta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFEA5158),
          onPrimary: Colors.white,
          secondary: Color(0xFFA43941),
          onSecondary: Colors.white,
          error: Colors.black,
          onError: Colors.red,
          background: Color(0xFFF4F6FC),
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "RobotoFamilyFont",
          ),
          button: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            fontFamily: "RobotoFamilyFont",
          ),
          bodyText1: TextStyle(
            fontFamily: "RobotoFamilyFont",
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          headline2: TextStyle(
            fontFamily: "RobotoFamilyFont",
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      routes: _routes,
      onGenerateRoute: (settings) {
        if (settings.name == ProductDetailPage.pageRouteName) {
          final args = settings.arguments as ProductDetailPageArguments;
          return MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: args.product,
              imageUrl: args.imageUrl,
            ),
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
