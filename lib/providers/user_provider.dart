import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wifi_chat/Services/registration_service.dart';
import 'package:wifi_chat/data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(host: '', port: 0, id: '', name: '');
  final RegistrationService _registrationService = RegistrationService();

  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> register() async {
    await _registrationService.regiser(
        name: user.name, imagebytes: user.profileImage);
    notifyListeners();
  }

  Future<void> unregister() async {
    await _registrationService.unregister();
    notifyListeners();
  }

  void updateName(String name) {
    _user.name = name;
    notifyListeners();
  }

  Future<void> updateProfileImage(XFile? profileImage) async {
    _user.profileImage = await profileImage?.readAsBytes();
    notifyListeners();
  }
}
