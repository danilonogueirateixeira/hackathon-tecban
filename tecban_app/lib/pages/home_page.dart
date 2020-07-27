import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tecban_app/controller/controller.dart';
import 'package:tecban_app/pages/accounts_page.dart';
import 'package:tecban_app/pages/consent_page.dart';
import 'package:tecban_app/pages/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Controller controllerGeral = Provider.of<Controller>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              height: 50,
            ),
            Text(
              '     CO.',
              style: TextStyle(
                  color: Color.fromRGBO(156, 15, 196, 1), fontSize: 24),
            ),
            Text(
              'BANK',
              style: TextStyle(
                color: Color.fromRGBO(0, 74, 173, 1),
                fontSize: 32,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Observer(
          builder: (_) {
            if (controllerGeral.protegidos.length > 0) {
              Timer.periodic(const Duration(seconds: 10), (timer) async {
                await controllerGeral.getLastTransaction();
                if (controllerGeral.newTransaction) {
                  print("------------- NOVA TRANSACTION -------");
                  print("------------- ${controllerGeral.transactionId}");
                  print("------------- ${controllerGeral.transactionValue}");
                  print(
                      "------------- ${controllerGeral.transactionInformation}");
                } else {
                  print("------------- NADA");
                  print("------------- NOVA TRANSACTION -------");
                  print("------------- ${controllerGeral.transactionId}");
                  print("------------- ${controllerGeral.transactionValue}");
                  print(
                      "------------- ${controllerGeral.transactionInformation}");
                }
              });
            }
            return controllerGeral.protegidos.length > 0
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Protegidos',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 74, 173, 1),
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: controllerGeral.protegidos.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Card(
                                  elevation: 10,
                                  child: ClipPath(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountsPage()),
                                        );
                                      },
                                      child: Container(
                                        height: 90,
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(156, 15, 196, 1),
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    156, 15, 196, 1),
                                                width: 0.3)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  controllerGeral
                                                      .protegidos[index],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24),
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.navigate_next,
                                              color: Colors.white,
                                              size: 50,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Observer(
                        builder: (_) {
                          return controllerGeral.loadingUrl
                              ? CircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, right: 8, left: 8),
                                  child: RaisedButton(
                                      color: Color.fromRGBO(156, 15, 196, 1),
                                      child: Text(
                                        'Cadastrar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 24),
                                      ),
                                      onPressed: () {
                                        controllerGeral.getUrl().whenComplete(
                                          () {
                                            if (controllerGeral.initialUrl !=
                                                'error') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConsentPage(
                                                          url: controllerGeral
                                                              .initialUrl,
                                                        )),
                                              );
                                            }
                                          },
                                        );
                                      }),
                                );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16, right: 16, left: 8),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            child: Text(
                              'Sair',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                            onTap: () async {
                              await controllerGeral.googleLogout();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16, right: 16, left: 8),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            child: Text(
                              '5',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                            onTap: () async {
                              showAlertDialog1(
                                  context,
                                  controllerGeral.transactionInformation,
                                  controllerGeral.transactionValue);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, right: 8, left: 8),
                        child: Text(
                          'Você ainda não possui nenhum protegido cadastrado, mantenha as contas de quem você ama seguras agora mesmo, clique em cadastrar e diminua os riscos de fraudes!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(156, 15, 196, 1),
                              fontSize: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset('assets/golpe.jpg'),
                      ),
                      Observer(
                        builder: (_) {
                          return controllerGeral.loadingUrl
                              ? CircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, right: 8, left: 8),
                                  child: RaisedButton(
                                      color: Color.fromRGBO(156, 15, 196, 1),
                                      child: Text(
                                        'Cadastrar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 24),
                                      ),
                                      onPressed: () {
                                        controllerGeral.getUrl().whenComplete(
                                          () {
                                            if (controllerGeral.initialUrl !=
                                                'error') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConsentPage(
                                                          url: controllerGeral
                                                              .initialUrl,
                                                        )),
                                              );
                                            }
                                          },
                                        );
                                      }),
                                );
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16, right: 16, left: 8),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            child: Text(
                              'Sair',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                            onTap: () async {
                              await controllerGeral.googleLogout();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                          ),
                        ),
                      ),

                      // Center(
                      //   child: RaisedButton(
                      //     child: Text("Auth"),
                      //     onPressed: () async {
                      //       controller.getUrl();
                      //       // Navigator.pushReplacement(
                      //       //   context,
                      //       //   MaterialPageRoute(builder: (context) => LoginPage()),
                      //       // );
                      //     },
                      //   ),
                      // ),
                      // Observer(
                      //   builder: (_) {
                      //     return controller.initialUrl == null
                      //         ? Center()
                      //         : controller.codeUrl != null
                      //             ? Text("Autenticado ${controller.codeUrl}")
                      //             : Expanded(
                      //                 child: WebviewScaffold(
                      //                   url: controller.initialUrl,
                      //                   withJavascript: true,
                      //                   withZoom: false,
                      //                   hidden: true,
                      //                   appBar:
                      //                       AppBar(title: Text("Flutter"), elevation: 1),
                      //                 ),
                      //               );
                      //   },
                      // ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  showAlertDialog1(BuildContext context, title, contents) {
    // configura o button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );
    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: title,
      content: contents,
      actions: [
        okButton,
      ],
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }
}
