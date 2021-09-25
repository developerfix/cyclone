import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/services/validation.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/fields/text_form_field.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBChangeEmailModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBChangeEmailModalState();
  }
}

class OBChangeEmailModalState extends State<OBChangeEmailModal> {
  ValidationService _validationService;
  ToastService _toastService;
  UserService _userService;
  LocalizationService _localizationService;
  static const double INPUT_ICONS_SIZE = 16;
  static const EdgeInsetsGeometry INPUT_CONTENT_PADDING =
      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _requestInProgress = false;
  bool _formWasSubmitted = false;
  bool _changedEmailTaken = false;
  bool _formValid = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _currentEmailController;
  CancelableOperation _requestOperation;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _formWasSubmitted = false;
    _changedEmailTaken = false;
    _formValid = true;
    _emailController.addListener(_updateFormValid);
  }

  @override
  void dispose() {
    super.dispose();
    if (_requestOperation != null) _requestOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _validationService = openbookProvider.validationService;
    _toastService = openbookProvider.toastService;
    _userService = openbookProvider.userService;
    _localizationService = openbookProvider.localizationService;

    String currentUserEmail = _userService.getLoggedInUser().getEmail();
    _currentEmailController = TextEditingController(text: currentUserEmail);

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50),
                    OBTextFormField(
                      size: OBTextFormFieldSize.large,
                      autofocus: false,
                      readOnly: true,
                      controller: _currentEmailController,
                      decoration: InputDecoration(
                        labelText: _localizationService
                            .user__change_email_current_email_text,
                      ),
                    ),
                    OBTextFormField(
                      size: OBTextFormFieldSize.large,
                      autofocus: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText:
                            _localizationService.user__change_email_email_text,
                        hintText:
                            _localizationService.user__change_email_hint_text,
                      ),
                      validator: (String email) {
                        if (!_formWasSubmitted) return null;
                        String validateEmail =
                            _validationService.validateUserEmail(email);
                        if (validateEmail != null) return validateEmail;
                        if (_changedEmailTaken != null && _changedEmailTaken) {
                          return _localizationService.user__change_email_error;
                        }
                      },
                    ),
                  ]),
            ),
          ),
        ));
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: const OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: _localizationService.user__change_email_title,
      trailing: OBButton(
        isDisabled: !_formValid,
        isLoading: _requestInProgress,
        size: OBButtonSize.small,
        onPressed: _submitForm,
        child: Text(_localizationService.user__change_email_save),
      ),
    );
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  bool _updateFormValid() {
    var formValid = _validateForm();
    _setFormValid(formValid);
    _setChangedEmailTaken(false);
    return formValid;
  }

  void _submitForm() async {
    _formWasSubmitted = true;
    var formIsValid = _updateFormValid();
    if (!formIsValid) return;
    _setRequestInProgress(true);
    try {
      var email = _emailController.text;
      _requestOperation =
          CancelableOperation.fromFuture(_userService.updateUserEmail(email));
      await _requestOperation.value;
      _toastService.success(
          message: _localizationService.user__change_email_success_info,
          context: context);
      Navigator.of(context).pop();
    } catch (error) {
      _onError(error);
    } finally {
      _requestOperation = null;
      _setRequestInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setChangedEmailTaken(bool isEmailTaken) {
    setState(() {
      _changedEmailTaken = isEmailTaken;
    });
  }

  void _setFormValid(bool formValid) {
    setState(() {
      _formValid = formValid;
    });
  }
}