import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:tecban_app/controller/controller.dart';

import 'home_page.dart';

class ConsentPage extends StatefulWidget {
  const ConsentPage({Key key, this.url}) : super(key: key);

  @override
  _ConsentPageState createState() => _ConsentPageState();

  final String url;
}

class _ConsentPageState extends State<ConsentPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onchanged;
  //Controller controller = Controller();
  bool validation = false;

  @override
  void initState() {
    super.initState();
    // _onchanged =
    //     flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
    //   if (mounted) {
    //     if (state.type == WebViewState.finishLoad) {
    //       if (state.url.contains("google") &&
    //           state.url.contains("code") &&
    //           state.url.contains("state") &&
    //           validation == false) {
    //         controller.codeUrl =
    //             state.url.split('=')[1].replaceAll('&state', '');
    //         controller
    //             .setConsent(state.url.split('=')[1].replaceAll('&state', '')).whenComplete(() {

    //             });
    //         Navigator.pop(context);
    //         validation = true;
    //       }
    //       if (state.url.contains("access_denied") && validation == false) {
    //         Navigator.pop(context);
    //         validation = true;
    //       }

    //       print("---- ${state.url}");
    //       print("loaded...");
    //     } else if (state.type == WebViewState.abortLoad) {
    //       // if there is a problem with loading the url
    //       print("there is a problem...");
    //     } else if (state.type == WebViewState.startLoad) {
    //       // if the url started loading
    //       print("start loading...");
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    Controller controllerGeral = Provider.of<Controller>(context);
    _onchanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.finishLoad) {
          if (state.url.contains("google") &&
              state.url.contains("code") &&
              state.url.contains("state") &&
              validation == false) {
            controllerGeral.codeUrl =
                state.url.split('=')[1].replaceAll('&state', '');
            controllerGeral
                .setConsent(state.url.split('=')[1].replaceAll('&state', ''))
                .whenComplete(() {});
            Navigator.pop(context);
            validation = true;
          }
          if (state.url.contains("access_denied") && validation == false) {
            Navigator.pop(context);
            validation = true;
          }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(156, 15, 196, 1),
        title: Text("Autorização"),
      ),
      body: WebviewScaffold(
        url: widget.url,
        withJavascript: true,
        withZoom: false,
        hidden: true,
      ),
    );
  }
}
