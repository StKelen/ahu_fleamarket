import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/config/theme.dart';
import 'routers/index.dart';
import 'routers/routes.dart';

import 'provider/global.dart';
import 'pages/index.dart';

void main() {
  runApp(ChangeNotifierProvider<GlobalModel>(
    lazy: false,
    create: (_) => GlobalModel(),
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Routes.configureRoutes(MyRouter.router);
    Provider.of<GlobalModel>(context, listen: false).init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: MyRouter.router.generator,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Themes.primaryColor,
        primaryColorBrightness: Brightness.dark,
        accentColor: Themes.accentColor,
        dividerColor: Themes.accentColor,
        backgroundColor: Themes.pageBackgroundColor,
        scaffoldBackgroundColor: Themes.pageBackgroundColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white70),
          caption: TextStyle(
            color: Themes.textSecondaryColor,
          ),
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: Themes.textPrimaryColor),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Themes.primaryColor),
        ),
      ),
      home: IndexPage(),
    );
  }
}
