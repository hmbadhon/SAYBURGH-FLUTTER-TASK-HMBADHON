import 'package:flutter/material.dart';
import 'package:movie_app/sheared/default_btn.dart';
import 'package:movie_app/sheared/input_form_widget.dart';
import 'package:movie_app/utils/constants.dart';
import 'package:movie_app/utils/size_config.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = 'login_screen';
  LoginScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

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
            bottom: -30,
            child: Image.asset(
              kImageDir + 'bottom_login.png',
              fit: BoxFit.fill,
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
                          fieldController: _numberController,
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(35),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: DefaultBtn(
                              title: 'Login',
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {}
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
