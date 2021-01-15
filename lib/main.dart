import 'package:flea_market/common/config/theme.dart';
import 'package:flutter/material.dart';

import 'routers/index.dart';
import 'routers/routes.dart';
import 'pages/index.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Routes.configureRoutes(MyRouter.router);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: MyRouter.router.generator,
      theme: ThemeData(
          brightness: Brightness.light, primaryColor: Themes.primaryColor),
      home: IndexPage(),
    );
  }
}
