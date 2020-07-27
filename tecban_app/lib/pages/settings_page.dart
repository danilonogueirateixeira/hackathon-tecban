import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:tecban_app/controller/controller.dart';
import 'package:tecban_app/model/account_data.dart';

import 'accounts_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key, this.accountData}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();

  final AccountData accountData;
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    Controller controllerGeral = Provider.of<Controller>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(156, 15, 196, 1),
        title: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                widget.accountData.accountOwner.name,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Text(
                widget.accountData.nickName,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
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
                  'Configurações',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 74, 173, 1),
                    fontSize: 32,
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Notificar todas as\ntransferências',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 74, 173, 1),
                            fontSize: 24,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              controllerGeral.isChecked1 =
                                  !controllerGeral.isChecked1;
                            });
                          },
                          child: Center(
                            child: CustomSwitchButton(
                              backgroundColor: Colors.grey.shade400,
                              unCheckedColor: Colors.grey,
                              animationDuration: Duration(milliseconds: 300),
                              checkedColor: Color.fromRGBO(156, 15, 196, 1),
                              checked: controllerGeral.isChecked1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              controllerGeral.isChecked1
                  ? Text(
                      'Ao notificar todas as transferências,qualquer operação dessa natureza deverá ser aprovadas no Co.Bank',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 74, 173, 1),
                        fontSize: 20,
                      ),
                    )
                  : Center(),
              Card(
                elevation: 10,
                child: Container(
                  height: controllerGeral.isChecked2 ? 150 : 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Notificar transferências\nacima de:',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 74, 173, 1),
                                fontSize: 24,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  controllerGeral.isChecked2 =
                                      !controllerGeral.isChecked2;
                                });
                              },
                              child: Center(
                                child: CustomSwitchButton(
                                  backgroundColor: Colors.grey.shade400,
                                  unCheckedColor: Colors.grey,
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  checkedColor: Color.fromRGBO(156, 15, 196, 1),
                                  checked: controllerGeral.isChecked2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        controllerGeral.isChecked2
                            ? TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.monetization_on,
                                    color: Color.fromRGBO(156, 15, 196, 1),
                                    size: 20,
                                  ),
                                  hintText: 'Qual  o limite?',
                                  labelText: 'Limite',
                                ),
                              )
                            : Center()
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Notificar transferências\npara CPF',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 74, 173, 1),
                            fontSize: 24,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              controllerGeral.isChecked3 =
                                  !controllerGeral.isChecked3;
                            });
                          },
                          child: Center(
                            child: CustomSwitchButton(
                              backgroundColor: Colors.grey.shade400,
                              unCheckedColor: Colors.grey,
                              animationDuration: Duration(milliseconds: 300),
                              checkedColor: Color.fromRGBO(156, 15, 196, 1),
                              checked: controllerGeral.isChecked3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Notificar transferências\npara CNPJ',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 74, 173, 1),
                            fontSize: 24,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              controllerGeral.isChecked4 =
                                  !controllerGeral.isChecked4;
                            });
                          },
                          child: Center(
                            child: CustomSwitchButton(
                              backgroundColor: Colors.grey.shade400,
                              unCheckedColor: Colors.grey,
                              animationDuration: Duration(milliseconds: 300),
                              checkedColor: Color.fromRGBO(156, 15, 196, 1),
                              checked: controllerGeral.isChecked4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
