import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:movie_app/services/network_service.dart';
import 'package:movie_app/sheared/default_btn.dart';
import 'package:movie_app/sheared/input_form_widget.dart';
import 'package:movie_app/utils/constants.dart';
import 'package:movie_app/utils/size_config.dart';
import 'package:movie_app/view/auth/login_screen.dart';
import 'package:movie_app/view/profile/widget/profile_row_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileFormKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kPrimaryColor,
                  width: 4,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: getProportionateScreenWidth(120),
                      width: getProportionateScreenWidth(120),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            kImageDir + 'man.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: -12,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            log('message');
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                              color: kWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              prefs!.getString('name') ?? 'No Name',
              style: kRegularText.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  prefs!.getString('fName') ?? '',
                  style: kDescriptionText.copyWith(
                    color: Color(0xFF888888),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  prefs!.getString('lName') ?? '',
                  style: kDescriptionText.copyWith(
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ProfileRowWidget(
              title: 'Update Profile',
              icon: Icons.update,
              onPress: () {
                Get.bottomSheet(
                  Container(
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: new BorderRadius.only(
                        topRight: const Radius.circular(15.0),
                        topLeft: const Radius.circular(15.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _profileFormKey,
                          child: Column(
                            children: [
                              InputFormWidget(
                                fieldController: firstNameController,
                                labelText: 'First Name',
                                hintText: 'Enter First Name',
                                fillColor: kOrdinaryColor2,
                                keyType: TextInputType.name,
                                isProtected: false,
                                validation: (value) {
                                  if (value.isEmpty) {
                                    return kNameNullError;
                                  }
                                  return null;
                                },
                              ),
                              InputFormWidget(
                                fieldController: lastNameController,
                                labelText: 'Last Name',
                                hintText: 'Enter First Name',
                                fillColor: kOrdinaryColor2,
                                keyType: TextInputType.name,
                                isProtected: false,
                                validation: (value) {
                                  if (value.isEmpty) {
                                    return kNameNullError;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: DefaultBtn(
                                  title: 'Submit'.tr,
                                  onPress: () async {
                                    if (_profileFormKey.currentState!
                                        .validate()) {
                                      var p = await NetworkServices()
                                          .updateUserProfile(
                                        context: context,
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                      );
                                      Map<String, dynamic> js = p;
                                      if (js.containsKey('data') &&
                                          p['data']['status'] >= 400) {
                                        Navigator.of(context).pop();

                                        Get.snackbar(
                                          'Something went wrong',
                                          '',
                                          colorText: kWhiteColor,
                                        );
                                      } else {
                                        store(p, context);
                                        firstNameController.clear();
                                        lastNameController.clear();
                                      }
                                      print('ok');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            ProfileRowWidget(
              title: 'Log Out',
              icon: Icons.logout,
              onPress: () {
                Get.defaultDialog(
                  title: 'Are you sure?',
                  content: const Text('It will logout from your account!'),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        prefs!.clear();
                        Navigator.pushNamedAndRemoveUntil(
                            context, LoginScreen.routeName, (route) => false);
                      },
                      child: const Text("Confirm"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ],
                );
              },
            ),
            ProfileRowWidget(
              title: 'Exit',
              icon: Icons.exit_to_app,
              onPress: () {
                Get.defaultDialog(
                  title: 'Are you sure?',
                  content: const Text('It will exit from app!'),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                      ),
                      onPressed: () {
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else if (Platform.isIOS) {
                          exit(0);
                        }
                      },
                      child: const Text("Confirm"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void store(var mat, BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString('fName', mat['first_name'].toString());
    prefs!.setString('lName', mat['last_name'].toString());
    prefs!.setString('id', mat['id'].toString());
    Navigator.pop(context);
    Navigator.pop(context);
    setState(() {});
    Get.snackbar(
      'Profile Update Successfully',
      '',
      colorText: kWhiteColor,
    );
  }
}
