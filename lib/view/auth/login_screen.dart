import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/services/network_service.dart';
import 'package:movie_app/sheared/default_btn.dart';
import 'package:movie_app/sheared/input_form_widget.dart';
import 'package:movie_app/utils/constants.dart';
import 'package:movie_app/utils/size_config.dart';
import 'package:movie_app/view/root/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = 'login_screen';
  LoginScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              kImageDir + 'border_login.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenWidth / 1.8,
              child: Image.asset(
                kImageDir + 'bottom_login.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: 'logo',
                      child: SizedBox(
                          width: SizeConfig.screenWidth / 2,
                          child: Image.asset('${kImageDir}logo.png')),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(30),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(20),
                    ),
                    child: Text(
                      'Login',
                      style: kHeadLine,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputFormWidget(
                          fieldController: _nameController,
                          labelText: 'User Name',
                          icon: Icons.person,
                          fillColor: kOrdinaryColor2,
                          keyType: TextInputType.name,
                          validation: (value) {
                            if (value.isEmpty) {
                              return kNameNullError;
                            }
                            return null;
                          },
                        ),
                        InputFormWidget(
                          fieldController: _passController,
                          labelText: 'Password',
                          icon: Icons.lock,
                          fillColor: kOrdinaryColor2,
                          keyType: TextInputType.visiblePassword,
                          isProtected: true,
                          validation: (value) {
                            if (value.isEmpty) {
                              return kPassNullError;
                            } else if (value.length < 4) {
                              return kShortPassError;
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(35),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: DefaultBtn(
                              title: 'Login',
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  var p = await NetworkServices().logInUser(
                                    context: context,
                                    username: _nameController.text,
                                    password: _passController.text,
                                  );
                                  Map<String, dynamic> js = p;
                                  if (js.containsKey('data') &&
                                      p['data']['status'] >= 400) {
                                    Navigator.of(context).pop();
                                    print(p['message']);
                                    Get.snackbar('Invalid Credential', '');
                                  } else {
                                    Navigator.of(context).pop();
                                    store(p, context);
                                  }
                                  print('ok');
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void store(var mat, BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString('token', mat['token'].toString());
    prefs!.setString('username', mat['user_nicename'].toString());
    prefs!.setString('email', mat['user_email'].toString());
    prefs!.setString('name', mat['user_display_name'].toString());

    var p = await NetworkServices().getUserProfile(
      context: context,
    );
    Map<String, dynamic> js = p;
    if (js.containsKey('data') && p['data']['status'] >= 400) {
      Navigator.of(context).pop();
      print(p['message']);
      Get.snackbar('failed to get profile data', '');
    } else {
      Navigator.of(context).pop();
      prefs!.setString('fName', p['first_name'].toString());
      prefs!.setString('lName', p['last_name'].toString());
      prefs!.setString('id', p['id'].toString());
    }

    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.routeName, (route) => false);
  }
}
