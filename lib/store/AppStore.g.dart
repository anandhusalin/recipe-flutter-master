// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  Computed<bool>? _$isAdminComputed;

  @override
  bool get isAdmin => (_$isAdminComputed ??=
          Computed<bool>(() => super.isAdmin, name: '_AppStore.isAdmin'))
      .value;
  Computed<bool>? _$isDemoAdminComputed;

  @override
  bool get isDemoAdmin =>
      (_$isDemoAdminComputed ??= Computed<bool>(() => super.isDemoAdmin,
              name: '_AppStore.isDemoAdmin'))
          .value;

  final _$isLoaderAtom = Atom(name: '_AppStore.isLoader');

  @override
  bool get isLoader {
    _$isLoaderAtom.reportRead();
    return super.isLoader;
  }

  @override
  set isLoader(bool value) {
    _$isLoaderAtom.reportWrite(value, super.isLoader, () {
      super.isLoader = value;
    });
  }

  final _$isLoggedInAtom = Atom(name: '_AppStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$userNameAtom = Atom(name: '_AppStore.userName');

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  final _$tokenAtom = Atom(name: '_AppStore.token');

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  final _$userIdAtom = Atom(name: '_AppStore.userId');

  @override
  int get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$userRoleAtom = Atom(name: '_AppStore.userRole');

  @override
  String get userRole {
    _$userRoleAtom.reportRead();
    return super.userRole;
  }

  @override
  set userRole(String value) {
    _$userRoleAtom.reportWrite(value, super.userRole, () {
      super.userRole = value;
    });
  }

  final _$userEmailAtom = Atom(name: '_AppStore.userEmail');

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  final _$isDarkModeAtom = Atom(name: '_AppStore.isDarkMode');

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  final _$selectedLanguageCodeAtom =
      Atom(name: '_AppStore.selectedLanguageCode');

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  final _$appBarThemeAtom = Atom(name: '_AppStore.appBarTheme');

  @override
  AppBarTheme get appBarTheme {
    _$appBarThemeAtom.reportRead();
    return super.appBarTheme;
  }

  @override
  set appBarTheme(AppBarTheme value) {
    _$appBarThemeAtom.reportWrite(value, super.appBarTheme, () {
      super.appBarTheme = value;
    });
  }

  final _$setUserEmailAsyncAction = AsyncAction('_AppStore.setUserEmail');

  @override
  Future<void> setUserEmail(String val, {bool isInitialization = false}) {
    return _$setUserEmailAsyncAction
        .run(() => super.setUserEmail(val, isInitialization: isInitialization));
  }

  final _$setRoleAsyncAction = AsyncAction('_AppStore.setRole');

  @override
  Future<void> setRole(String val, {bool isInitialization = false}) {
    return _$setRoleAsyncAction
        .run(() => super.setRole(val, isInitialization: isInitialization));
  }

  final _$setUserIDAsyncAction = AsyncAction('_AppStore.setUserID');

  @override
  Future<void> setUserID(int val, {bool isInitialization = false}) {
    return _$setUserIDAsyncAction
        .run(() => super.setUserID(val, isInitialization: isInitialization));
  }

  final _$setTokenAsyncAction = AsyncAction('_AppStore.setToken');

  @override
  Future<void> setToken(String val, {bool isInitialization = false}) {
    return _$setTokenAsyncAction
        .run(() => super.setToken(val, isInitialization: isInitialization));
  }

  final _$setUserNameAsyncAction = AsyncAction('_AppStore.setUserName');

  @override
  Future<void> setUserName(String val, {bool isInitializing = false}) {
    return _$setUserNameAsyncAction
        .run(() => super.setUserName(val, isInitializing: isInitializing));
  }

  final _$setLoginAsyncAction = AsyncAction('_AppStore.setLogin');

  @override
  Future<void> setLogin(bool val, {bool isInitializing = false}) {
    return _$setLoginAsyncAction
        .run(() => super.setLogin(val, isInitializing: isInitializing));
  }

  final _$setDarkModeAsyncAction = AsyncAction('_AppStore.setDarkMode');

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  final _$setLanguageAsyncAction = AsyncAction('_AppStore.setLanguage');

  @override
  Future<void> setLanguage(String val) {
    return _$setLanguageAsyncAction.run(() => super.setLanguage(val));
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoader: ${isLoader},
isLoggedIn: ${isLoggedIn},
userName: ${userName},
token: ${token},
userId: ${userId},
userRole: ${userRole},
userEmail: ${userEmail},
isDarkMode: ${isDarkMode},
selectedLanguageCode: ${selectedLanguageCode},
appBarTheme: ${appBarTheme},
isAdmin: ${isAdmin},
isDemoAdmin: ${isDemoAdmin}
    ''';
  }
}
