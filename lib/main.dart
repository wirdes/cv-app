import 'package:flutter/material.dart';
import 'package:merterim_dev_cv_app/screen/windows_screen.dart';
import 'package:merterim_dev_cv_app/components/view_container.dart';
import 'package:merterim_dev_cv_app/models/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeModel())],
      child: Consumer<ThemeModel>(builder: (context, theme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: theme.getCurrentTheme,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: WindowsScreen(
              child: ViewContainer(
            desktop: Container(),
            mobile: Container(),
          )),
        );
      }),
    );
  }
}
