import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_ott_app/controllers/movie_controller.dart';
import 'package:video_ott_app/utils/size_config.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:video_ott_app/views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MovieController>(create: (_) => MovieController()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().initFromConstraints(constraints, orientation);
            return MaterialApp(
              builder: (context, child) => ResponsiveWrapper.builder(
                  BouncingScrollWrapper.builder(context, child!),
                  maxWidth: 1200,
                  minWidth: 480,
                  defaultScale: true,
                  breakpoints: [
                    const ResponsiveBreakpoint.resize(480, name: MOBILE),
                    const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                    const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                    const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                    const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
                  ],
                  background: Container(color: const Color(0xFFF5F5F5))),
              debugShowCheckedModeBanner: false,
              title: 'OTT App',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  fontFamily: 'Roboto',
                  visualDensity: VisualDensity.adaptivePlatformDensity),
              home: const HomeScreen(),
            );
          },
        );
      },
    );
  }
}
