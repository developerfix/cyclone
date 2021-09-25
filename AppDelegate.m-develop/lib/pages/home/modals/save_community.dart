import 'dart:io';

import 'package:Siuu/models/category.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/services/media/media.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/avatars/letter_avatar.dart';
import 'package:Siuu/widgets/cover.dart';
import 'package:Siuu/widgets/fields/categories_field.dart';
import 'package:Siuu/widgets/fields/color_field.dart';
import 'package:Siuu/widgets/fields/community_type_field.dart';
import 'package:Siuu/widgets/fields/toggle_field.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/nav_bars/colored_nav_bar.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/services/validation.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/fields/text_form_field.dart';
import 'package:Siuu/widgets/progress_indicator.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBSaveMemoryModal extends StatefulWidget {
  final Memory crew;

  const OBSaveMemoryModal({this.crew});

  @override
  OBSaveMemoryModalState createState() {
    return OBSaveMemoryModalState();
  }
}

class OBSaveMemoryModalState extends State<OBSaveMemoryModal> {
  UserService _userService;
  ToastService _toastService;
  ValidationService _validationService;
  MediaService _imagePickerService;
  LocalizationService _localizationService;
  ThemeValueParserService _themeValueParserService;

  bool _requestInProgress;
  bool _formWasSubmitted;
  bool _formValid;
  bool _isEditingExistingMemory;
  String _takenName;

  GlobalKey<FormState> _formKey;

  TextEditingController _nameController;
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _userAdjectiveController;
  TextEditingController _usersAdjectiveController;
  TextEditingController _rulesController;
  OBCategoriesFieldController _categoriesFieldController;

  String _color;
  MemoryType _type;
  String _avatarUrl;
  String _coverUrl;
  File _avatarFile;
  File _coverFile;
  bool _invitesEnabled;

  List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _formValid = true;
    _requestInProgress = false;
    _formWasSubmitted = false;
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _userAdjectiveController = TextEditingController();
    _usersAdjectiveController = TextEditingController();
    _rulesController = TextEditingController();
    _categoriesFieldController = OBCategoriesFieldController();
    _type = MemoryType.public;
    _invitesEnabled = true;
    _categories = [];

    _formKey = GlobalKey<FormState>();
    _isEditingExistingMemory = widget.crew != null;

    if (_isEditingExistingMemory) {
      _nameController.text = widget.crew.name;
      _titleController.text = widget.crew.title;
      _descriptionController.text = widget.crew.description;
      _userAdjectiveController.text = widget.crew.userAdjective;
      _usersAdjectiveController.text = widget.crew.usersAdjective;
      _rulesController.text = widget.crew.rules;
      _color = widget.crew.color;
      _categories = widget.crew.categories.categories.toList();
      _type = widget.crew.type;
      _avatarUrl = widget.crew.avatar;
      _coverUrl = widget.crew.cover;
      _invitesEnabled = widget.crew.invitesEnabled;
    }

    _nameController.addListener(_updateFormValid);
    _titleController.addListener(_updateFormValid);
    _descriptionController.addListener(_updateFormValid);
    _userAdjectiveController.addListener(_updateFormValid);
    _usersAdjectiveController.addListener(_updateFormValid);
    _rulesController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _validationService = openbookProvider.validationService;
    _imagePickerService = openbookProvider.mediaService;
    _localizationService = openbookProvider.localizationService;
    _themeValueParserService = openbookProvider.themeValueParserService;
    var themeService = openbookProvider.themeService;

    _color = _color ?? themeService.generateRandomHexColor();

