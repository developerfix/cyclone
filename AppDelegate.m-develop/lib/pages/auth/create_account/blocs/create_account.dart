import 'dart:async';
import 'dart:convert';
import 'package:Siuu/services/auth_api.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/user.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';

class CreateAccountBloc {
  LocalizationService _localizationService;
  AuthApiService _authApiService;
  UserService _userService;

  // Serves as a snapshot to the data
  final userRegistrationData = UserRegistrationData();
  final passwordResetData = PasswordResetData();

  final _isOfLegalAgeSubject = BehaviorSubject<bool>();
  final _nameSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _tokenSubject = BehaviorSubject<String>();
  final _avatarSubject = BehaviorSubject<File>();
  final _usernameSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final registrationTokenSubject = BehaviorSubject<String>();
  final _passwordResetTokenSubject = BehaviorSubject<String>();

  // Create account begins

  Stream<bool> get createAccountInProgress =>
      _createAccountInProgressSubject.stream;

  final _createAccountInProgressSubject = ReplaySubject<bool>();

  Stream<String> get createAccountErrorFeedback =>
      _createAccountErrorFeedbackSubject.stream;

  final _createAccountErrorFeedbackSubject = ReplaySubject<String>();

  Stream<String> get tokenValidationErrorFeedback =>
      _tokenValidationErrorFeedbackSubject.stream;

  final _tokenValidationErrorFeedbackSubject = ReplaySubject<String>();

  // Create account ends

  CreateAccountBloc() {
    _isOfLegalAgeSubject.stream.listen(_onLegalAgeConfirmationChange);
    _nameSubject.stream.listen(_onNameChange);
    _tokenSubject.stream.listen(_onTokenChange);
    _emailSubject.stream.listen(_onEmailChange);
    _passwordSubject.listen(_onPasswordChange);
    _avatarSubject.listen(_onAvatarChange);
    _phoneSubject.listen(_onPhoneChange);
    registrationTokenSubject.listen(_onTokenChange);
    _passwordResetTokenSubject.listen(_onPasswordResetTokenChange);
  }

  void dispose() {
    _isOfLegalAgeSubject.close();
    _nameSubject.close();
    _tokenSubject.close();
    _emailSubject.close();
    _passwordSubject.close();
    _avatarSubject.close();
    _usernameSubject.close();
    _phoneSubject.close();
    _passwordResetTokenSubject.close();
    registrationTokenSubject.close();
  }

  void setLocalizationService(LocalizationService localizationService) {
    _localizationService = localizationService;
  }

  void setAuthApiService(AuthApiService authApiService) {
    _authApiService = authApiService;
  }

  void setUserService(UserService userService) {
    _userService = userService;
  }

  // Legal Age Confirmation

  bool isOfLegalAge() {
    return userRegistrationData.isOfLegalAge;
  }

  void _onLegalAgeConfirmationChange(bool isOfLegalAge) {
    userRegistrationData.isOfLegalAge = isOfLegalAge;
  }

  void setLegalAgeConfirmation(bool isOfLegalAge) {
    _isOfLegalAgeSubject.add(isOfLegalAge);
  }

  // Legal Age Confirmation

  bool areGuidelinesAccepted() {
    if (userRegistrationData.areGuidelinesAccepted == null) return false;
    return userRegistrationData.areGuidelinesAccepted;
  }

  void setAreGuidelinesAcceptedConfirmation(bool areGuidelinesAccepted) {
    userRegistrationData.areGuidelinesAccepted = areGuidelinesAccepted;
  }

  // Name begins

  bool hasName() {
    return userRegistrationData.name != null;
  }

  String getName() {
    return userRegistrationData.name;
  }

  void setName(String name) {
    _nameSubject.add(name);
    userRegistrationData.name = name;

  }

  void _onNameChange(String name) {
    if (name == null) return;
    userRegistrationData.name = name;
  }

  void _onTokenChange(String token) {
    if (token == null) return;
    userRegistrationData.token = token;
  }

  void _clearName() {
    userRegistrationData.name = null;
  }
  // phone begins

  bool hasPhone() {
    return userRegistrationData.phone != null;
  }

  String getPhone() {
    return userRegistrationData.phone;
  }

  void setPhone(String phone) {
    if(phone.isEmpty) return;
      userRegistrationData.phone = phone;
    _phoneSubject.add(phone);
  }

  void _onPhoneChange(String phone) {
    if (phone == null) return;
    userRegistrationData.phone = phone;
  }

  void _clearPhone() {
    userRegistrationData.phone = null;
  }
  // Phone ends

  // Username begins

  bool hasUsername() {
    return userRegistrationData.username != null;
  }

  String getUsername() {
    return userRegistrationData.username;
  }

  void setUsername(String username) async {
    if (username == null) return;
    userRegistrationData.username = username;
  }

  void clearUsername() {
    userRegistrationData.username = null;
  }

  // Username ends

  // Email begins

  bool hasEmail() {
    return userRegistrationData.email != null;
  }

  String getEmail() {
    return userRegistrationData.email;
  }

