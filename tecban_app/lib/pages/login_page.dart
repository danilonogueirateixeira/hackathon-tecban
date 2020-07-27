import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tecban_app/controller/controller.dart';
import 'package:tecban_app/utils/util.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);

    controller.getUser();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Image.asset("assets/logo_text.png"),
            ),
            Text(
              'Proteja quem você ama!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(156, 15, 196, 1), fontSize: 24),
            ),
            SizedBox(
              height: 30,
            ),
            Observer(
              builder: (_) {
                if (controller.user != null) {
                  print("Logado com  sucesso ${controller.user.email}");
                  Future.delayed(Duration.zero, () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  });
                }
                return controller.isLogging
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: <Widget>[
                          GoogleSignInButton(
                            text: "Entrar com Google",
                            splashColor: Colors.deepPurple,
                            darkMode: true,
                            onPressed: () {
                              print("Google");
                              controller.handleGoogleSignIn();
                            },
                          ),
                          FacebookSignInButton(
                            text: "Entrar com Facebook",
                            onPressed: () {},
                          ),
                          AppleSignInButton(
                            text: "Entrar com Apple",
                            style: AppleButtonStyle.black,
                            onPressed: () {},
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
