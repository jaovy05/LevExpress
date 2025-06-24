import 'package:flutter/material.dart';
import 'Components/AppFrontend/login_screen.dart';
import 'Components/AppFrontend/register_screen.dart';
import 'Components/AppFrontend/home_screen.dart';
import 'Components/AppFrontend/cadastrar_pacote_screen.dart';
import 'Components/AppFrontend/listar_pacotes_screen.dart';
import 'core/app_cores.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LevExpress',
      theme: ThemeData(
        scaffoldBackgroundColor: AppCores.cardBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppCores.appBarBackground,
          foregroundColor: AppCores.appBarTitle,
          titleTextStyle: TextStyle(
            color: AppCores.appBarTitle,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.5,
            fontFamily: 'Montserrat',
          ),
          iconTheme: IconThemeData(color: AppCores.backButton),
          elevation: 0,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppCores.drawerBackground,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: AppCores.drawerIcon,
          textColor: AppCores.drawerItemText,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: AppCores.body,
              displayColor: AppCores.title,
              fontFamily: 'Montserrat',
            ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: AppCores.inputLabel),
          hintStyle: TextStyle(color: AppCores.inputHint),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppCores.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppCores.inputBorder),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppCores.buttonBackground,
            foregroundColor: AppCores.buttonText,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: AppCores.buttonBackground,
            foregroundColor: AppCores.buttonText,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: const BorderSide(color: AppCores.buttonBackground),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppCores.buttonBackground,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
          ),
        ),
        cardColor: AppCores.cardBackground,
        dividerColor: AppCores.inputBorder,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const Registerscreen(),
        '/home': (context) => const HomeScreen(),
        '/cadastrar-pacote': (context) => const CadastrarPacoteScreen(),
        '/listar-pacotes': (context) => const ListarPacotesScreen(),
      },
    );
  }
}
