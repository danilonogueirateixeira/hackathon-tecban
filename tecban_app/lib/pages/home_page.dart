import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tecban_app/controller/controller.dart';
import 'package:tecban_app/pages/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Sair"),
          onPressed: () async {
            await controller.googleLogout();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
    );
  }
}
