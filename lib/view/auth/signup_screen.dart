import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/services/network_service.dart';
import 'package:movie_app/sheared/default_btn.dart';
import 'package:movie_app/sheared/input_form_widget.dart';
import 'package:movie_app/utils/constants.dart';
import 'package:movie_app/utils/size_config.dart';
import 'package:movie_app/view/auth/login_screen.dart';
import 'package:movie_app/view/root/main_screen.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = 'signup_screen';
  SignUpScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
                      'SignUp',
                      style: kHeadLine,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
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
                          fieldController: _emailController,
                          labelText: 'Email Address',
                          icon: Icons.email,
                          fillColor: kOrdinaryColor2,
                          keyType: TextInputType.emailAddress,
                          validation: (value) {
                            if (value.isEmpty) {
                              return kEmailNullError;
                            } else if (!emailValidatorRegExp.hasMatch(value)) {
                              return kInvalidEmailError;
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
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Already has account?',
                              style: kDescriptionText.copyWith(
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(35),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: DefaultBtn(
                              title: 'Signup',
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  var p = await NetworkServices().createUser(
                                    context: context,
                                    username: _nameController.text,
                                    password: _passController.text,
                                    email: _emailController.text,
                                  );
                                  Map<String, dynamic> js = p;
                                  if (p['code'] >= 400) {
                                    Navigator.of(context).pop();
                                    print(p['message']);
                                    Get.snackbar('Error', p['message']);
                                  } else {
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacementNamed(
                                        context, LoginScreen.routeName);
                                    Get.snackbar('Registered Successfully', '');
                                  }
                                  print('ok');
                                }
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: SizeConfig.screenWidth / 3,
                            child: DefaultBtn(
                              title: 'Wanna Skip?',
                              onPress: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    MainScreen.routeName, (route) => false);
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
}
