import 'package:Siuu/custom/CustomAuthScreens/text/CustomTextinAuthScreens.dart';
import 'package:Siuu/custom/customButton.dart';
import 'package:Siuu/custom/customTextField.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/services/validation.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/buttons/success_button.dart';
import 'package:Siuu/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:Siuu/res/colors.dart';

class OBAuthLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthLoginPageState();
  }
}

class OBAuthLoginPageState extends State<OBAuthLoginPage> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _passwordFocusNode;

  bool _isSubmitted;
  bool _passwordIsVisible;
  String _loginFeedback;
  bool _loginInProgress;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LocalizationService _localizationService;
  ValidationService _validationService;
  UserService _userService;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _passwordFocusNode = FocusNode();

    _loginInProgress = false;
    _isSubmitted = false;
    _passwordIsVisible = false;

    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _validationService = openbookProvider.validationService;
    _userService = openbookProvider.userService;

    return Container(
      color: Colors.white,
      child: Scaffold(
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildHeading(context: context),
                    const SizedBox(
                      height: 30.0,
                    ),
                    _buildLoginForm(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildLoginFeedback(),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: 20.0 + MediaQuery.of(context).viewInsets.bottom,
                top: 20.0,
                left: 20.0,
                right: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: _buildPreviousButton(context: context),
                ),
                Expanded(child: _buildContinueButton(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginFeedback() {
    if (_loginFeedback == null) return const SizedBox();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 150),
        curve: Curves.fastOutSlowIn,
      );
    });

    return SizedBox(
      child: Text(
        _loginFeedback,
        style: TextStyle(fontSize: 16.0, color: Colors.deepOrange),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    String buttonText = _localizationService.trans('auth__login__login');

    return OBSuccessButton(
      isLoading: _loginInProgress,
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: _submitForm,
    );
  }

  Future<void> _submitForm() async {
    _isSubmitted = true;
    if (_validateForm()) {
      await _login(context);
    }
  }

  Future<void> _login(BuildContext context) async {
    _setLoginInProgress(true);
    String username = _usernameController.text.trim();
    String password = _passwordController.text;
    try {
      await _userService.loginWithCredentials(
          username: username, password: password);
      Navigator.pop(context); //pop the login form screen
      Navigator.pushReplacementNamed(
          context, '/'); //replace the underlying login splash screen too
    } catch (e) {
      _setLoginFeedback("invalid username or password");
      print('Error: ${e.toString()}');
    }
    _setLoginInProgress(false);
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
    String buttonText = _localizationService.trans('auth__login__previous');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(Icons.arrow_back_ios),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            buttonText,
            style: TextStyle(fontSize: 18.0),
          )
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildForgotPasswordButton({@required BuildContext context}) {
    String buttonText =
        _localizationService.trans('auth__login__forgot_password');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomTextAuthScreens(buttonText),
        ],
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/auth/forgot_password_step');
      },
    );
  }

  Widget _buildHeading({@required BuildContext context}) {
    String titleText = _localizationService.trans('auth__login__title');
    String subtitleText = _localizationService.trans('auth__login__subtitle');
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        SizedBox(height: height * 0.013),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Siuu",
                style: TextStyle(
                  fontFamily: "Gabriola",
                  fontSize: 27,
                  color: Color(0xff4d0cbb),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Se connecter",
                  style: TextStyle(
                    fontFamily: "Segoe UI",
                    fontSize: 11,
                    color: Color(0xff4d0cbb),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: height * 0.117),
        SizedBox(
          height: height * 0.117,
          width: width * 0.243,
          child: Image.asset(
            'assets/images/Siu.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        SizedBox(height: height * 0.043),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextAuthScreens('Vous n\'avez pas un compte ?'),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/register1');
              },
              child: CustomTextAuthScreens(' S\'inscrire'),
            ),
          ],
        ),
        SizedBox(height: height * 0.029),
      ],
    );
  }

  Widget _buildLoginForm() {
    // If we use StreamBuilder to build the TexField it has a weird
    // bug which places the cursor at the beginning of the label everytime
    // the stream changes. Therefore a flag is used to bootstrap initial value
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    String usernameInputLabel =
        _localizationService.trans('auth__login__username_label');

    String passwordInputLabel =
        _localizationService.trans('auth__login__password_label');

    EdgeInsetsGeometry inputContentPadding =
        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0);

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.070,
              width: width * 0.678,
              child: TextFormField(
                controller: _usernameController,
                cursorColor: Color(purpleColor),
                textAlign: TextAlign.center,
                onFieldSubmitted: (v) =>
                    FocusScope.of(context).requestFocus(_passwordFocusNode),
                decoration: InputDecoration(
                  hintText: "Username",
                  hintStyle: TextStyle(
                    fontFamily: "SF Pro Display",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff4d0cbb),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: width * 0.004, color: Color(greyishColor)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: width * 0.004, color: Color(greyishColor)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: width * 0.004, color: Color(greyishColor)),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.029),
            Container(
              height: height * 0.100,
              width: width * 0.678,
              child: TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: !_passwordIsVisible,
                validator: _validatePassword,
                cursorColor: Color(purpleColor),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  helperText: ' ',
                  suffixIcon: GestureDetector(
                    child: Icon(_passwordIsVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onTap: () {
                      _togglePasswordVisibility();
                    },
                  ),
                  hintText: "Password",
                  hintStyle: TextStyle(
                    fontFamily: "SF Pro Display",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff4d0cbb),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: width * 0.004, color: Color(greyishColor)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: width * 0.004, color: Color(greyishColor)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(48.0)),
                    borderSide: BorderSide(
                        width: width * 0.004, color: Color(greyishColor)),
                  ),
                ),
                autocorrect: false,
                onFieldSubmitted: (v) => _submitForm(),
              ),
            ),
//            SizedBox(height: height * 0.043),
            Center(child: _buildForgotPasswordButton(context: context))
          ],
        ));
  }

  String _validateUsername(String value) {
    if (!_isSubmitted) return null;
    return _validationService.validateUserUsername(value.trim());
  }

  String _validatePassword(String value) {
    if (!_isSubmitted) return null;

    return _validationService.validateUserPassword(value);
  }

  bool _validateForm() {
    if (_loginFeedback != null) {
      _setLoginFeedback(null);
    }
    return _formKey.currentState.validate();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordIsVisible = !_passwordIsVisible;
    });
  }

  void _setLoginFeedback(String feedback) {
    setState(() {
      _loginFeedback = feedback;
    });
  }

  void _setLoginInProgress(bool loginInProgress) {
    setState(() {
      _loginInProgress = loginInProgress;
    });
  }
}
