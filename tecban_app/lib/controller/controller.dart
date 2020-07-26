import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecban_app/model/user.dart';
import 'package:tecban_app/utils/util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'controller.g.dart';

//flutter pub run build_runner build
//flutter pub run build_runner clean

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store {
  Util util = Util();

  @observable
  User user;

  @observable
  bool isLogging = false;

  @observable
  String url;

  @action
  saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user.email);
    await prefs.setString('name', user.name);
    await prefs.setString('photo', user.photo);
  }

  @action
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('name') != null &&
        prefs.getString('email') != null &&
        prefs.getString('photo') != null) {
      user = User(prefs.getString('name'), prefs.getString('email'),
          prefs.getString('photo'));

      print("-------- USER NAME GET: ${user.name}");
      print("-------- USER EMAIL GET: ${user.email}");
      print("-------- USER PHOTO GET: ${user.photo}");
    } else {
      print("-------- USER GET: NULL");
    }
  }

  @action
  deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('photo');

    user = null;
  }

  Dio dio;

  init() {
    BaseOptions options = new BaseOptions(
      baseUrl: "http://192.168.0.109:3001",
      connectTimeout: 5000,
    );
    dio = new Dio(options);
  }

  @action
  createLogin(String nome, String email, String senha) async {
    try {
      Response response = await dio.post("/users/",
          data: {"name": nome, "email": email, "password": senha});
      print("LOG - CREATE LOGIN - DATA -> ${response.data}");
      print("LOG - CREATE LOGIN - CODE -> ${response.statusCode}");
    } on DioError catch (e) {
      print("LOG - CREATE LOGIN - ERROR CODE -> ${e.response.statusCode}");
      print("LOG - CREATE LOGIN - ERROR MESSAGE -> ${e.message}");
      if (e.response.statusCode == 404) {
        print("LOG - CREATE LOGIN - ERROR RESPONSE -> ${e.response.data}");
      } else {
        print("LOG - CREATE LOGIN - ERROR REQUEST -> ${e.request.data}");
      }
    }
  }

  //** LOGIN WITH GOOGLE *********************************************************************************/
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  @action
  googleLogout() async {
    await _googleSignIn.signOut();
    await deleteUser();
  }

  @action
  handleGoogleSignIn() async {
    isLogging = true;
    try {
      await _googleSignIn.signIn().then((value) async {
        print(value.displayName);
        print(value.email);
        user = User(value.displayName, value.email, value.photoUrl);
        await saveUser(user);

        isLogging = false;
      });
    } catch (error) {
      isLogging = false;
      print(error);
      print("Não foi possível realizar o Login, tente novamente!");
    }
  }

  @action
  getUrl() async {
    init();
    try {
      Response response = await dio.get("/get-url");
      print("LOG - AUTH - DATA -> ${response.data['url-access']}");
      print("LOG - AUTH - CODE -> ${response.statusCode}");
      url = response.data['url-access'];
      //url = 'https://www.google.com.br/';
    } on DioError catch (e) {
      print("LOG - AUTH- ERROR CODE -> ${e.response.statusCode}");
      print("LOG - AUTH - ERROR MESSAGE -> ${e.message}");
      if (e.response.statusCode == 404) {
        print("LOG - AUTH - ERROR RESPONSE -> ${e.response.data}");
      } else {
        print("LOG - AUTH - ERROR REQUEST -> ${e.request.data}");
      }
    }
  }

  openBrowserTab(url) async {
    await FlutterWebBrowser.openWebPage(
        url: url, androidToolbarColor: Colors.deepPurple);
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