    return CupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        _buildCover(),
                        Positioned(
                          left: 20,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: (OBCover.largeSizeHeight) -
                                    (OBAvatar.AVATAR_SIZE_LARGE / 2),
                              ),
                              _buildAvatar()
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: OBCover.largeSizeHeight +
                                OBAvatar.AVATAR_SIZE_LARGE / 2)
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 40),
                        child: Column(
                          children: <Widget>[
                            OBTextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.medium,
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: _localizationService
                                      .community__save_community_label_title,
                                  hintText: _localizationService
                                      .community__save_community_label_title_hint_text,
                                  prefixIcon: const OBIcon(OBIcons.memories),
                                ),
                                validator: (String crewTitle) {
                                  return _validationService
                                      .validateMemoryTitle(crewTitle);
                                }),
                            OBTextFormField(
                                textCapitalization: TextCapitalization.none,
                                size: OBTextFormFieldSize.medium,
                                controller: _nameController,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    prefixIcon: const OBIcon(OBIcons.shortText),
                                    labelText: _localizationService
                                        .community__save_community_name_title,
                                    prefixText: 'c/',
                                    hintText: _localizationService
                                        .community__save_community_name_title_hint_text),
                                validator: (String crewName) {
                                  if (_takenName != null &&
                                      _takenName == crewName) {
                                    return _localizationService
                                        .community__save_community_name_taken(
                                            _takenName);
                                  }

                                  return _validationService
                                      .validateMemoryName(crewName);
                                }),
                            OBColorField(
                              initialColor: _color,
                              onNewColor: _onNewColor,
                              labelText: _localizationService
                                  .community__save_community_name_label_color,
                              hintText: _localizationService
                                  .community__save_community_name_label_color_hint_text,
                            ),
                            OBMemoryTypeField(
                              value: _type,
                              title: _localizationService
                                  .community__save_community_name_label_type,
                              hintText: _localizationService
                                  .community__save_community_name_label_type_hint_text,
                              onChanged: (MemoryType type) {
                                setState(() {
                                  _type = type;
                                });
                              },
                            ),
                            _type == MemoryType.private
                                ? OBToggleField(
                                    value: _invitesEnabled,
                                    title: _localizationService
                                        .community__save_community_name_member_invites,
                                    subtitle: OBText(_localizationService
                                        .community__save_community_name_member_invites_subtitle),
                                    onChanged: (bool value) {
                                      setState(() {
                                        _invitesEnabled = value;
                                      });
                                    },
                                    onTap: () {
                                      setState(() {
                                        _invitesEnabled = !_invitesEnabled;
                                      });
                                    },
                                  )
                                : const SizedBox(),
                            OBCategoriesField(
                              title: _localizationService
                                  .community__save_community_name_category,
                              min: 1,
                              max: 1,
                              controller: _categoriesFieldController,
                              displayErrors: _formWasSubmitted,
                              onChanged: _onCategoriesChanged,
                              initialCategories: _categories,
                            ),
                            OBTextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.medium,
                                controller: _descriptionController,
                                maxLines: 3,
                                textInputAction: TextInputAction.newline,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const OBIcon(OBIcons.crewDescription),
                                    labelText: _localizationService
                                        .community__save_community_name_label_desc_optional,
                                    hintText: _localizationService
                                        .community__save_community_name_label_desc_optional_hint_text),
                                validator: (String crewDescription) {
                                  return _validationService
                                      .validateMemoryDescription(
                                          crewDescription);
                                }),
                            OBTextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              size: OBTextFormFieldSize.medium,
                              controller: _rulesController,
                              decoration: InputDecoration(
                                  prefixIcon: const OBIcon(OBIcons.crewRules),
                                  labelText: _localizationService
                                      .community__save_community_name_label_rules_optional,
                                  hintText: _localizationService
                                      .community__save_community_name_label_rules_optional_hint_text),
                              validator: (String crewRules) {
                                return _validationService
                                    .validateMemoryRules(crewRules);
                              },
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLines: 3,
                            ),
                            OBTextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.medium,
                                controller: _userAdjectiveController,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const OBIcon(OBIcons.crewMember),
                                    labelText: _localizationService
                                        .community__save_community_name_label_member_adjective,
                                    hintText: _localizationService
                                        .community__save_community_name_label_member_adjective_hint_text),
                                validator: (String crewUserAdjective) {
                                  return _validationService
                                      .validateMemoryUserAdjective(
                                          crewUserAdjective);
                                }),
                            /* OBTextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.medium,
                                controller: _usersAdjectiveController,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const OBIcon(OBIcons.crewMembers),
                                    labelText: _localizationService
                                        .community__save_community_name_label_members_adjective,
                                    hintText: _localizationService
                                        .community__save_community_name_label_members_adjective_hint_text),
                                validator: (String crewUsersAdjective) {
                                  return _validationService
                                      .validateMemoryUserAdjective(
                                          crewUsersAdjective);
                                }),*/
                          ],
                        )),
                  ],
                )),
          ),
        ));
  }

  Widget _buildNavigationBar() {
    Color color = _themeValueParserService.parseColor(_color);
    bool isDarkColor = _themeValueParserService.isDarkColor(color);
    Color actionsColor = isDarkColor ? Colors.white : Colors.black;

    return OBColoredNavBar(
        color: color,
        leading: GestureDetector(
          child: OBIcon(
            OBIcons.close,
            color: actionsColor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: _isEditingExistingMemory
            ? _localizationService.community__save_community_edit_crew
            : _localizationService.community__save_community_create_crew,
        trailing: _requestInProgress
            ? OBProgressIndicator(color: actionsColor)
            : OBButton(
                isDisabled: !_formValid,
                isLoading: _requestInProgress,
                size: OBButtonSize.small,
                onPressed: _submitForm,
                child: Text(_isEditingExistingMemory
                    ? _localizationService.community__save_community_save_text
                    : _localizationService
                        .community__save_community_create_text),
              ));
  }

  Widget _buildAvatar() {
    bool hasAvatarFile = _avatarFile != null;
    bool hasAvatarUrl = _avatarUrl != null;

    bool hasAvatar = hasAvatarFile || hasAvatarUrl;

    Function _onPressed = hasAvatar ? _clearAvatar : _pickNewAvatar;

    Widget icon = Icon(
      hasAvatar ? Icons.clear : Icons.edit,
      size: 15,
    );

    Widget avatar;

    if (hasAvatar) {
      avatar = OBAvatar(
        borderWidth: 3,
        avatarUrl: _avatarUrl,
        avatarFile: _avatarFile,
        size: OBAvatarSize.large,
      );
    } else {
      avatar = OBLetterAvatar(
          size: OBAvatarSize.large,
          color: Pigment.fromString(_color),
          letter: _nameController.text.isEmpty ? 'C' : _nameController.text[0]);
    }

    return GestureDetector(
        onTap: _onPressed,
        child: Stack(
          children: <Widget>[
            avatar,
            Positioned(
              bottom: 10,
              right: 10,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
                child: FloatingActionButton(
                  heroTag: Key('editMemoryAvatar'),
                  backgroundColor: Colors.white,
                  child: icon,
                  onPressed: _onPressed,
                ),
              ),
            ),
          ],
        ));
  }

  void _pickNewAvatar() async {
    File newAvatar = await _imagePickerService.pickImage(
        imageType: OBImageType.avatar, context: context);
    if (newAvatar != null) _setAvatarFile(newAvatar);
  }

  Widget _buildCover() {
    bool hasCoverFile = _coverFile != null;
    bool hasCoverUrl = _coverUrl != null;
    bool hasCover = hasCoverFile || hasCoverUrl;

    Function _onPressed = hasCover ? _clearCover : _pickNewCover;

    Widget icon = Icon(
      hasCover ? Icons.clear : Icons.edit,
      size: 15,
    );

    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: <Widget>[
          OBCover(
            coverUrl: _coverUrl,
            coverFile: _coverFile,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
              child: FloatingActionButton(
                heroTag: Key('editMemoryCover'),
                backgroundColor: Colors.white,
                child: icon,
                onPressed: _onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickNewCover() async {
    File newCover = await _imagePickerService.pickImage(
        imageType: OBImageType.cover, context: context);
    if (newCover != null) _setCoverFile(newCover);
  }

  void _onCategoriesChanged(List<Category> categories) {
    _setCategories(categories);
    // TODO Couldnt find a way to make it work without doing this
    // Perhaps move the entire state of the CategoriesField into here
    _updateFormValid();
  }

  void _clearAvatar() {
    _avatarUrl = null;
    _clearAvatarFile();
  }

  void _clearAvatarFile() {
    _setAvatarFile(null);
  }

  void _setAvatarFile(File avatarFile) {
    setState(() {
      _avatarFile = avatarFile;
    });
  }

  void _clearCover() {
    _coverUrl = null;
    _clearCoverFile();
  }

  void _clearCoverFile() {
    _setCoverFile(null);
  }

  void _setCoverFile(File coverFile) {
    setState(() {
      _coverFile = coverFile;
    });
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  bool _updateFormValid() {
    if (!_formWasSubmitted) return true;
    var formValid = _validateForm() && _categoriesFieldController.isValid();
    _setFormValid(formValid);
    return formValid;
  }

  void _submitForm() async {
    _formWasSubmitted = true;

    var formIsValid = _updateFormValid();

    if (!formIsValid) return;

    _setRequestInProgress(true);
    try {
      var crewName = _nameController.text;
      //bool crewNameTaken = await _isNameTaken(crewName);

      // TODO: check if crew already exist before create

      /*if (crewNameTaken) {
        _setTakenName(crewName);
        _validateForm();
        return;
      }*/

      Memory crew =
          await (_isEditingExistingMemory ? _updateMemory() : _createMemory());

      Navigator.of(context).pop(crew);
    } catch (error) {
      _onError(error);
    } finally {
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

  Future<Memory> _updateMemory() async {
    await _updateMemoryAvatar();
    await _updateMemoryCover();

    return _userService.updateMemory(widget.crew,
        name: _nameController.text != widget.crew.name
            ? _nameController.text
            : null,
        title: _titleController.text,
        description: _descriptionController.text,
        rules: _rulesController.text,
        userAdjective: _userAdjectiveController.text,
        usersAdjective: _usersAdjectiveController.text,
        categories: _categories,
        type: _type,
        invitesEnabled: _invitesEnabled,
        color: _color);
  }

  Future<void> _updateMemoryCover() {
    bool hasCoverFile = _coverFile != null;
    bool hasCoverUrl = _coverUrl != null;
    bool hasCover = hasCoverFile || hasCoverUrl;

    Future<void> updateFuture;

    if (!hasCover) {
      if (widget.crew.cover != null) {
        // Remove cover!
        updateFuture = _userService.deleteCoverForMemory(widget.crew);
      }
    } else if (hasCoverFile) {
      // New cover
      updateFuture =
          _userService.updateCoverForMemory(widget.crew, cover: _coverFile);
    } else {
      updateFuture = Future.value();
    }

    return updateFuture;
  }

  Future<void> _updateMemoryAvatar() {
    bool hasAvatarFile = _avatarFile != null;
    bool hasAvatarUrl = _avatarUrl != null;
    bool hasAvatar = hasAvatarFile || hasAvatarUrl;

    Future<void> updateFuture;

    if (!hasAvatar) {
      if (widget.crew.avatar != null) {
        // Remove avatar!
        updateFuture = _userService.deleteAvatarForMemory(widget.crew);
      }
    } else if (hasAvatarFile) {
      // New avatar
      updateFuture =
          _userService.updateAvatarForMemory(widget.crew, avatar: _avatarFile);
    } else {
      updateFuture = Future.value();
    }

    return updateFuture;
  }

  Future<Memory> _createMemory() {
    return _userService.createMemory(
        type: _type,
        name: _nameController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        rules: _rulesController.text,
        userAdjective: _userAdjectiveController.text,
        usersAdjective: _usersAdjectiveController.text,
        categories: _categories,
        invitesEnabled: _invitesEnabled,
        color: _color,
        avatar: _avatarFile,
        cover: _coverFile);
  }

  Future<bool> _isNameTaken(String crewName) async {
    if (_isEditingExistingMemory && widget.crew.name == _nameController.text) {
      return false;
    }
    return _validationService.isMemoryNameTaken(crewName);
  }

  void _onNewColor(String newColor) {
    _setColor(newColor);
  }

  void _setColor(String color) {
    setState(() {
      _color = color;
    });
  }

  void _setCategories(List<Category> categories) {
    setState(() {
      _categories = categories;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setFormValid(bool formValid) {
    setState(() {
      _formValid = formValid;
    });
  }

  void _setTakenName(String takenMemoryName) {
    setState(() {
      _takenName = takenMemoryName;
    });
  }
}