  void setEmail(String email) async {
    _emailSubject.add(email);
    userRegistrationData.email = email;

  }

  void _onEmailChange(String email) {
    if (email == null) return;
    userRegistrationData.email = email;
  }

  void _clearEmail() {
    userRegistrationData.email = null;
  }

  // Email ends

  // Password begins

  bool hasPassword() {
    return userRegistrationData.password != null;
  }

  String getPassword() {
    return userRegistrationData.password;
  }

  void _onPasswordChange(String password) {
    if (password == null) return;
    userRegistrationData.password = password;
  }

  void setPassword(String password) {
    _passwordSubject.add(password);
    userRegistrationData.password = password;

  }

  void _clearPassword() {
    userRegistrationData.password = null;
  }

// Password ends

  // Avatar begins

  bool hasAvatar() {
    return userRegistrationData.avatar != null;
  }

  File getAvatar() {
    return userRegistrationData.avatar;
  }

  void setAvatar(File avatar) {
    _avatarSubject.add(avatar);
  }

  void _onAvatarChange(File avatar) {
    if (avatar == null) {
      // Avatar is optional, therefore no feedback to user.
      return;
    }
    userRegistrationData.avatar = avatar;
  }

  void _clearAvatar() {
    userRegistrationData.avatar = null;
  }

  // Avatar ends

  // Registration Token begins
  bool hasToken() {
    return userRegistrationData.token != null;
  }

  String getToken() {
    return userRegistrationData.token;
  }

  void setToken(String token) async {
    _tokenSubject.add(token);
  }

  /*void _onTokenChange(String token) {
    if (token == null) return;
    userRegistrationData.token = token;
  }*/

  void _clearToken() {
    userRegistrationData.token = null;
  }

  // Registration Token ends

  // Password Reset Token begins
  bool hasPasswordResetToken() {
    return passwordResetData.passwordResetToken != null;
  }

  String getPasswordResetToken() {
    return passwordResetData.passwordResetToken;
  }

  void setPasswordResetToken(String passwordResetToken) async {
    _passwordResetTokenSubject.add(passwordResetToken);
  }

  void _onPasswordResetTokenChange(String passwordResetToken) {
    if (passwordResetToken == null) return;
    passwordResetData.passwordResetToken = passwordResetToken;
  }

  void _clearPasswordResetTokenToken() {
    passwordResetData.passwordResetToken = null;
  }

  //Password Reset Token ends

  Future<bool> createAccount(String token) async {
    _clearCreateAccount();

    _createAccountInProgressSubject.add(true);

    var accountWasCreated = false;

    print(token);

    try {
      HttpieStreamedResponse response = await _authApiService.createUser(
          email: userRegistrationData.email,
          isOfLegalAge: true,
          name: userRegistrationData.name,
          username: userRegistrationData.username,
          token: token,
          password: userRegistrationData.password,
          areGuidelinesAccepted: true,
          phone: userRegistrationData.phone,
          avatar: userRegistrationData.avatar);

      if (!response.isCreated()) throw HttpieRequestError(response);
      accountWasCreated = true;
      Map<String, dynamic> responseData =
          jsonDecode(await response.readAsString());
      setUsername(responseData['username']);
      _userService.loginWithAuthToken(responseData['token']);
      Response siuuCoin = await _authApiService.createSiuuCoinUser();
      var userData = json.decode(siuuCoin.body);
      // var jsonResponse = convert.jsonDecode(response.body);
      print(userData);
      _authApiService.createFirebaseUser(
          phone: userRegistrationData.phone,
          username: responseData['username'],
          siuuId: responseData['username'],
          siuuCoinId: userData['public']);
    } catch (error) {
      if (error is HttpieConnectionRefusedError) {
        _onCreateAccountValidationError(error.toHumanReadableMessage());
      } else if (error is HttpieRequestError) {
        String errorMessage = await error.toHumanReadableMessage();
        _onCreateAccountValidationError(errorMessage);
      } else {
        _onCreateAccountValidationError('Unknown error');
        rethrow;
      }
    }

    return accountWasCreated;
  }

  void _onCreateAccountValidationError(String errorMessage) {
    _createAccountErrorFeedbackSubject.add(errorMessage);
    _clearToken();
  }

  void _onTokenValidationError(String errorMessage) {
    _tokenValidationErrorFeedbackSubject.add(errorMessage);
    _clearToken();
  }

  void _clearCreateAccount() {
    _createAccountInProgressSubject.add(null);
    _createAccountErrorFeedbackSubject.add(null);
    _tokenValidationErrorFeedbackSubject.add(null);
  }

  void clearAll() {
    _clearCreateAccount();
    _clearName();
    _clearEmail();
    _clearAvatar();
    _clearPhone();
    _clearPassword();
    _clearToken();
    _clearPasswordResetTokenToken();
  }
}

class UserRegistrationData {
  String token;
  String name;
  bool isOfLegalAge;
  bool areGuidelinesAccepted;
  String username;
  String email;
  String phone;
  String password;
  File avatar;
}

class PasswordResetData {
  String passwordResetToken;
}