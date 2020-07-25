// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Controller on ControllerBase, Store {
  final _$userAtom = Atom(name: 'ControllerBase.user');

  @override
  User get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$isLoggingAtom = Atom(name: 'ControllerBase.isLogging');

  @override
  bool get isLogging {
    _$isLoggingAtom.reportRead();
    return super.isLogging;
  }

  @override
  set isLogging(bool value) {
    _$isLoggingAtom.reportWrite(value, super.isLogging, () {
      super.isLogging = value;
    });
  }

  final _$saveUserAsyncAction = AsyncAction('ControllerBase.saveUser');

  @override
  Future saveUser(User user) {
    return _$saveUserAsyncAction.run(() => super.saveUser(user));
  }

  final _$getUserAsyncAction = AsyncAction('ControllerBase.getUser');

  @override
  Future getUser() {
    return _$getUserAsyncAction.run(() => super.getUser());
  }

  final _$deleteUserAsyncAction = AsyncAction('ControllerBase.deleteUser');

  @override
  Future deleteUser() {
    return _$deleteUserAsyncAction.run(() => super.deleteUser());
  }

  final _$createLoginAsyncAction = AsyncAction('ControllerBase.createLogin');

  @override
  Future createLogin(String nome, String email, String senha) {
    return _$createLoginAsyncAction
        .run(() => super.createLogin(nome, email, senha));
  }

  final _$googleLogoutAsyncAction = AsyncAction('ControllerBase.googleLogout');

  @override
  Future googleLogout() {
    return _$googleLogoutAsyncAction.run(() => super.googleLogout());
  }

  final _$handleGoogleSignInAsyncAction =
      AsyncAction('ControllerBase.handleGoogleSignIn');

  @override
  Future handleGoogleSignIn() {
    return _$handleGoogleSignInAsyncAction
        .run(() => super.handleGoogleSignIn());
  }

  @override
  String toString() {
    return '''
user: ${user},
isLogging: ${isLogging}
    ''';
  }
}
