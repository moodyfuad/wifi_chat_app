import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat/data/constants/assets_paths.dart';
import 'package:wifi_chat/providers/user_provider.dart';
import 'package:wifi_chat/screens/main/main_srceen.dart';
import 'package:wifi_chat/screens/shared/validators/login_validator.dart';

class LoginFieldContainer extends StatelessWidget {
  LoginFieldContainer({
    super.key,
  });
  final _formState = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formState,
                  autovalidateMode: AutovalidateMode.always,
                  child:
                      Consumer<UserProvider>(builder: (context, value, child) {
                    _nameController.text = value.user.name;
                    return TextFormField(
                      controller: _nameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                      ],
                      maxLength: 15,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter Your Name (English)",
                        labelText: 'Name (English)',
                      ),
                      validator: (vlaue) => LoginValidator.nameValidator(vlaue),
                      onFieldSubmitted: (_) =>
                          _navigateToDiscoveryPage(context),
                    );
                  }),
                ),
                ElevatedButton(
                  onPressed: () => _navigateToDiscoveryPage(context),
                  child: const Text(
                    "View Users",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Positioned(
        child: Align(
          alignment: Alignment.center,
          child: CircleAvatar(
            backgroundColor: Colors.white10,
            radius: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Consumer<UserProvider>(builder: (_, provider, __) {
                return GestureDetector(
                  onTap: () async => await _onTabprofileImage(provider),
                  onLongPress: () => _onLongProess(provider),
                  child: _getUserImage(provider),
                );
              }),
            ),
          ),
        ),
      ),
    ]);
  }

  void _navigateToDiscoveryPage(BuildContext context) {
    bool valied = _formState.currentState?.validate() ?? false;
    if (valied) {
      Provider.of<UserProvider>(context, listen: false)
          .updateName(_nameController.text);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  }

  Future<void> _onTabprofileImage(UserProvider provider) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    provider.updateProfileImage(image);
  }

  void _onLongProess(UserProvider provider) {
    provider.updateProfileImage(null);
  }

  Widget _getUserImage(UserProvider provider) {
    if (provider.user.profileImage == null) {
      return Lottie.asset(
        AssetPaths.lottieAddProfilePic,
        fit: BoxFit.cover,
      );
    } else {
      return SizedBox(
        width: 80,
        height: 80,
        child: Image.memory(
          provider.user.profileImage!,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
