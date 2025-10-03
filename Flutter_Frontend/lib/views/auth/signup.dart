import 'package:flutter/material.dart';
import 'package:hajj_and_umrah/Api%20Handler/ApiHelper.dart';
import 'package:hajj_and_umrah/CustomWidgets/CustomButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hajj_and_umrah/CustomWidgets/CutomTextFormField.dart';
import 'package:hajj_and_umrah/views/auth/otpscreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var emailcon = TextEditingController();
  var passwordcon = TextEditingController();
  var namecon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: screenSize.width * 0.3,
            left: 0,
            right: screenSize.width * 0.14,
            child: Image.asset(
              'lib/assets/images/kaaba.png',
              width: screenSize.width,
              height: screenSize.height * 0.5,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.08,
                vertical: screenSize.width * 0.09,
              ),
              height: screenSize.height * 0.51,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenSize.width * 0.08),
                  topRight: Radius.circular(screenSize.width * 0.08),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hint: appLocalizations!.textfield1,
                      icon: Icons.person,
                      obscureText: false,
                      controller: namecon,
                    ),
                    SizedBox(height: screenSize.width * 0.08),
                    CustomTextField(
                      hint: appLocalizations.textfield2,
                      icon: Icons.email,
                      obscureText: false,
                      controller: emailcon,
                    ),
                    SizedBox(height: screenSize.width * 0.08),
                    CustomTextField(
                      hint: appLocalizations.textfield3,
                      icon: Icons.password,
                      obscureText: true,
                      controller: passwordcon,
                    ),
                    SizedBox(height: screenSize.width * 0.08),
                    CustomButton(
                      text: appLocalizations.signupbutton,
                      onTap: () async {
                        Map<String, dynamic> data =
                            await APiHelper().SendOtp(emailcon.text);
                        if (data != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                  email: emailcon.text,
                                  name: namecon.text,
                                  password: passwordcon.text,
                                  otp: data["otp"]),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
