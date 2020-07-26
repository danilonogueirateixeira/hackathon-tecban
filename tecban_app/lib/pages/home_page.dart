import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:tecban_app/controller/controller.dart';
import 'package:tecban_app/pages/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<WebViewStateChanged> _onchanged;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  Controller controller = Controller();

  @override
  void initState() {
    super.initState();
    _onchanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.finishLoad) {
          if (state.url.contains("google") &&
              state.url.contains("code") &&
              state.url.contains("state")) {
            controller.codeUrl =
                state.url.split('=')[1].replaceAll('&state', '');
            controller.sendCode();
          }
          print("---- ${state.url.split('=')[1].replaceAll('&state', '')}");
          print("loaded...");
        } else if (state.type == WebViewState.abortLoad) {
          // if there is a problem with loading the url
          print("there is a problem...");
        } else if (state.type == WebViewState.startLoad) {
          // if the url started loading
          print("start loading...");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(const Duration(seconds: 1), (timer) {

    // if (controller.url != null) {
    //   if (controller.url.contains('danilo')) {
    //     timer.cancel();
    //   } else {
    //     _controller.future.then((value) {
    //       value.currentUrl().then((value) {
    //         print(value);
    //         controller.url = value;
    //       });
    //     });
    //   }
    // }
    // });

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
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
          Center(
            child: RaisedButton(
              child: Text("Auth"),
              onPressed: () async {
                controller.getUrl();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginPage()),
                // );
              },
            ),
          ),
          Observer(
            builder: (_) {
              return controller.initialUrl == null
                  ? Center()
                  : controller.codeUrl != null
                      ? Text("Autenticado ${controller.codeUrl}")
                      : Expanded(
                          child: WebviewScaffold(
                            url: controller.initialUrl,
                            withJavascript: true,
                            withZoom: false,
                            hidden: true,
                            appBar:
                                AppBar(title: Text("Flutter"), elevation: 1),
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}
