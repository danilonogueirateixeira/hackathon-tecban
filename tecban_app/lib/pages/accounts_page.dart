import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tecban_app/controller/controller.dart';
import 'package:tecban_app/pages/settings_page.dart';

class AccountsPage extends StatefulWidget {
  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    Controller controllerGeral = Provider.of<Controller>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(156, 15, 196, 1),
        title: Text(
          controllerGeral.protegidos[0],
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Observer(
        builder: (_) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Contas Seguras',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 74, 173, 1),
                    fontSize: 32,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: controllerGeral.accounts.length,
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
                                      builder: (context) => SettingsPage(
                                            accountData:
                                                controllerGeral.accounts[index],
                                          )),
                                );
                              },
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(
                                    //color: Color.fromRGBO(156, 15, 196, 1),
                                    border: Border.all(
                                        color: Color.fromRGBO(156, 15, 196, 1),
                                        width: 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          controllerGeral
                                              .accounts[index].nickName,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  156, 15, 196, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.settings,
                                        color: Color.fromRGBO(156, 15, 196, 1),
                                        size: 30,
                                      ),
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
            ],
          );
        },
      ),
    );
  }
}
