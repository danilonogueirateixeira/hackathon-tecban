import 'package:dio/dio.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tecban_app/model/account_data.dart';
import 'package:tecban_app/model/account_owner.dart';
import 'package:tecban_app/model/user.dart';
import 'package:tecban_app/utils/util.dart';

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
  String initialUrl;

  @observable
  String codeUrl;

  @observable
  List<AccountData> accounts = [];

  @observable
  bool loadingUrl = false;

  @observable
  String accessToken;

  @observable
  String consentId;

  @observable
  bool isChecked1 = false;

  @observable
  bool isChecked2 = false;

  @observable
  bool isChecked3 = false;

  @observable
  bool isChecked4 = false;

  @observable
  String transactionId = '';
  @observable
  String transactionValue = '';

  @observable
  String transactionInformation = '';

  @observable
  bool newTransaction = false;

  List<AccountData> testAccounts = [
    AccountData("5f186cbb3c2f923af914337a", "xxxx1001",
        AccountOwner("Joaquim Clemente", "01237001001")),
    AccountData("5f186cbc3c2f923af91434c3", "xxxx1002",
        AccountOwner("Joaquim Clemente", "01237001002")),
    AccountData("5f186cbe3c2f923af914360c", "xxxx1003",
        AccountOwner("Joaquim Clemente", "01237001003"))
  ];

  @observable
  List<String> protegidos = [];

  @action
  saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user.email);
    await prefs.setString('name', user.name);
    await prefs.setString('photo', user.photo);
  }

  @action
  saveData(String accessToken, String consentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('consentId', consentId);
  }

  @action
  saveTransaction(String transactionId, String transactionInformation,
      String transactionValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('transactionId', transactionId);
    await prefs.setString('transactionInformation', transactionInformation);
    await prefs.setString('transactionValue', transactionValue);
  }

  @action
  getTransaction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('transactionId') != null &&
        prefs.getString('transactionInformation') != null &&
        prefs.getString('transactionInformation') != null) {
      transactionId = prefs.getString('transactionId');
      transactionInformation = prefs.getString('transactionInformation');
      transactionValue = prefs.getString('transactionValue');

      print("-------- TRANSACTION GET: $transactionId");
    } else {
      print("-------- TRANSACTION: NULL");
    }
  }

  @action
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('accessToken') != null &&
        prefs.getString('consentId') != null) {
      accessToken = prefs.getString('accessToken');
      consentId = prefs.getString('consentId');

      print("--------  accessToken GET: $accessToken");
      print("--------  consentId GET: $consentId");
    } else {
      print("-------- USER accessToken: NULL");
    }
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
    prefs.remove('accessToken');
    prefs.remove('consentId');

    user = null;
  }

  Dio dio;

  init() {
    BaseOptions options = new BaseOptions(
      baseUrl: "https://hackathon-tecban.azurewebsites.net/openbanking",
      //baseUrl: "http://192.168.0.109:3001",

      connectTimeout: 50000,
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
    loadingUrl = true;

    init();
    try {
      Response response = await dio.get("/get-url/bank1");
      print("LOG - AUTH - DATA -> ${response.data}");
      print("LOG - AUTH - CODE -> ${response.statusCode}");

      if (response.data['success'] == true) {
        initialUrl = response.data['result']['urlAuthentication'];
        accessToken = response.data['result']['accessToken'];
        consentId = response.data['result']['consentId'];
        await saveData(accessToken, consentId);
      } else {
        loadingUrl = false;
        initialUrl = "error";
      }
    } on DioError catch (e) {
      print("LOG - AUTH- ERROR CODE -> ${e.response.statusCode}");
      print("LOG - AUTH - ERROR MESSAGE -> ${e.message}");
      loadingUrl = false;
      initialUrl = "error";
      if (e.response.statusCode == 404) {
        print("LOG - AUTH - ERROR RESPONSE -> ${e.response.data}");
      } else {
        print("LOG - AUTH - ERROR REQUEST -> ${e.request.data}");
      }
    }
  }

  @action
  setConsent(url) async {
    await getData();
    init();
    try {
      Response response = await dio.post(
        "/set-consent/bank1",
        data: {"AccessToken": accessToken, "ConsentId": url},
      );
      print("LOG - CONSENT - DATA -> ${response.data}");
      print("LOG - CONSENT - CODE -> ${response.statusCode}");
      if (response.data['success'] == true) {
        await saveData(response.data['result']['accessToken'], consentId);
        getAccounts();
      }
    } on DioError catch (e) {
      print("LOG - CONSENT- ERROR CODE -> ${e.response.statusCode}");
      print("LOG - CONSENT - ERROR MESSAGE -> ${e.message}");
      if (e.response.statusCode == 404) {
        print("LOG - CODE - ERROR RESPONSE -> ${e.response.data}");
      } else {
        print("LOG - CODE - ERROR REQUEST -> ${e.request.data}");
      }
    }
  }

  @action
  getAccounts() async {
    await getData();
    init();
    try {
      Response response = await dio.get(
        "/get-accounts/bank1/" + accessToken,
      );

      if (response.data['success'] == true) {
        print(
            "CONTA-> ${response.data['result']['data']['account'][0]['accountId']}");
        print(
            "CONTA-> ${response.data['result']['data']['account'][0]['nickname']}");
        print(
            "CONTA-> ${response.data['result']['data']['account'][0]['account'][0]['name']}");
        print(
            "CONTA-> ${response.data['result']['data']['account'][0]['account'][0]['identification']}");
      }

      for (int i = 0; i < 3; i++) {
        accounts.add(AccountData(
            response.data['result']['data']['account'][i]['accountId'],
            response.data['result']['data']['account'][i]['nickname'],
            AccountOwner(
                response.data['result']['data']['account'][i]['account'][0]
                    ['name'],
                response.data['result']['data']['account'][i]['account'][0]
                    ['identification'])));
        protegidos.add(response.data['result']['data']['account'][i]['account']
            [0]['name']);
      }
      var distinctIds = protegidos.toSet().toList();

      protegidos = distinctIds;
      loadingUrl = false;

      print("LOG - CODE - CODE -> ${response.statusCode}");
      print("LOG - CODE - QTD CONTAS -> ${accounts.length}");
    } on DioError catch (e) {
      print("LOG - CODE- ERROR CODE -> ${e.response.statusCode}");
      print("LOG - CODE - ERROR MESSAGE -> ${e.message}");
      if (e.response.statusCode == 404) {
        print("LOG - CODE - ERROR RESPONSE -> ${e.response.data}");
      } else {
        print("LOG - CODE - ERROR REQUEST -> ${e.request.data}");
      }
    }
  }

  @action
  getLastTransaction() async {
    await getTransaction();
    init();
    try {
      Response response =
          await dio.get("/get-last-transaction/bank1/" + accessToken);
      print("LOG - TRANSACTION - DATA -> ${response.data}");
      print("LOG - TRANSACTION -> ${response.statusCode}");

      if (response.data['success'] == true) {
        if (transactionId == response.data['result']['transactionId']) {
          newTransaction = false;
        } else {
          newTransaction = true;

          transactionId = response.data['result']['transactionId'];
          transactionValue = response.data['result']['amount']['amount'];
          transactionInformation =
              response.data['result']['transactionInformation'];
          await saveTransaction(
              transactionId, transactionInformation, transactionValue);
        }
      } else {}
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
}
