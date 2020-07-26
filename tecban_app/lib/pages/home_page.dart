import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:tecban_app/controller/controller.dart';
import 'package:tecban_app/pages/login_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  StreamSubscription<WebViewStateChanged> _onchanged;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onchanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.finishLoad) {
          print("---- ${state.url}");
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
    Controller controller = Provider.of<Controller>(context);
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
          Center(
            child: RaisedButton(
              child: Text("Testar"),
              onPressed: () async {
                _controller.future.then((value) {
                  value.currentUrl().then((value) {
                    print(value);
                  });
                });
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginPage()),
                // );
              },
            ),
          ),
          Expanded(
            child: WebviewScaffold(
              url:
                  "https://auth1.tecban-sandbox.o3bank.co.uk/auth?client_id=64dc16df-3cc3-44e5-b05e-7593108038ba&response_type=code&scope=openid%20accounts&request=eyJhbGciOiJub25lIn0.eyJhdWQiOiJodHRwczovL2F1dGgxLnRlY2Jhbi1zYW5kYm94Lm8zYmFuay5jby51ayIsImV4cCI6MTU5NTc0MDU0Ny4zOCwiaXNzIjoiNjRkYzE2ZGYtM2NjMy00NGU1LWIwNWUtNzU5MzEwODAzOGJhIiwic2NvcGUiOiJvcGVuaWQgYWNjb3VudHMiLCJyZWRpcmVjdF91cmkiOiJodHRwOi8vd3d3Lmdvb2dsZS5jby51ayIsIm5vbmNlIjoiMTMzNTQ1NjUtNzAxOC00ZTIyLThhZDMtNDNmMTNhM2Y4YjM0Iiwic3RhdGUiOiIwODc1NTQyNS1mZGQ1LTQ2M2ItOWJhOS1mMjMzZDU4ODQ2ZmEiLCJjbGFpbXMiOnsiaWRfdG9rZW4iOnsib3BlbmJhbmtpbmdfaW50ZW50X2lkIjp7InZhbHVlIjoiYWFjLTVjY2EwY2YwLTdhMDQtNGFmNS04OTA0LWU3Y2JlYzhjMDllZSIsImVzc2VudGlhbCI6dHJ1ZX19fX0.",
              withJavascript: true,
              withZoom: false,
              hidden: true,
              appBar: AppBar(title: Text("Flutter"), elevation: 1),
            ),
          ),
          Observer(
            builder: (_) {
              return controller.url == null
                  ? Center()
                  : controller.url.contains("danilo")
                      ? Text("Autenticado ${controller.url}")
                      : Expanded(
                          child: WebViewPlus(
                            initialUrl: controller.url,
                            onWebViewCreated: (controllerWeb) {
                              controllerWeb.loadUrl(controller.url);
                            },
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}
