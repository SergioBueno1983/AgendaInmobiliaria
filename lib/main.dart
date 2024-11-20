import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:obligatorio_flutter/utilidades/plataforma.dart';
import 'package:obligatorio_flutter/utilidades/rutas/rutas.dart';
// import 'package:dcdg/decg.dart'

void main() {
  runApp(const InmoApp());
}

class InmoApp extends StatelessWidget {
  const InmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Plataforma(
      androidBuilder: (context) {
        // Contenido específico para Android
        return MaterialApp(
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [
            Locale('en'),
            Locale('es')
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale != null) {
              for (var sl in supportedLocales) {
                if (sl.languageCode == locale.languageCode) {
                  return sl;
                }
              }
            }
            return supportedLocales.first;
          },       
          debugShowCheckedModeBanner: false,
          title: 'Inmobiliaria Bios (Android)',
          routes: Rutas.rutas,
          initialRoute: Rutas.rutaInicial,
        );
      },
      iOSBuilder: (context) {
        // Contenido específico para iOS
        return CupertinoApp(
          localizationsDelegates: GlobalCupertinoLocalizations.delegates,
          supportedLocales: const [
            Locale('en'),
            Locale('es')
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale != null) {
              for (var sl in supportedLocales) {
                if (sl.languageCode == locale.languageCode) {
                  return sl;
                }
              }
            }
            return supportedLocales.first;
          },       
          debugShowCheckedModeBanner: false,
          title: 'Inmobiliaria Bios (iOS)',
          home: const CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Inmobiliaria Bios (iOS)'),
            ),
            
            child: Center(
              child: Text('Contenido específico para iOS'),
            ),
          ),
        );
      },
    );
  }
}